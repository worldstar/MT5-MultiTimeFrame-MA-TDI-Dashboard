//+------------------------------------------------------------------+
//|                                                      Program.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//--- Library class for creating the graphical interface
#include <EasyAndFastGUI\WndEvents.mqh>
#include <EasyAndFastGUI\TimeCounter.mqh>
//--- A class for trading operations
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>                                  //include the library for obtaining information on positions

int               iMA_handle_h4;   
int               iMA_handle_d1;                                      //variable for storing the indicator handle
int               iMA_handle_h1;
int               iMA_handle_m15;
int               accept_buy=1;
int               accept_sell=1;
double            iMA_buf_h4[];                                       //dynamic array for storing indicator values
double            iMA_buf_h1[];                                       //dynamic array for storing indicator values
double            iMA_buf_d1[];                                       //dynamic array for storing indicator values
double            iMA_buf_m15[];
double            Open_buf_h1[];
double            Open_buf_m15[];
double            Close_buf_d1[];                                     //dynamic array for storing the closing price of each bar
double            Close_buf_h1[];
double            Close_buf_h4[];
double            Close_buf_m15[];
double            Low_buf[];
double            High_buf[];
double            Close_buf[];                                    //variable for storing the symbol
ENUM_TIMEFRAMES   my_timeframe;  
datetime lastbar_timeopen;
string my_symbol;
string sd1="";
string sh1="";
string sh4="";
string sm15="";
string lsd1;
string lsh1;
string lsh4;
string lsm15;
string trade="n";
int ld1;
int lh1;
int lh4;
int lm15;                                       //variable for storing the symbol
ENUM_TIMEFRAMES   time_h4;
ENUM_TIMEFRAMES   time_h1;                                    //variable for storing the time frame
ENUM_TIMEFRAMES   time_d1;
ENUM_TIMEFRAMES   time_m15;

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


CTrade            m_Trade;                                         //structure for execution of trades
CPositionInfo     m_Position;                                      //structure for obtaining information of positions
input int iMA_period=40;
input int Candlestick_num=5;
input int tp_coefficient=3;
input double position_volume=0.1;
input string      symbol_input = "EURUSD,GBPUSD,USDCAD,AUDUSD,USDJPY,NZDUSD,USDCNH,USDDKK,USDMXN";

//+------------------------------------------------------------------+
//| Class for creating an application                                |
//+------------------------------------------------------------------+
class CProgram : public CWndEvents{
private:
   //--- Trading operations
   CTrade            m_trade;
   //--- Time counters
   CTimeCounter      m_counter1;
   CTimeCounter      m_counter2;
   CTimeCounter      m_counter3;
   //--- Symbols for trading
   string            m_symbols;
   //--- Indicator handles
   int               m_handles[];
   //--- Indicator values
   double            m_values[];
   //--- Total symbols
   int               m_symbols_total;
   //--- Current chart handle index
   int               m_current_handle_index;
   //--- Time and ticket of the last checked trade
   datetime          m_last_deal_time;
   ulong             m_last_deal_ticket;
   int symbol1_color_check;
   int test_trend;
   //--- Window
   CWindow           m_window1;
   CWindow           m_window2;
   //--- Tabs
   CTabs             m_tabs2;
   //--- Buttons
   CButton           m_buy;
   CButton           m_sell;
   CButton           m_stop;
   CButton           m_stop_sell;
   CButton           m_trend;
   CButton           m_select;
   
   CComboBox         m_symbol_select;
   CComboBox         m_expert_select;
   //---
public:
                     CProgram(void);
                    ~CProgram(void);
   //--- Initialization/deinitialization
   int               OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   void              OnTickEvent(void);
   //---
   //handle
   double ima_buff_m15[];
   double ima_buff_h4[];
   double ima_buff_h12[];
   double ima_buff_d1[];
   double close_buff_m15[];
   double close_buff_h4[];
   double close_buff_h12[];
   double close_buff_d1[];
   int ima_handle_m15;
   int ima_handle_h4;
   int ima_handle_h12;
   int ima_handle_d1;
   //---input
   int numSymbols;
   string      symbols[];
   string      symbol1;
   string      symbol2;
   string      symbol3;
   //input string symbol;
   int         Symbol_trade[];
   int         Trade_method[];
public:
   //--- Create the graphical interface
   bool              CreateGUI(void);
   //--- if trend change
   int               m_check_trend;
private:
   //--- Form
   bool              CreateWindow1(const string text);
   bool              CreateWindow2(const string text);
   //--- Tabs
   bool              CreateTabs2(const int x_gap,const int y_gap);
   //--- Buttons
   bool              CreateBuy(const int x_gap,const int y_gap,const string text);
   bool              CreateSell(const int x_gap,const int y_gap,const string text);
   bool              CreateStop(const int x_gap,const int y_gap,const string text);
   bool              CreateStop_sell(const int x_gap,const int y_gap,const string text);
   bool              CreateSelect(const int x_gap,const int y_gap,const string text);
   //---Button press
   bool              OnBuy(const long id);
   bool              OnSell(const long id);
   bool              OnStop(const long id);
   bool              OnStop_sell(const long id);
   
