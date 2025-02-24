//+------------------------------------------------------------------+
//|                                                         gpt2.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
CTrade trade;
int bars;
int sellPositionCount = 0;              // 初始化賣單數量計數
int buyPositionCount = 0;               // 初始化買單數量計數
datetime currentBarTime = iTime(Symbol(), 0, 0); 
input double val = 1.1;
input double n = 1.1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Initialization code
   return(INIT_SUCCEEDED);
   
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // Cleanup code
      
  }
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
  {
  
   double open1, close5, range;
   int totalPositions = PositionsTotal();  // 獲取當前持倉總數
    string symbol = PositionGetSymbol(0);
    if(totalPositions==0){
      sellPositionCount=0;
      buyPositionCount=0;
    }
    else if(totalPositions==1){
      if (PositionSelect(symbol))  // 選擇頭寸
        {
            int positionType = PositionGetInteger(POSITION_TYPE);  // 獲取頭寸類型
            
            if (positionType == POSITION_TYPE_SELL)  // 如果是賣單
            {
                sellPositionCount=1;
                buyPositionCount=0;
            }
            else if (positionType == POSITION_TYPE_BUY)  // 如果是買單
            {
                buyPositionCount=1;
                sellPositionCount=0;
            }
        }
    }else{
       sellPositionCount=1;
       buyPositionCount=1;
    }
   /*bars=Bars;
   
   // 檢查是否有足夠的歷史數據
   if (bars < 5)
     {
      Print("Not enough bars");
      return;
     }*/

   // 取得第一根和第五根K棒的開盤價和收盤價
   open1 = iOpen(Symbol(), PERIOD_CURRENT, 4);
   close5 = iClose(Symbol(), PERIOD_CURRENT, 0);

   // 計算五根K棒的最大振幅
   range = 0;
   for(int i = 0; i < 5; i++)
     {
      double high = iHigh(Symbol(), PERIOD_CURRENT, i);
      double low = iLow(Symbol(), PERIOD_CURRENT, i);
      double candle_range = high - low;
      if(candle_range > range)
         range = candle_range;
     }

   // 計算第一根K棒開盤價減去第五根K棒收盤價的絕對值
   double diff = MathAbs(open1 - close5);

   // 計算止損點 (1/4 的 diff)
   double stopLossValue = val*diff;

   // 檢查是否符合進場條件
   if(diff > range)
     {
      double takeProfit = n * diff;
      double stopLoss;

      if (open1 < close5 && buyPositionCount==0)  // 做多條件
        {
         double tp_price = close5 + takeProfit;
         stopLoss = close5 - stopLossValue;  // 設定止損點
         trade.Buy(0.1, Symbol(), close5, stopLoss, tp_price, "Buy Trade");
        }
      else if (open1 > close5 && sellPositionCount==0)  // 做空條件
        {
         double tp_price = close5 - takeProfit;
         stopLoss = close5 + stopLossValue;  // 設定止損點
         trade.Sell(0.1, Symbol(), close5, stopLoss, tp_price, "Sell Trade");
        }
     }
  }