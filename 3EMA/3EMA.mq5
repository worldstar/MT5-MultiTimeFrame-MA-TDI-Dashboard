//+------------------------------------------------------------------+
//|                                           fast-start-example.mq5 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>  // 包含交易類別

input double volume = 0.01;         // 交易量
input int EMA1_Period = 10;        // EMA1週期
input int EMA2_Period = 20;        // EMA2週期
input int EMA3_Period = 50;        // EMA3週期
input int ATR_Period = 14;         // ATR週期

input int consolidationMinBars = 10;  // 最短盤整區間
input int consolidationMaxBars = 40;  // 最長盤整區間

CTrade trade;  // 宣告交易物件

int EMA1_handle, EMA2_handle, EMA3_handle, ATR_handle;
double EMA1_buf[], EMA2_buf[], EMA3_buf[], ATR_buf[];

int magicNumber = 111;

//+------------------------------------------------------------------+
//| EA初始化函數                                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // 初始化 EMA 和 ATR 指標
   EMA1_handle = iMA(_Symbol, PERIOD_D1, EMA1_Period, 0, MODE_EMA, PRICE_CLOSE);
   EMA2_handle = iMA(_Symbol, PERIOD_D1, EMA2_Period, 0, MODE_EMA, PRICE_CLOSE);
   EMA3_handle = iMA(_Symbol, PERIOD_D1, EMA3_Period, 0, MODE_EMA, PRICE_CLOSE);
   ATR_handle = iATR(_Symbol, PERIOD_D1, ATR_Period);

   if (EMA1_handle == INVALID_HANDLE || EMA2_handle == INVALID_HANDLE || EMA3_handle == INVALID_HANDLE || ATR_handle == INVALID_HANDLE)
   {
      Print("Failed to initialize handles");
      return INIT_FAILED;
   }

   ArraySetAsSeries(EMA1_buf, true);
   ArraySetAsSeries(EMA2_buf, true);
   ArraySetAsSeries(EMA3_buf, true);
   ArraySetAsSeries(ATR_buf, true);

   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| 檢查是否滿足 EMA 多頭排列條件                                   |
//+------------------------------------------------------------------+
bool checkBullishEMA()
{
   if (EMA1_buf[1] > EMA2_buf[1] && EMA2_buf[1] > EMA3_buf[1])
      return true;
   return false;
}

//+------------------------------------------------------------------+
//| 檢查是否出現盤整階段                                             |
//+------------------------------------------------------------------+
bool checkConsolidation(int startBar, int endBar)
{
   double highest = iHigh(_Symbol, PERIOD_D1, startBar);
   double lowest = iLow(_Symbol, PERIOD_D1, startBar);

   for (int i = startBar + 1; i <= endBar; i++)
   {
      if (iHigh(_Symbol, PERIOD_D1, i) > highest) highest = iHigh(_Symbol, PERIOD_D1, i);
      if (iLow(_Symbol, PERIOD_D1, i) < lowest) lowest = iLow(_Symbol, PERIOD_D1, i);
   }

   double range = highest - lowest;
   if (range <= 0.03 * highest)   // 判斷是否屬於盤整區間
      return true;
   return false;
}

//+------------------------------------------------------------------+
//| 檢查是否突破盤整區間                                              |
//+------------------------------------------------------------------+
bool checkBreakout(int bar)
{
   if (iClose(_Symbol, PERIOD_D1, bar) > iHigh(_Symbol, PERIOD_D1, bar + 1))
      return true;  // 向上突破
   return false;
}

//+------------------------------------------------------------------+
//| 主邏輯函數                                                       |
//+------------------------------------------------------------------+
void OnTick()
{
   int barsToCheck = consolidationMaxBars;
   if (CopyBuffer(EMA1_handle, 0, 0, barsToCheck, EMA1_buf) < 0 ||
       CopyBuffer(EMA2_handle, 0, 0, barsToCheck, EMA2_buf) < 0 ||
       CopyBuffer(EMA3_handle, 0, 0, barsToCheck, EMA3_buf) < 0 ||
       CopyBuffer(ATR_handle, 0, 0, barsToCheck, ATR_buf) < 0)
   {
      Print("Failed to copy indicator data");
      return;
   }

   // 檢查是否符合多頭排列
   if (checkBullishEMA())
   {
      for (int i = consolidationMinBars; i <= consolidationMaxBars; i++)
      {
         if (checkConsolidation(i, i + consolidationMaxBars))
         {
            if (checkBreakout(i))
            {
               double breakoutPrice = iClose(_Symbol, PERIOD_D1, i);
               double stopLoss = iLow(_Symbol, PERIOD_D1, i) - ATR_buf[1];  // 設置止損
               double takeProfit = breakoutPrice + (breakoutPrice - stopLoss) * 2;  // 設置止盈
               
               // 使用 CTrade 類別下單
               trade.Buy(volume, _Symbol, breakoutPrice, stopLoss, takeProfit, "Breakout Buy");

               // 分批止盈邏輯
               // 需要另外編寫止盈邏輯來實現分批止盈
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| EA去初始化函數                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("Deinitializing EA");
}