   bool              CreateSymbolSelect(const int x_gap,const int y_gap,const string text);
   bool              CreateExpertSelect(const int x_gap,const int y_gap,const string text);
   //--- Get handles
   //void              GetHandles(void);
   //----buy,sell button press
   void              buy_press();
   void              sell_press();
   void              stop_press();
   void              stop_sell_press();
protected:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
};
  
#include "CreateGUI.mqh"
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CProgram::CProgram(void) : m_symbols_total(0),
                           m_current_handle_index(WRONG_VALUE),
                           m_last_deal_time(NULL),
                           m_last_deal_ticket(WRONG_VALUE){
//--- Setting parameters for the time counters
   m_counter1.SetParameters(16,500);
   m_counter2.SetParameters(16,3000);
   m_counter3.SetParameters(16,1000);
//---
   m_trade.SetAsyncMode(true);
   m_trade.SetDeviationInPoints(INT_MAX);
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CProgram::~CProgram(void){

}
//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
int CProgram::OnInitEvent(void){
   numSymbols = StringSplit(symbol_input, ',', symbols);
   ArrayResize(Symbol_trade, numSymbols);
   ArrayResize(Trade_method, numSymbols);
   ArrayInitialize(Symbol_trade, 3);
   ArrayInitialize(Trade_method, 1);
   string name = "Traders_Dynamic_Index.ex5";
   string zigzga = "zigzag.ex5";
   handle = iCustom(_Symbol,PERIOD_CURRENT,name,InpPeriodRSI,InpAppliedPriceRSI,InpPeriodVolBand,InpPeriodSmRSI,InpMethodSmRSI,InpPeriodSmSig,InpMethodSmSig,InpOverbought,InpOversold);
   iADX_handle = iADX(_Symbol,PERIOD_CURRENT,ADXlength);
   ChartIndicatorAdd(ChartID(),0,iADX_handle);
   ArraySetAsSeries(ADXBuffer,true);
   ArraySetAsSeries(DI_plusBuffer,true);
   ArraySetAsSeries(DI_minusBuffer,true);
   
   return(0);
}
//+------------------------------------------------------------------+
//| Deinitialization                                                 |
//+------------------------------------------------------------------+
void CProgram::OnDeinitEvent(const int reason){
//--- Remove the interface

   IndicatorRelease(iMA_handle_d1);                                   //deletes the indicator handle and deallocates the memory space it occupies
   IndicatorRelease(iMA_handle_h1);
   IndicatorRelease(iMA_handle_h4);
   IndicatorRelease(iMA_handle_m15);
   IndicatorRelease(iADX_handle);

   ArrayFree(ADXBuffer); 
   ArrayFree(DI_plusBuffer); 
   ArrayFree(DI_minusBuffer);
   ArrayFree(iMA_buf_d1);                                             //free the dynamic array iMA_buf of data
   ArrayFree(iMA_buf_h1);
   ArrayFree(iMA_buf_h4);
   ArrayFree(iMA_buf_m15);
   ArrayFree(Open_buf_h1);
   ArrayFree(Open_buf_m15);
   ArrayFree(Close_buf_d1);                                           //free the dynamic array Close_buf of data
   ArrayFree(Close_buf_h1);
   ArrayFree(Close_buf_h4);
   ArrayFree(Close_buf_m15);
   ArrayFree(Low_buf);
   ArrayFree(High_buf);
   CWndEvents::Destroy();
}
bool math(int a1,int a2,int a3);
bool math(int a1,int a2,int a3){
   int A=a1+a2+a3;
   if(A==3)
      return true;
   else
      return false;
}
bool mathpastr(int a1,int a2,int a3);
bool mathpastr(int a1,int a2,int a3){
   int num=0;
   if(a1==1){num++;}
   if(a2==1){num++;}
   if(a3==1){num++;}
   if((a1==a2||a2==a3||a3==a1) && num==2)
      return true;
   else
      return false;
}
bool mathpastd(int a1,int a2,int a3);
bool mathpastd(int a1,int a2,int a3){
   int num=0;
   if(a1==0){num++;}
   if(a2==0){num++;}
   if(a3==0){num++;}
   if((a1==a2||a2==a3||a3==a1) && num==2)
      return true;
   else
      return false;
}
bool isNewBar(const string symbol,const ENUM_TIMEFRAMES period);
bool isNewBar(const string symbol,const ENUM_TIMEFRAMES period){
//--- Static variables used to save history bar time
   static datetime time_OldBar = 0;  
  
//--- used to save the latest bar time
   datetime time_NewBar = 0;     //Latest bar time
   long     var = 0;             //Temporary variables
  
//--- SeriesInfoInteger() this function runs the fastest, so use it
   if(!SeriesInfoInteger(symbol,period,SERIES_LASTBAR_DATE,var))
      {
      ResetLastError();
      Print("Error in obtaining the latest bar time. Code：",GetLastError());
      }
      else time_NewBar = datetime(var);
  
//--- First function call, assign a value
   if(time_OldBar == 0)
     {
      time_OldBar = time_NewBar;
      return(false);
     }
    
//--- The time of new and old bar is different, it means there is a new bar, or is not a new bar
   if(time_OldBar != time_NewBar)
     {
      time_OldBar = time_NewBar;
      return(true);
     }
     else return(false);
  }
void CProgram::OnTickEvent(void){
   for (int i = 0; i < numSymbols; i++){
      my_symbol=symbols[i];      
      if(Symbol_trade[i]==1){                                       //save the current chart symbol for further operation of the EA on this very symbol
         time_h1=PERIOD_H1;//時區                                    //save the current time frame of the chart for further operation of the EA on this very time frame
         time_d1=PERIOD_H12;
         time_h4=PERIOD_H4;
         time_m15=PERIOD_M15;  
         iMA_handle_h1=iMA(my_symbol,time_h1,iMA_period,0,MODE_SMA,PRICE_CLOSE);  //apply the indicator and get its handle(40為40根k棒)
         iMA_handle_d1=iMA(my_symbol,time_d1,iMA_period,0,MODE_SMA,PRICE_CLOSE);
         iMA_handle_h4=iMA(my_symbol,time_h4,iMA_period,0,MODE_SMA,PRICE_CLOSE);
         iMA_handle_m15=iMA(my_symbol,time_m15,iMA_period,0,MODE_SMA,PRICE_CLOSE);
         ChartIndicatorAdd(ChartID(),0,iMA_handle_h4);                      //add the indicator to the price chart
         ArraySetAsSeries(iMA_buf_d1,true);                                 //set iMA_buf array indexing as time series
         ArraySetAsSeries(iMA_buf_h1,true);                                 //set iMA_buf array indexing as time series
         ArraySetAsSeries(iMA_buf_h4,true);                                 //set iMA_buf array indexing as time series
         ArraySetAsSeries(iMA_buf_m15,true);
         ArraySetAsSeries(Open_buf_h1,true);
         ArraySetAsSeries(Open_buf_m15,true);
         ArraySetAsSeries(Close_buf_d1,true);                               //set Close_buf array indexing as time series
         ArraySetAsSeries(Close_buf_h1,true);
         ArraySetAsSeries(Close_buf_h4,true);                                 //set iMA_buf array indexing as time series
         ArraySetAsSeries(Close_buf_m15,true);
         ArraySetAsSeries(Low_buf,true);
         ArraySetAsSeries(High_buf,true);
         if(isNewBar(my_symbol,time_m15)){
            int err1=0;                                                     //variable for storing the results of working with the indicator buffer
            int err2=0;                                                     //variable for storing the results of working with the price chart
            int err3=0;
            int err4=0;
            int err5=0;
            int err6=0;
            int err7=0;
            int err8=0;
            int err9=0;
            int err10=0;
            int err11=0;
            int err12=0;
            double sl=0;
            int i = 0;
            int buyd1=0;
            int buyh4=0;
            int buyh1=0;
            int buym15=0;
            int selld1=0;
            int sellh4=0;
            int sellh1=0;
            int sellm15=0; 
            int ld1;
            int lh4;
            int lh1;
            int lm15;
            int handle;
            double ma;
            double cur;
            double std;
            double tp;
            string commentbuy="";  
            string commentsell="";
            MqlTick last_tick;
            // MqlTick Latest_Price;
            // SymbolInfoTick(Symbol() ,Latest_Price);
            err1=CopyBuffer(iMA_handle_d1,0,0,3,iMA_buf_d1);                      //copy data from the indicator array into the dynamic array iMA_buf for further work with them
            err2=CopyBuffer(iMA_handle_h1,0,0,3,iMA_buf_h1);
            err7=CopyBuffer(iMA_handle_h4,0,0,3,iMA_buf_h4);
            err9=CopyBuffer(iMA_handle_m15,0,0,3,iMA_buf_m15);
            err3=CopyClose(my_symbol,time_d1,0,3,Close_buf_d1);           //copy the price chart data into the dynamic array Close_buf for further work with them
            err4=CopyClose(my_symbol,time_h1,0,3,Close_buf_h1);
            err8=CopyClose(my_symbol,time_h4,0,3,Close_buf_h4);
            err10=CopyClose(my_symbol,time_m15,0,3,Close_buf_m15);
            err11=CopyOpen(my_symbol,time_h1,0,3,Open_buf_h1);
            err12=CopyOpen(my_symbol,time_m15,0,3,Open_buf_m15);
            err5=CopyHigh(my_symbol,time_h4,0,6,High_buf);
            err6=CopyLow(my_symbol,time_h4,0,6,Low_buf);
            if(err1<0 || err2<0 || err3<0 || err4<0 || err5<0 || err6<0 || err7<0 || err8<0 || err9<0 || err10<0 || err11<0 || err12<0)                                            //in case of errors
            {
               Print("Failed to copy data from the indicator buffer or price chart buffer");  //then print the relevant error message into the log file
               return;                                                                        //and exit the function
            }
         if(iMA_buf_d1[2]>Close_buf_d1[2] && iMA_buf_d1[1]<Close_buf_d1[1])//判斷各時區前前根k棒與前根k棒的ma線相比於收盤價的變化
            {buyd1=1;sd1="r";selld1=0;}
         else if(iMA_buf_d1[2]<Close_buf_d1[2] && iMA_buf_d1[1]>Close_buf_d1[1])
            {selld1=1;sd1="d";buyd1=0;}
         if(iMA_buf_h1[2]>Close_buf_h1[2] && iMA_buf_h1[1]<Close_buf_h1[1])
            {buyh1=1;sh1="r";sellh1=0;}
         else if(iMA_buf_h1[2]<Close_buf_h1[2] && iMA_buf_h1[1]>Close_buf_h1[1])
            {sellh1=1;sh1="d";buyh1=0;}
         if(iMA_buf_h4[2]>Close_buf_h4[2] && iMA_buf_h4[1]<Close_buf_h4[1])          //if the indicator values were less than the closing price and became greater
            {buyh4=1;sh4="r";sellh4=0;}
         else if(iMA_buf_h4[2]<Close_buf_h4[2] && iMA_buf_h4[1]>Close_buf_h4[1])          //if the indicator values were less than the closing price and became greater
            {sellh4=1;sh4="d";buyh4=0;}
         if(iMA_buf_m15[2]>Close_buf_m15[2] && iMA_buf_m15[1]<Close_buf_m15[1])
            {buym15=1;sm15="r";sellm15=0;}
         else if(iMA_buf_m15[2]<Close_buf_m15[2] && iMA_buf_m15[1]>Close_buf_m15[1])
            {sellm15=1;sm15="d";buym15=0;}
         ChartIndicatorAdd(ChartID(),0,iMA_handle_d1);
         ChartIndicatorAdd(ChartID(),0,iMA_handle_h1);
         ChartIndicatorAdd(ChartID(),0,iMA_handle_h4);
         ChartIndicatorAdd(ChartID(),0,iMA_handle_m15);  
         if(math(buyd1,buyh4,buyh1)==1 && mathpastr(ld1,lh4,lh1)==1){   
            int orderbuy=OrdersTotal();  
            handle+=1;
            if(m_Position.Select(my_symbol))                             //if the position for this symbol already exists
            {
               if(m_Position.PositionType()==POSITION_TYPE_SELL && handle>1)
               {m_Trade.PositionClose(my_symbol);}  //and this is a Sell position, then close it
               if(m_Position.PositionType()==POSITION_TYPE_BUY)
               {return;}                             //or else, if this is a Buy position, then exit
            }
            SymbolInfoTick(my_symbol,last_tick);
            cur = last_tick.ask;
            sl = cur;
            for(i=1; i<Candlestick_num; i++){//找10根k棒中的最低
                  if(Low_buf[i]<sl)
                  sl=Low_buf[i];
            }
            std = MathAbs(cur-sl)*tp_coefficient;//差距*3
            tp = cur+std;//止盈
            ma=iMA_buf_h1[0];
            commentbuy=StringFormat("d1:%s,h4:%s,h1:%s %s,%s,%s",         
                                 lsd1,
                                 lsh4,
                                 lsh1,
                                 sd1,
                                 sh4,
                                 sh1
                                 );
            if(iMA_buf_d1[1]<last_tick.ask && iMA_buf_h1[1]<last_tick.ask && iMA_buf_h4[1]<last_tick.ask && (Symbol_trade[i]==1 || Symbol_trade[i]==3)){                    
               m_Trade.Buy(position_volume, my_symbol,0,sl,tp,commentbuy);
               handle-=1;
               printf("MMA_buy");
            }
         }       
         if(math(buyh4,buyh1,buym15)==1 && mathpastr(lh4,lh1,lm15)==1){    
            /*ChartIndicatorAdd(ChartID(),0,iMA_handle_d1);
            ChartIndicatorAdd(ChartID(),0,iMA_handle_h1);
            ChartIndicatorAdd(ChartID(),0,iMA_handle_h4);
            ChartIndicatorAdd(ChartID(),0,iMA_handle_m15);  */
            int orderbuy=OrdersTotal();
            handle+=1;  
            if(m_Position.Select(my_symbol))                             //if the position for this symbol already exists
            {
               if(m_Position.PositionType()==POSITION_TYPE_SELL && handle>1)
               {m_Trade.PositionClose(my_symbol);}  //and this is a Sell position, then close it
               if(m_Position.PositionType()==POSITION_TYPE_BUY)
               {return;}                             //or else, if this is a Buy position, then exit
            }
            SymbolInfoTick(my_symbol,last_tick);
            cur = last_tick.ask;
            sl = cur;
            for(i=1; i<Candlestick_num; i++){//找10根k棒中的最低
               if(Low_buf[i]<sl)
                  sl=Low_buf[i];
            }
            std = MathAbs(cur-sl)*tp_coefficient;//差距*3
            tp = cur+std;//止盈
            ma=iMA_buf_m15[0];
            commentbuy=StringFormat("h4:%s,h1:%s,m15:%s %s,%s,%s", 
                                 lsh4,
                                 lsh1,
                                 lsm15,
                                 sh4,
                                 sh1,
                                 sm15                    
                                 );
            if(iMA_buf_m15[1]<last_tick.ask && iMA_buf_h1[1]<last_tick.ask && iMA_buf_h4[1]<last_tick.ask && (Symbol_trade[i]==1 || Symbol_trade[i]==3)){                       
               m_Trade.Buy(position_volume, my_symbol,0,sl,tp,commentbuy);
               handle-=1;
               printf("MMA_buy");
            }
         }                        
         if(math(selld1,sellh4,sellh1)==1 && mathpastd(ld1,lh4,lh1)==1){    
            /*ChartIndicatorAdd(ChartID(),0,iMA_handle_d1);
            ChartIndicatorAdd(ChartID(),0,iMA_handle_h1);
            ChartIndicatorAdd(ChartID(),0,iMA_handle_h4);
            ChartIndicatorAdd(ChartID(),0,iMA_handle_m15);*/
            int ordersell=OrdersTotal(); 
            handle+=1;       
            if(m_Position.Select(my_symbol))                             //if the position for this symbol already exists
            {
               if(m_Position.PositionType()==POSITION_TYPE_BUY && handle>1)
                  {m_Trade.PositionClose(my_symbol);}   //and this is a Buy position, then close it
               if(m_Position.PositionType()==POSITION_TYPE_SELL)
                  {return;}                            //or else, if this is a Sell position, then exit
            }
            SymbolInfoTick(my_symbol,last_tick);
            cur = last_tick.bid;
            sl = cur;
            for(i=1; i<Candlestick_num; i++){//找10根k棒中的最高
               if(High_buf[i]>sl)
                  sl=High_buf[i];
            }
            std = MathAbs(cur-sl)*tp_coefficient;//差距*3
            tp = cur-std;//止盈
            ma=iMA_buf_h1[0];
            commentsell=StringFormat("d1:%s,h4:%s,h1:%s %s,%s,%s",
                                 lsd1,
                                 lsh1,
                                 lsh4,
                                 sd1,
                                 sh1,
                                 sh4
                                 );   
            if(iMA_buf_d1[1]>last_tick.bid && iMA_buf_h1[1]>last_tick.bid && iMA_buf_h4[1]>last_tick.bid && (Symbol_trade[i]==2 || Symbol_trade[i]==3)){                     
               m_Trade.Sell(position_volume, my_symbol,0,sl,tp,commentsell);
               handle-=1;
               printf("MMA_sell");
            }
         } 
         if(math(sellh4,sellh1,sellm15)==1 && mathpastd(lh4,lh1,lm15)==1){ 
            /*ChartIndicatorAdd(ChartID(),0,iMA_handle_d1);
            ChartIndicatorAdd(ChartID(),0,iMA_handle_h1);
            ChartIndicatorAdd(ChartID(),0,iMA_handle_h4);
            ChartIndicatorAdd(ChartID(),0,iMA_handle_m15);*/
            int ordersell=OrdersTotal(); 
            handle+=1;              
            if(m_Position.Select(my_symbol))                             //if the position for this symbol already exists
            {
               if(m_Position.PositionType()==POSITION_TYPE_BUY && handle>1)
               {m_Trade.PositionClose(my_symbol);}   //and this is a Buy position, then close it
               if(m_Position.PositionType()==POSITION_TYPE_SELL)
               {return;}                            //or else, if this is a Sell position, then exit
            }
            SymbolInfoTick(my_symbol,last_tick);
            cur = last_tick.bid;//現價
            sl = cur;
            for(i=1; i<Candlestick_num; i++){//找10根k棒中的最高
               if(High_buf[i]>sl)
                  sl=High_buf[i];
            }
            std = MathAbs(cur-sl)*tp_coefficient;//差距*3
            tp = cur-std;//止盈
            ma=iMA_buf_m15[0];
            commentsell=StringFormat("h4:%s,h1:%s,m15:%s %s,%s,%s",    
                                 lsh1,
                                 lsh4,
                                 lsm15,
                                 sh1,
                                 sh4,
                                 sm15 
                                 );
            if(iMA_buf_m15[1]>last_tick.bid && iMA_buf_h1[1]>last_tick.bid && iMA_buf_h4[1]>last_tick.bid && (Symbol_trade[i]==2 || Symbol_trade[i]==3)){                          
               m_Trade.Sell(position_volume,my_symbol,0,sl,tp,commentsell);
               handle-=1;
               printf("MMA_sell");
            }                      
         }
         if(iMA_buf_d1[1]<Close_buf_d1[1])
            {lsd1="r";ld1=1;}
            else if(iMA_buf_d1[1]>Close_buf_d1[1])
            {lsd1="d";ld1=0;}
         if(iMA_buf_h1[1]<Close_buf_h1[1])
            {lsh1="r";lh1=1;}  
            else if(iMA_buf_h1[1]>Close_buf_h1[1])
            {lsh1="d";lh1=0;}
         if(iMA_buf_h4[1]<Close_buf_h4[1])         
            {lsh4="r";lh4=1;}    
            else if(iMA_buf_h4[1]>Close_buf_h4[1])        
            {lsh4="d";lh4=0;}
         if(iMA_buf_m15[1]<Close_buf_m15[1])
            {lsm15="r";lm15=1;}
            else if(iMA_buf_m15[1]>Close_buf_m15[1])
            {lsm15="d";lm15=0;} 
         }else if(Symbol_trade[i]==2){                     
            int copy=0;
            double sl=0;
            int position=0;                                      //save the current chart symbol for further operation of the EA on this very symbol
            my_timeframe=PERIOD_H4;

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
            if(!isNewBar(my_symbol, my_timeframe)) return;
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
                  if (Symbol_trade[i]==1 || Symbol_trade[i]==3)
                  {
                     m_Trade.Buy(0.1,my_symbol,cur,sl,tp);
                     printf("TDI_buy");
                  }
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
                  if (Symbol_trade[i]==2 || Symbol_trade[i]==3)
                  {
                     m_Trade.Sell(0.1,my_symbol,cur,sl,tp);
                     printf("TDI_sell");
                  }
                  return;  
               }
            }
         }
      }
   }
}
  
