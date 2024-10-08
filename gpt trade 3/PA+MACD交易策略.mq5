#include <Trade\Trade.mqh>
double Ask,Bid; 
CTrade trade;
// 控制變數
bool inTrade = false;        // 是否已經有交易
double takeProfitPips = 400; // 設定止盈點位（點數）

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("MACD Strategy Initialized");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(inTrade)  // 如果已經有交易，返回
      return;

   // 打印當前 Bid 和 Ask 值，確認是否有效
   Print("Current Bid: ", Bid, " | Current Ask: ", Ask);

   // 如果 Bid 或 Ask 值為 0，則嘗試從市場信息中獲取
   if(Bid == 0 || Ask == 0)
     {
      Print("Bid or Ask is zero, fetching from market information.");
      Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
     }

   // MACD 參數
   static double macdMain[], macdSignal[], macdHist[];
   int macdHandle = iMACD(_Symbol, PERIOD_M5, 12, 26, 9, PRICE_CLOSE);  // 獲取MACD句柄

   if(macdHandle == INVALID_HANDLE)
     {
      Print("Error in MACD Handle");
      return;
     }

   ArraySetAsSeries(macdMain, true);
   ArraySetAsSeries(macdSignal, true);
   ArraySetAsSeries(macdHist, true);

   if(CopyBuffer(macdHandle, 2, 0, 2, macdHist) < 2)  // 確認 MACD 柱狀圖獲取成功
     {
      Print("Failed to get MACD histogram");
      return;
     }

   // 打印 MACD 柱狀圖數據，確認是否正確
   Print("MACD Histogram: ", macdHist[0], ", ", macdHist[1]);

   // 判斷是否從正數轉為負數（賣出），或者從負數轉為正數（買入）
   if(macdHist[1] > 0 && macdHist[0] < 0)
     {
      Print("Detected Bearish Trend Change - Selling");
      PlaceSellOrder();
     }
   else if(macdHist[1] < 0 && macdHist[0] > 0)
     {
      Print("Detected Bullish Trend Change - Buying");
      PlaceBuyOrder();
     }
  }

//+------------------------------------------------------------------+
//| 賣出訂單邏輯                                                     |
//+------------------------------------------------------------------+
void PlaceSellOrder()
  {
   double lotSize = 0.1;
   double openPrice = iOpen(_Symbol, PERIOD_M5, 0);  // 當前 K 線的開盤價
   double sl = openPrice;                            // 設定止損為開盤價
   double tp = openPrice - takeProfitPips * _Point;  // 設定止盈為開盤價減固定點數

   Print("Sell Order | OpenPrice: ", openPrice, " | SL: ", sl, " | TP: ", tp);

   if(!trade.Sell(lotSize, _Symbol, Bid, sl, tp, "Sell Order"))
      Print("Sell Order Failed, Error: ", GetLastError());
   else
     {
      Print("Sell Order Placed Successfully");
      inTrade = true;  // 記錄交易狀態
     }
}

//+------------------------------------------------------------------+
//| 買入訂單邏輯                                                     |
//+------------------------------------------------------------------+
void PlaceBuyOrder()
  {
   double lotSize = 0.1;
   double openPrice = iOpen(_Symbol, PERIOD_M5, 0);  // 當前 K 線的開盤價
   double sl = openPrice;                            // 設定止損為開盤價
   double tp = openPrice + takeProfitPips * _Point;  // 設定止盈為開盤價加固定點數

   Print("Buy Order | OpenPrice: ", openPrice, " | SL: ", sl, " | TP: ", tp);

   if(!trade.Buy(lotSize, _Symbol, Ask, sl, tp, "Buy Order"))
      Print("Buy Order Failed, Error: ", GetLastError());
   else
     {
      Print("Buy Order Placed Successfully");
      inTrade = true;  // 記錄交易狀態
     }
}
