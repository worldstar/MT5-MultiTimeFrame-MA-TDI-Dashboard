//+------------------------------------------------------------------+
//|                                                   TDI_expert.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>                                         //include the library for execution of trades
#include <Trade\PositionInfo.mqh>                                  //include the library for obtaining information on positions
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

double            Close_buf[];
string            my_symbol;                                       //variable for storing the symbol
ENUM_TIMEFRAMES   my_timeframe;                                    //variable for storing the time frame

CTrade            m_Trade;                                         //structure for execution of trades
CPositionInfo     m_Position;                                      //structure for obtaining information of positions
datetime lastbar_timeopen;

int handle,iADX_handle,ZigZag_handel,high_handle;
double ADXBuffer[],DI_plusBuffer[],DI_minusBuffer[],ZigZag_buffer[],high_buffer[];
double iRSIprice[],iTrade_signal[],volume_high[],volume_base[],volume_low[],zigzag[];

   input int ADX_standard=25;
   input int DI_standard=20;
   input double DI_gap=7.50/*8.50*/;
   input int ADXlength=14;
  
   input int bars=50;
   input uint                 InpPeriodRSI         =  18/*13*/ ;            // RSI period
   input ENUM_APPLIED_PRICE   InpAppliedPriceRSI   =  PRICE_CLOSE;   // RSI applied price
   input uint                 InpPeriodVolBand     =  34;            // Volatility band period
   input uint                 InpPeriodSmRSI       =  5/*2*/;             // RSI smoothing period
   input ENUM_MA_METHOD       InpMethodSmRSI       =  MODE_SMA;      // RSI smoothing method
   input uint                 InpPeriodSmSig       =  10/*7*/;             // Signal smoothing period
   input ENUM_MA_METHOD       InpMethodSmSig       =  MODE_SMA;      // Signal smoothing method
   input double               InpOverbought        =  68;            // Overbought
   input double               InpOversold          =  32;            // Oversold