void CProgram::buy_press(void){
   m_buy.IsLocked(true);
   m_stop.IsLocked(false);
   string temp = m_symbol_select.GetValue();
   int i=0;
   while(symbols[i]!=temp){
      i++;
   }
   if(Symbol_trade[i]==0){
      Symbol_trade[i]=1;
   }else if(Symbol_trade[i]==2){
      Symbol_trade[i]=3;
   }
}

void CProgram::sell_press(void){
   m_sell.IsLocked(true);
   m_stop_sell.IsLocked(false);
   string temp = m_symbol_select.GetValue();
   int i=0;
   while(symbols[i]!=temp){
      i++;
   }
   if(Symbol_trade[i]==0){
      Symbol_trade[i]=2;
   }else if(Symbol_trade[i]==1){
      Symbol_trade[i]=3;
   }
}

void CProgram::stop_press(void){
   m_buy.IsLocked(false);
   m_stop.IsLocked(true);
   string temp = m_symbol_select.GetValue();
   int i=0;
   while(symbols[i]!=temp){
      i++;
   }
   if(Symbol_trade[i]==3){
      Symbol_trade[i]=2;
   }else if(Symbol_trade[i]==1){
      Symbol_trade[i]=0;
   }
}

void CProgram::stop_sell_press(void){
   m_sell.IsLocked(false);
   m_stop_sell.IsLocked(true);
   string temp = m_symbol_select.GetValue();
   int i=0;
   while(symbols[i]!=temp){
      i++;
   }
   if(Symbol_trade[i]==3){
      Symbol_trade[i]=1;
   }else if(Symbol_trade[i]==2){
      Symbol_trade[i]=0;
   }
}

