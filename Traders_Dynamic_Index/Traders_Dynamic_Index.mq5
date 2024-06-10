//+------------------------------------------------------------------+
//|                                        Traders_Dynamic_Index.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                                 https://mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com"
#property version   "1.00"
#property description "Traders Dynamic Index oscillator"
#property indicator_separate_window
#property indicator_buffers 7
#property indicator_plots   5
//--- plot TRSI
#property indicator_label1  "RSI Price"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Signal
#property indicator_label2  "Trade Signal"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot UP
#property indicator_label3  "VolBand High"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrDeepSkyBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot MD
#property indicator_label4  "Market Base"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrOrchid
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot DN
#property indicator_label5  "VolBand Low"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrDeepSkyBlue
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- enums
enum ENUM_INPUT_YES_NO
  {
    INPUT_YES   =  DRAW_LINE, // Yes
    INPUT_NO    =  DRAW_NONE  // No
  };
//--- input parameters
input uint                 InpPeriodRSI         =  13;            // RSI period
input ENUM_APPLIED_PRICE   InpAppliedPriceRSI   =  PRICE_CLOSE;   // RSI applied price
input uint                 InpPeriodVolBand     =  34;            // Volatility band period
input uint                 InpPeriodSmRSI       =  2;             // RSI smoothing period
input ENUM_MA_METHOD       InpMethodSmRSI       =  MODE_SMA;      // RSI smoothing method
input uint                 InpPeriodSmSig       =  7;             // Signal smoothing period
input ENUM_MA_METHOD       InpMethodSmSig       =  MODE_SMA;      // Signal smoothing method
input double               InpOverbought        =  68;            // Overbought
input double               InpOversold          =  32;            // Oversold
input ENUM_INPUT_YES_NO    InpShowBase          =  INPUT_YES;      // Show Market Base line
input ENUM_INPUT_YES_NO    InpShowVBL           =  INPUT_YES;      // Show Volatility band lines
//--- indicator buffers
double         BufferTRSI[];
double         BufferSignal[];
double         BufferUpZone[];
double         BufferMdZone[];
double         BufferDnZone[];
double         BufferRSI[];
double         BufferTmpRSI[];
//--- global variables
double         overbought;
double         oversold;
int            period_rsi;
int            period_vb;
int            period_sm_rsi;
int            period_sm_sig;
int            handle_rsi;
int            weight_sumR;
int            weight_sumS;
//--- includes
#include <MovingAverages.mqh>
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- set global variables
   period_rsi=int(InpPeriodRSI<2 ? 2 : InpPeriodRSI);
   period_vb=int(InpPeriodVolBand<1 ? 1 : InpPeriodVolBand);
   period_sm_rsi=int(InpPeriodSmRSI<2 ? 2 : InpPeriodSmRSI);
   period_sm_sig=int(InpPeriodSmSig==period_sm_rsi ? period_sm_rsi+1 : InpPeriodSmSig<2 ? 2 : InpPeriodSmSig);
   overbought=(InpOverbought>100 ? 100 : InpOverbought<0.1 ? 0.1 : InpOverbought);
   oversold=(InpOversold<0 ? 0 : InpOversold>=overbought ? overbought-0.1 : InpOversold);
//--- indicator buffers mapping
   SetIndexBuffer(0,BufferTRSI,INDICATOR_DATA);
   SetIndexBuffer(1,BufferSignal,INDICATOR_DATA);
   SetIndexBuffer(2,BufferUpZone,INDICATOR_DATA);
   SetIndexBuffer(3,BufferMdZone,INDICATOR_DATA);
   SetIndexBuffer(4,BufferDnZone,INDICATOR_DATA);
   SetIndexBuffer(5,BufferRSI,INDICATOR_CALCULATIONS);
   SetIndexBuffer(6,BufferTmpRSI,INDICATOR_CALCULATIONS);
//--- setting indicator parameters
   IndicatorSetString(INDICATOR_SHORTNAME,"TDI ("+(string)period_rsi+","+(string)period_vb+","+(string)period_sm_rsi+","+(string)period_sm_sig+")");
   IndicatorSetInteger(INDICATOR_DIGITS,Digits());
   IndicatorSetInteger(INDICATOR_LEVELS,3);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,overbought);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,50);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,2,oversold);
   IndicatorSetString(INDICATOR_LEVELTEXT,0,"Overbought");
   IndicatorSetString(INDICATOR_LEVELTEXT,2,"Oversold");
//--- setting plot buffer parameters
   PlotIndexSetInteger(2,PLOT_DRAW_TYPE,DRAW_LINE);
   PlotIndexSetInteger(3,PLOT_DRAW_TYPE,DRAW_LINE);
   PlotIndexSetInteger(4,PLOT_DRAW_TYPE,DRAW_LINE);
