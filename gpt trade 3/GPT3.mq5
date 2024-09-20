#include <Trade\Trade.mqh>

CTrade trade;

// 控制變數
bool inTrade = false;        // 是否已經有交易
datetime lastTradeTime = 0;  // 上一次交易時間
double stopLossPips = 200;   // 設定止損點位
double takeProfitPips = 400; // 設定止盈點位
int minTimeBetweenTrades = 600; // 最少交易間隔時間（秒）
double Ask,Bid;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // 獲取當前時間
   datetime currentTime = TimeCurrent();

   // 如果已經有交易且還在有效時間內，不做新交易
   if(inTrade && (currentTime - lastTradeTime) < minTimeBetweenTrades)
      return;

   static double macdMain[], macdSignal[], macdHist[];  // MACD數據
   int macdHandle = iMACD(_Symbol, PERIOD_M5, 12, 26, 9, PRICE_CLOSE);  // 獲取MACD句柄

   if(macdHandle == INVALID_HANDLE)
     {
      Print("Error in MACD Handle");
      return;
     }

   ArraySetAsSeries(macdMain, true);
   ArraySetAsSeries(macdSignal, true);
   ArraySetAsSeries(macdHist, true);

   CopyBuffer(macdHandle, 0, 0, 5, macdMain);
   CopyBuffer(macdHandle, 1, 0, 5, macdSignal);
   CopyBuffer(macdHandle, 2, 0, 5, macdHist);

   // 確認多/空轉換
   if(CheckTrendChange(macdHist))
     {
      // 進行多/空轉換操作
      ManageTrendChange(macdHist);
     }

   // 檢查當前持倉狀況
   CheckTradeStatus();
  }

//+------------------------------------------------------------------+
//| 檢查多/空轉換信號                                                |
//+------------------------------------------------------------------+
bool CheckTrendChange(double &macdHist[])
  {
   // 判斷是否由正數轉為負數（空轉多），或者負數轉為正數（多轉空）
   bool isBullToBear = macdHist[1] > 0 && macdHist[0] < 0;
   bool isBearToBull = macdHist[1] < 0 && macdHist[0] > 0;

   return isBullToBear || isBearToBull;
}

//+------------------------------------------------------------------+
//| 管理多/空轉換操作                                                |
//+------------------------------------------------------------------+
void ManageTrendChange(double &macdHist[])
  {
   if(macdHist[0] < 0 && macdHist[1] > 0)  // 綠柱轉紅柱
     {
      Print("多轉空，進行賣出操作");
      PlaceSellOrder();
     }
   else if(macdHist[0] > 0 && macdHist[1] < 0)  // 紅柱轉綠柱
     {
      Print("空轉多，進行買入操作");
      PlaceBuyOrder();
     }
}

//+------------------------------------------------------------------+
//| 賣出訂單邏輯                                                     |
//+------------------------------------------------------------------+
void PlaceSellOrder()
  {
   double lotSize = 0.1;  // 設置訂單手數
   double sl = Ask + stopLossPips * _Point;  // 設置止損
   double tp = Bid - takeProfitPips * _Point;  // 設置止盈
   double price = Bid;  // 使用賣出價格 Bid

   if(!trade.Sell(lotSize, _Symbol, price, sl, tp, "Sell Order"))
     Print("賣出訂單失敗, 錯誤碼: ", GetLastError());
   else
     {
      Print("賣出訂單成功");
      inTrade = true;  // 記錄交易狀態
      lastTradeTime = TimeCurrent();  // 記錄交易時間
     }
}

//+------------------------------------------------------------------+
//| 買入訂單邏輯                                                     |
//+------------------------------------------------------------------+
void PlaceBuyOrder()
  {
   double lotSize = 0.1;  // 設置訂單手數
   double sl = Bid - stopLossPips * _Point;  // 設置止損
   double tp = Ask + takeProfitPips * _Point;  // 設置止盈
   double price = Ask;  // 使用買入價格 Ask

   if(!trade.Buy(lotSize, _Symbol, price, sl, tp, "Buy Order"))
     Print("買入訂單失敗, 錯誤碼: ", GetLastError());
   else
     {
      Print("買入訂單成功");
      inTrade = true;  // 記錄交易狀態
      lastTradeTime = TimeCurrent();  // 記錄交易時間
     }
}

//+------------------------------------------------------------------+
//| 檢查當前持倉狀況                                                 |
//+------------------------------------------------------------------+
void CheckTradeStatus()
  {
   if(PositionsTotal() == 0)  // 檢查當前是否有未平倉訂單
     {
      inTrade = false;  // 沒有持倉時重置狀態
     }
  }
