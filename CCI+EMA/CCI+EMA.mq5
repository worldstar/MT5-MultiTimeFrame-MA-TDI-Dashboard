//+------------------------------------------------------------------+
//|                                          EMA_CCI_Example.mq5    |
//|                        Copyright 2024, Your Name                  |
//|                       https://www.yourwebsite.com                 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Your Name"
#property link      "https://www.yourwebsite.com"
#property version   "1.00"

// 指標句柄
int emaShortHandle;
int emaLongHandle;
int cciHandle;
int ORDER_BUY;
int ORDER_SELL;
// 指標緩衝區
double emaShortBuf[];
double emaLongBuf[];
double cciBuf[];

// 參數設置
input int shortEMAPeriod = 14;   // 短期EMA期數
input int longEMAPeriod = 28;    // 長期EMA期數
input int cciPeriod = 14;        // CCI期數
input double cciBuyLevel = -100; // CCI買入水平
input double cciSellLevel = 100; // CCI賣出水平
input double lotSize = 0.1;      // 交易手數
input int slippage = 3;          // 滑點
input double stopLossDistance = 50; // 止損距離（點數）
input double takeProfitDistance = 100; // 停利距離（點數）

// 初始化函數
int OnInit()
{
    // 創建EMA和CCI指標句柄
    emaShortHandle = iMA(_Symbol, 0, shortEMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
    emaLongHandle = iMA(_Symbol, 0, longEMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
    cciHandle = iCCI(_Symbol, 0, cciPeriod, PRICE_TYPICAL);
    
    // 檢查指標句柄是否有效
    if (emaShortHandle == INVALID_HANDLE || emaLongHandle == INVALID_HANDLE || cciHandle == INVALID_HANDLE)
    {
        Print("Failed to create indicator handles.");
        return INIT_FAILED;
    }
    
    // 設置指標緩衝區
    ArraySetAsSeries(emaShortBuf, true);
    ArraySetAsSeries(emaLongBuf, true);
    ArraySetAsSeries(cciBuf, true);
    
    return INIT_SUCCEEDED;
}

// 去初始化函數
void OnDeinit(const int reason)
{
    // 釋放指標句柄
    IndicatorRelease(emaShortHandle);
    IndicatorRelease(emaLongHandle);
    IndicatorRelease(cciHandle);
}

// Tick事件處理函數
void OnTick()
{
    // 取得最新指標數據
    if (CopyBuffer(emaShortHandle, 0, 0, 3, emaShortBuf) < 0 ||
        CopyBuffer(emaLongHandle, 0, 0, 3, emaLongBuf) < 0 ||
        CopyBuffer(cciHandle, 0, 0, 3, cciBuf) < 0)
    {
        Print("Failed to copy indicator data.");
        return;
    }

    double shortEMA = emaShortBuf[0];
    double longEMA = emaLongBuf[0];
    double cci = cciBuf[0];
    
    // 買入條件
    if (shortEMA > longEMA && cci < cciBuyLevel)
    {
        // 檢查是否已有持倉
        if (PositionsTotal() == 0)
        {
            double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            double stopLoss = price - stopLossDistance * _Point;
            double takeProfit = price + takeProfitDistance * _Point;

            // 準備訂單參數
            MqlTradeRequest request = {};
            MqlTradeResult result = {};
            request.action = TRADE_ACTION_DEAL;
            request.symbol = _Symbol;
            request.volume = lotSize;
            request.type = ORDER_BUY; // 在此使用數字 0 代替 ORDER_BUY
            request.price = price;
            request.sl = stopLoss;
            request.tp = takeProfit;
            request.deviation = slippage;
            request.type_filling = ORDER_FILLING_FOK;
            request.type_time = ORDER_TIME_GTC;

            // 發送Buy訂單
            if (!OrderSend(request, result))
            {
                Print("Failed to send buy order: ", GetLastError());
            }
        }
    }
    // 賣出條件
    else if (shortEMA < longEMA && cci > cciSellLevel)
    {
        // 檢查是否已有持倉
        if (PositionsTotal() == 0)
        {
            double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            double stopLoss = price + stopLossDistance * _Point;
            double takeProfit = price - takeProfitDistance * _Point;

            // 準備訂單參數
            MqlTradeRequest request = {};
            MqlTradeResult result = {};
            request.action = TRADE_ACTION_DEAL;
            request.symbol = _Symbol;
            request.volume = lotSize;
            request.type = ORDER_SELL; // 在此使用數字 1 代替 ORDER_SELL
            request.price = price;
            request.sl = stopLoss;
            request.tp = takeProfit;
            request.deviation = slippage;
            request.type_filling = ORDER_FILLING_FOK;
            request.type_time = ORDER_TIME_GTC;

            // 發送Sell訂單
            if (!OrderSend(request, result))
            {
                Print("Failed to send sell order: ", GetLastError());
            }
        }
    }
}