int OnInit()
  {
   string name = "Traders_Dynamic_Index.ex5";
   string zigzga = "zigzag.ex5";
   handle = iCustom(_Symbol,PERIOD_CURRENT,name,InpPeriodRSI,InpAppliedPriceRSI,InpPeriodVolBand,InpPeriodSmRSI,InpMethodSmRSI,InpPeriodSmSig,InpMethodSmSig,InpOverbought,InpOversold);
   
   iADX_handle = iADX(_Symbol,PERIOD_CURRENT,ADXlength);
   
   
   ChartIndicatorAdd(ChartID(),0,iADX_handle);
   ArraySetAsSeries(ADXBuffer,true);
   ArraySetAsSeries(DI_plusBuffer,true);
   ArraySetAsSeries(DI_minusBuffer,true);
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   IndicatorRelease(iADX_handle);
   
   ArrayFree(ADXBuffer); 
   ArrayFree(DI_plusBuffer); 
   ArrayFree(DI_minusBuffer);
   //ArrayFree(ZigZag_buffer); 
  }
  
  
 bool isNewBar(const bool print_log=true)
  {
   static datetime bartime=0; //存储当前柱形图的开盘时间
//--- 获得零柱的开盘时间
   datetime currbar_time=iTime(_Symbol,_Period,0);
//--- 如果开盘时间更改，则新柱形图出现
   if(bartime!=currbar_time)
     {
      bartime=currbar_time;
      lastbar_timeopen=bartime;
      //--- 在日志中显示新柱形图开盘时间的数据      
      if(print_log && !(MQLInfoInteger(MQL_OPTIMIZATION)||MQLInfoInteger(MQL_TESTER)))
        {
         //--- 显示新柱形图开盘时间的信息
         PrintFormat("%s: new bar on %s %s opened at %s",__FUNCTION__,_Symbol,
                     StringSubstr(EnumToString(_Period),7),
                     TimeToString(TimeCurrent(),TIME_SECONDS));
         //--- 获取关于最后报价的数据
         MqlTick last_tick;
         if(!SymbolInfoTick(Symbol(),last_tick))
            Print("SymbolInfoTick() failed, error = ",GetLastError());
         //--- 显示最后报价的时间，精确至毫秒
         PrintFormat("Last tick was at %s.%03d",
                     TimeToString(last_tick.time,TIME_SECONDS),last_tick.time_msc%1000);
        }
      //--- 我们有一个新柱形图
      return (true);
     }
//--- 没有新柱形图
   return (false);
  }
  
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  { 
   int copy=0;
   double sl=0;
   int position=0;
   my_symbol=Symbol();                                             //save the current chart symbol for further operation of the EA on this very symbol
   my_timeframe=PERIOD_CURRENT;

   //double hig_low_standard;
   
   CopyBuffer(handle,0,1,bars,iRSIprice);
   CopyBuffer(handle,1,1,bars,iTrade_signal);
   CopyBuffer(handle,2,1,bars,volume_high);
   CopyBuffer(handle,3,1,bars,volume_base);
   CopyBuffer(handle,4,1,bars,volume_low);
   CopyBuffer(iADX_handle,0,1,bars,ADXBuffer);
   CopyBuffer(iADX_handle,1,1,bars,DI_plusBuffer);
   CopyBuffer(iADX_handle,2,1,bars,DI_minusBuffer);

   copy=CopyClose(my_symbol,my_timeframe,0,bars+150,Close_buf);
   high_handle = CopyHigh(my_symbol,my_timeframe,0,bars,high_buffer);
   
   Comment("\n RSI price:",iRSIprice[bars-1],
           "\n Trade_signal:",iTrade_signal[bars-1],
           "\n volume_high:",volume_high[bars-1],
           "\n volume_base:",volume_base[bars-1],
           "\n volume_low:",volume_low[bars-1]);
   if(!isNewBar(false)) return;
   
  
      
   for(int i=bars-1;i>=0;i--){  
      
         if(iRSIprice[i]>iTrade_signal[i] && iRSIprice[i]>iRSIprice[i-1]){
                  if(ADXBuffer[i]<ADX_standard)return;
                  if(ADXBuffer[i]<ADXBuffer[i-1])return;
                  if(fabs(DI_plusBuffer[i]-DI_minusBuffer[i])<DI_gap)return;
                  if(ADXBuffer[i]>=ADXBuffer[i-1]){
                     if(DI_plusBuffer[i]<DI_standard)return;
                     if(DI_minusBuffer[i]>DI_standard )return;
                  }
                  while(Close_buf[i]>Close_buf[i+1])//往前找前低,止損
                  {
                  i++;
                  sl = Close_buf[i];
                  }
                  double cur = m_Position.PriceCurrent();//現價
                  double std = MathAbs(cur-sl)*3;//差距*3
                  double tp = cur+std;//止盈
                  if(m_Position.Select(my_symbol)){
                     if(m_Position.PositionType()==POSITION_TYPE_SELL) m_Trade.PositionClose(my_symbol);   //and this is a Buy position, then close it
                     if(m_Position.PositionType()==POSITION_TYPE_BUY) return;
                  }
               m_Trade.Buy(0.1,my_symbol,cur,sl,tp);
               return;
                  
                   
         }else  if(iRSIprice[i]<iTrade_signal[i] && iRSIprice[i]<iRSIprice[i-1]&&iRSIprice[i-1]>iTrade_signal[i-1]){
         
                  if(ADXBuffer[i]<ADX_standard)return;
                  if(ADXBuffer[i]<ADXBuffer[i-1])return;
                  if(fabs(DI_plusBuffer[i]-DI_minusBuffer[i])<DI_gap)return;
                  if(ADXBuffer[i]>ADXBuffer[i-1]){
                     if(DI_minusBuffer[i]<DI_standard )return;
                     if(DI_plusBuffer[i]>DI_standard )return;
                  }
                  while(Close_buf[i]<Close_buf[i+1])//往前找前高,止損
                  {
                     i++;
                     sl = Close_buf[i];
                  }
                  double cur = m_Position.PriceCurrent();//現價
                  double std = MathAbs(cur-sl)*2;//差距*3
                  double tp = cur-std;//止盈*/
                  if(m_Position.Select(my_symbol)){
                     if(m_Position.PositionType()==POSITION_TYPE_BUY)m_Trade.PositionClose(my_symbol);
                     if(m_Position.PositionType()==POSITION_TYPE_SELL) return;
                  }
                  m_Trade.Sell(0.1,my_symbol,cur,sl,tp);
                  return;  
                  
               
         }
      
         
   }
      
   
  }
//+------------------------------------------------------------------+
