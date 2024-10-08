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
double val = 1;
void OnTick()
  {
   double open1, close5, range;
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
      double takeProfit = 2 * diff;
      double stopLoss;

      if (open1 < close5)  // 做多條件
        {
         double tp_price = close5 + takeProfit;
         stopLoss = close5 - stopLossValue;  // 設定止損點
         trade.Buy(0.1, Symbol(), close5, stopLoss, tp_price, "Buy Trade");
        }
      else if (open1 > close5)  // 做空條件
        {
         double tp_price = close5 - takeProfit;
         stopLoss = close5 + stopLossValue;  // 設定止損點
         trade.Sell(0.1, Symbol(), close5, stopLoss, tp_price, "Sell Trade");
        }
     }
  }