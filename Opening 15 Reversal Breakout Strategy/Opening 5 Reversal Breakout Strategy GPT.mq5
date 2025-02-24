//+------------------------------------------------------------------+
//|                                               First5MinTrade.mq5 |
//|                                    Created by OpenAI Assistant   |
//+------------------------------------------------------------------+
#property strict

#include <Trade\Trade.mqh>

input double Lots = 0.01;               // 交易手數
input double Slippage = 5;              // 允許的滑點
input int MagicNumber = 123456;         // 訂單魔術號
input int ATR_Period = 14;              // 日線ATR週期
CTrade trade;

double First5MinHigh = 0.0, First5MinLow = 0.0, DailyATR = 0.0;
bool First5MinRecorded = false;
datetime LastCheckTime = 0;             // 記錄最後檢查的K棒時間
bool OrderPlacedToday = false;          // 是否已下單
datetime LastLogTime = 0;               // 記錄最後一次日誌寫入時間
datetime LastCheckOrdersTime = 0;       // 記錄最後一次檢查訂單的時間
bool is_first = true;

//紀錄日誌
void WriteToFile(string text)
{
    int handle = FileOpen("TradeLog.txt", FILE_WRITE|FILE_READ|FILE_TXT|FILE_COMMON);
    if (handle != INVALID_HANDLE)
    {
        FileSeek(handle, 0, SEEK_END); // 将指针移动到文件末尾
        FileWrite(handle, TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS) + ": " + text);
        FileClose(handle);
    }
    else
    {
        Print("Error opening file: ", GetLastError());
    }
}

// 計算止損和停利點
double CalculateTP(double entryPrice, double stopLoss, bool isBuy)
{
    return isBuy ? entryPrice + (entryPrice - stopLoss) * 2 : entryPrice - (stopLoss - entryPrice) * 2;
}

// 計算日線ATR
double CalculateDailyATR()
{
    MqlRates dailyRates[];
    int copied = CopyRates(Symbol(), PERIOD_D1, 1, ATR_Period, dailyRates);
    if (copied < ATR_Period)
    {
        Print("Not enough data to calculate ATR.");
        return 0.0;
    }

    double atr = 0.0;
    for (int i = 0; i < ATR_Period; i++)
    {
        atr += dailyRates[i].high - dailyRates[i].low;
    }
    return (atr / ATR_Period) * 0.5; // 取ATR的一半
}

// 刪除所有未結訂單
void DeleteAllPendingOrders()
{
    for (int i = OrdersTotal() - 1; i >= 0; i--)
    {
        ulong ticket = OrderGetTicket(i);
        if (OrderSelect(ticket) &&
            OrderGetInteger(ORDER_MAGIC) == MagicNumber &&
            (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT ||
             OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT))
        {
            trade.OrderDelete(ticket);
        }
    }
}

// 創建SellLimit訂單
void CreateSellLimit()
{
    DeleteAllPendingOrders();

    double stopLoss = First5MinHigh + DailyATR;
    double tp = CalculateTP(First5MinLow, stopLoss, false);

    // 設置魔術號
    trade.SetExpertMagicNumber(MagicNumber);

    if (trade.SellLimit(Lots, First5MinLow, NULL, stopLoss, tp))
    {
        Print("SellLimit order created at ", First5MinLow, " with SL: ", stopLoss, " and TP: ", tp);
        OrderPlacedToday = true;
    }
    else
    {
        Print("Failed to create SellLimit order. Error: ", GetLastError());
    }
}

// 創建BuyLimit訂單
void CreateBuyLimit()
{
    DeleteAllPendingOrders();

    double stopLoss = First5MinLow - DailyATR;
    double tp = CalculateTP(First5MinHigh, stopLoss, true);

    // 設置魔術號
    trade.SetExpertMagicNumber(MagicNumber);

    if (trade.BuyLimit(Lots, First5MinHigh, NULL, stopLoss, tp))
    {
        //Print("BuyLimit order created at ", First5MinHigh, " with SL: ", stopLoss, " and TP: ", tp);
        OrderPlacedToday = true;
    }
    else
    {
        Print("Failed to create BuyLimit order. Error: ", GetLastError());
    }
}