//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CProgram::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
//--- GUI creation event
   if(id==CHARTEVENT_CUSTOM+ON_END_CREATE_GUI){
      return;
   }
//--- Button pressing events
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON){
      if(lparam==m_buy.Id()){
         OnBuy(lparam);
         return;
      }
      if(lparam==m_sell.Id()){
         OnSell(lparam);
         return;
      }
      if(lparam==m_stop.Id()){
         OnStop(lparam);
         return;
      }
      if(lparam==m_stop_sell.Id()){
         OnStop_sell(lparam);
         return;
      }
      if(lparam==m_select.Id()){
         long out=0;
         for(int k=0; k<numSymbols; k++){
            out+=Symbol_trade[k];
            out*=10;
         }
         printf(out/10);
         string temp = m_symbol_select.GetValue();
         Print(temp);
         int i;
         while(symbols[i]!=temp){
            i++;
         }
         string temp1 = m_expert_select.GetValue();
         if(temp1=="TDI"){
            Trade_method[i]=2;
            //Print(temp1);
         }else{
            Trade_method[i]=1;
            //Print(temp1);
         }
         out=0;
         for(int k=0; k<numSymbols; k++){
            out+=Trade_method[k];
            out*=10;
         }
         printf(out/10);
         if(Symbol_trade[i]==0){
            m_buy.IsLocked(false);
            m_stop.IsLocked(true);
            m_sell.IsLocked(false);
            m_stop_sell.IsLocked(true);
         }else if(Symbol_trade[i]==1){
            m_sell.IsLocked(false);
            m_stop_sell.IsLocked(true);
            m_buy.IsLocked(true);
            m_stop.IsLocked(false);
         }else if(Symbol_trade[i]==2){
            m_sell.IsLocked(true);
            m_stop_sell.IsLocked(false);
            m_buy.IsLocked(false);
            m_stop.IsLocked(true);
         }else if(Symbol_trade[i]==3){
            m_sell.IsLocked(true);
            m_stop_sell.IsLocked(false);
            m_buy.IsLocked(true);
            m_stop.IsLocked(false);
         }
         return;
      }
   }
   return;
}
 
bool CProgram::OnBuy(const long id){
   buy_press();
   return true;
}
 
bool CProgram::OnSell(const long id){
   sell_press();
   return true;
}
 
bool CProgram::OnStop(const long id){
   stop_press();
   return true;
}
bool CProgram::OnStop_sell(const long id){
   stop_sell_press();
   return true;
}
