//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
ENUM_TIMEFRAMES   timeframe;
#define OP_BUY 0
#define OP_SELL 0
input int a=3;
input float b=0.1;
CTrade trade;

int OnInit()
  {
   //--- create timer
   EventSetTimer(60); // Check every minute
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   //--- destroy timer
   EventKillTimer();
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
  {
   // Set the timeframe to H4 (4 hours)
   timeframe = PERIOD_H4;
         int count=0;
   // Declare EMA variables
   double ema5[], ema8[], ema13[];

   // Calculate EMAs
   int ema5_handle = iMA(NULL, timeframe, 5, 0, MODE_EMA, PRICE_CLOSE);
   int ema8_handle = iMA(NULL, timeframe, 8, 0, MODE_EMA, PRICE_CLOSE);
   int ema13_handle = iMA(NULL, timeframe, 13, 0, MODE_EMA, PRICE_CLOSE);

   if (CopyBuffer(ema5_handle, 0, 0, 3, ema5) <= 0 ||
       CopyBuffer(ema8_handle, 0, 0, 3, ema8) <= 0 ||
       CopyBuffer(ema13_handle, 0, 0, 3, ema13) <= 0)
     {
      Print("Failed to get EMA values");
      return;
     }

   // Declare other variables
   double iClose[], iOpen[], iLow[], iHigh[];

   // Get the required data
   int bars = CopyClose(NULL, timeframe, 0, 3, iClose);
   if (bars <= 0)
     {
      Print("Failed to get close prices");
      return;
     }

   bars = CopyOpen(NULL, timeframe, 0, 3, iOpen);
   if (bars <= 0)
     {
      Print("Failed to get open prices");
      return;
     }

   bars = CopyLow(NULL, timeframe, 0, 3, iLow);
   if (bars <= 0)
     {
      Print("Failed to get low prices");
      return;
     }

   bars = CopyHigh(NULL, timeframe, 0, 3, iHigh);
   if (bars <= 0)
     {
      Print("Failed to get high prices");
      return;
     }

   // Check for buy condition
   for (int i =0; i < ArraySize(iClose); i++){
    if (ema5[i] > ema8[i] && ema8[i] > ema13[i])
     {
      count=0;
      for(int j=i;j<ArraySize(iClose);j++)
        {
           if (iClose[j] > iOpen[j]){ // Up candle found
            count++;
            if(count==2){
            double buyPrice = iClose[j];
            double stopLoss = iLow[j];
            double takeProfit = buyPrice + a * MathAbs(buyPrice - stopLoss);

            if (!trade.Buy(b, Symbol(), buyPrice, stopLoss, takeProfit, "Buy Order"))
              {
               Print("Error opening BUY order: ", GetLastError());
              }
            break;
           }
          }else{
            count=0;
          }
           
        }
        }
     }

   // Check for sell condition
   for (int i =0; i < ArraySize(iClose); i++){
    if (ema5[i] < ema8[i] && ema8[i] < ema13[i])
     {
      count=0;
      for(int j=i;j<ArraySize(iClose);j++)
        {
           if (iClose[j] < iOpen[j]){ // Down candle found
            count++;
            if(count==2){
            double sellPrice = iClose[j];
            double stopLoss = iHigh[j];
            double takeProfit = sellPrice - a * MathAbs(stopLoss - sellPrice);

            if (!trade.Sell(b, Symbol(), sellPrice, stopLoss, takeProfit, "Sell Order"))
              {
               Print("Error opening SELL order: ", GetLastError());
              }
            break;
           }
          }else{
            count=0;
          }
           
        }
     }
     }
  }