// 確認並設置訂單
void CheckAndSetOrders()
{
    MqlRates rates[];
    datetime time = TimeCurrent();
    int copied = CopyRates(Symbol(), PERIOD_M5, time, 1, rates);
    if (copied < 1)
    {
        Print("Failed to retrieve 5-min rates. Error: ", GetLastError());
        return;
    }

    double currentClose = iClose(Symbol(),0,1);
    /*Print("Checking trade conditions. Current Close: ", currentClose, 
          " | First5MinHigh: ", First5MinHigh, 
          " | First5MinLow: ", First5MinLow);*/
    Print("Open: ", rates[0].open, 
      " High: ", rates[0].high,
      " Low: ", rates[0].low, 
      " Close: ", rates[0].close);

    // 確保當天尚未下單
    if (!OrderPlacedToday) 
    {
        if (currentClose > First5MinHigh)
        {
            CreateBuyLimit();
        }
        else if (currentClose < First5MinLow)
        {
            CreateSellLimit();
        }
        else
        {
            Print("No trade condition met. Current Close: ", currentClose);
        }
    }
    
}

// 初始化5分鐘K棒
void InitializeFirst5MinBar()
{
    if (First5MinRecorded)
        return;

    MqlRates rates[];
    int copied = CopyRates(Symbol(), PERIOD_M5, 0, 1, rates);
    if (copied > 0)
    {
        First5MinHigh = rates[0].high;
        First5MinLow = rates[0].low;
        First5MinRecorded = true;
        Print("@@@@@@@@@@@First 5-minute bar recorded. High: ", First5MinHigh, " | Low: ", First5MinLow, " | time", rates[0].time);

        // 計算日線ATR
        DailyATR = CalculateDailyATR();
        Print("Daily ATR calculated: ", DailyATR);
    }
    else
    {
        Print("Failed to initialize the first 5-minute bar. Error: ", GetLastError());
    }
}

// OnTick 事件函數
void OnTick()
{
    datetime currentTime = TimeCurrent();
    MqlDateTime currentDate, lastCheckedDate;
    TimeToStruct(currentTime, currentDate);
    TimeToStruct(LastCheckTime, lastCheckedDate);

    // 如果是新的一天，重置數據
    if (currentDate.day != lastCheckedDate.day)
    {
        First5MinRecorded = false;
        OrderPlacedToday = false;
        Print("New day detected. Resetting first 5-min bar data.");
    }
   // int min=TIME_MINUTES(TimeCurrent());
    // 初始化5分鐘K棒
    if(currentDate.hour==0&&currentDate.min==4){
      printf("current hour %d, min %d", currentDate.hour, currentDate.min);
      InitializeFirst5MinBar();
     }
    // 每秒檢查條件（不延遲到下一個5分鐘）
    if (First5MinRecorded && !OrderPlacedToday  && currentTime - LastLogTime >= 295)
    {
        CheckAndSetOrders();
        LastLogTime = currentTime;
    }

    // 每5分鐘寫入日誌
    /*if (currentTime - LastLogTime >= 5 * 60)  // 每五分鐘記錄一次
    {
        WriteToFile("First 5 Min High: " + DoubleToString(First5MinHigh, 4) + 
                ", First 5 Min Low: " + DoubleToString(First5MinLow, 4));
        LastLogTime = currentTime;  // 更新最後記錄時間
    }*/

    // 更新最後檢查時間
    LastCheckTime = currentTime;
}


// 初始化函數
int OnInit()
{
    Print("Expert Advisor initialized.");
    EventSetTimer(1); // 設置每秒觸發
    return(INIT_SUCCEEDED);
}

// 去初始化函數
void OnDeinit(const int reason)
{
    WriteToFile("EA Deinitialized. Reason: " + IntegerToString(reason));
    Print("Expert Advisor deinitialized.");
    EventKillTimer();
}