//--- setting buffer arrays as timeseries
   ArraySetAsSeries(BufferTRSI,true);
   ArraySetAsSeries(BufferSignal,true);
   ArraySetAsSeries(BufferUpZone,true);
   ArraySetAsSeries(BufferMdZone,true);
   ArraySetAsSeries(BufferDnZone,true);
   ArraySetAsSeries(BufferRSI,true);
   ArraySetAsSeries(BufferTmpRSI,true);
//--- create Stochastic, RSI handles
   ResetLastError();
   handle_rsi=iRSI(NULL,PERIOD_CURRENT,period_rsi,InpAppliedPriceRSI);
   if(handle_rsi==INVALID_HANDLE)
     {
      Print("The iRSI(",(string)period_rsi,") object was not created: Error ",GetLastError());
      return INIT_FAILED;
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//--- Проверка и расчёт количества просчитываемых баров
   if(rates_total<fmax(period_vb,4)) return 0;
//--- Проверка и расчёт количества просчитываемых баров
   int limit=rates_total-prev_calculated;
   if(limit>1)
     {
      limit=rates_total-period_vb-2;
      ArrayInitialize(BufferTRSI,0);
      ArrayInitialize(BufferSignal,0);
      ArrayInitialize(BufferUpZone,0);
      ArrayInitialize(BufferMdZone,0);
      ArrayInitialize(BufferDnZone,0);
      ArrayInitialize(BufferRSI,0);
      ArrayInitialize(BufferTmpRSI,0);
     }
//--- Подготовка данных
   int count=(limit>1 ? rates_total : 1),copied=0;
   copied=CopyBuffer(handle_rsi,0,0,count,BufferRSI);
   if(copied!=count) return 0;
   for(int i=limit; i>=0 && !IsStopped(); i--)
     {
      double MA=0;
      for(int j=i; j<i+period_vb; j++) 
        {
         BufferTmpRSI[j-i]=BufferRSI[j];
         MA+=BufferRSI[j]/period_vb;
        }
      BufferUpZone[i]=(MA + (1.6185 * StDev(BufferTmpRSI,period_vb)));
      BufferDnZone[i]=(MA - (1.6185 * StDev(BufferTmpRSI,period_vb)));
      BufferMdZone[i]=((BufferUpZone[i]+BufferDnZone[i])/2);
     }
    // ChartIndicatorAdd
//--- Расчёт индикатора
   switch(InpMethodSmRSI)
     {
      case MODE_EMA  :  if(ExponentialMAOnBuffer(rates_total,prev_calculated,period_rsi,period_sm_rsi,BufferRSI,BufferTRSI)==0) return 0;                  break;
      case MODE_SMMA :  if(SmoothedMAOnBuffer(rates_total,prev_calculated,period_rsi,period_sm_rsi,BufferRSI,BufferTRSI)==0) return 0;                     break;
      case MODE_LWMA :  if(LinearWeightedMAOnBuffer(rates_total,prev_calculated,period_rsi,period_sm_rsi,BufferRSI,BufferTRSI,weight_sumR)==0) return 0;   break;
      //---MODE_SMA
      default        :  if(SimpleMAOnBuffer(rates_total,prev_calculated,period_rsi,period_sm_rsi,BufferRSI,BufferTRSI)==0) return 0;                       break;
     }
   switch(InpMethodSmSig)
     {
      case MODE_EMA  :  if(ExponentialMAOnBuffer(rates_total,prev_calculated,period_rsi,period_sm_sig,BufferRSI,BufferSignal)==0) return 0;                  break;
      case MODE_SMMA :  if(SmoothedMAOnBuffer(rates_total,prev_calculated,period_rsi,period_sm_sig,BufferRSI,BufferSignal)==0) return 0;                     break;
      case MODE_LWMA :  if(LinearWeightedMAOnBuffer(rates_total,prev_calculated,period_rsi,period_sm_sig,BufferRSI,BufferSignal,weight_sumS)==0) return 0;   break;
      //---MODE_SMA
      default        :  if(SimpleMAOnBuffer(rates_total,prev_calculated,period_rsi,period_sm_sig,BufferRSI,BufferSignal)==0) return 0;                       break;
     }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double StDev(double &Data[],const int period)
  {
   return(sqrt(Variance(Data,period)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Variance(double &Data[],const int period)
  {
   double sum=0,ssum=0;
   for(int i=0; i<period; i++)
     {
      sum+=Data[i];
      ssum+=pow(Data[i],2);
     }
   return(ssum*period-sum*sum)/(period*(period-1));
  }
//+------------------------------------------------------------------+
