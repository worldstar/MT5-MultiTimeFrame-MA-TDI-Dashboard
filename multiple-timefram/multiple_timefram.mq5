//+------------------------------------------------------------------+
//|                                           fast-start-example.mq5 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>                                         //include the library for execution of trades
#include <Trade\PositionInfo.mqh>                                  //include the library for obtaining information on positions

int               iMA_handle_h4;   
int               iMA_handle_d1;                                      //variable for storing the indicator handle
int               iMA_handle_h1;
int               iMA_handle_m15;
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

CTrade            m_Trade;                                         //structure for execution of trades
CPositionInfo     m_Position;                                      //structure for obtaining information of positions
input int iMA_period=40;
input int Candlestick_num=5;
input int tp_coefficient=3;
input double position_volume=0.1;
//宣告變數
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()//變數初始化
  {
   my_symbol=Symbol();                                             //save the current chart symbol for further operation of the EA on this very symbol
   time_h1=PERIOD_H1;//時區                                    //save the current time frame of the chart for further operation of the EA on this very time frame
   time_d1=PERIOD_D1;
   time_h4=PERIOD_H4;
   time_m15=PERIOD_M15;  
   iMA_handle_h1=iMA(my_symbol,time_h1,iMA_period,0,MODE_SMA,PRICE_CLOSE);  //apply the indicator and get its handle(40為40根k棒)
   iMA_handle_d1=iMA(my_symbol,time_d1,iMA_period,0,MODE_SMA,PRICE_CLOSE);
   iMA_handle_h4=iMA(my_symbol,time_h4,iMA_period,0,MODE_SMA,PRICE_CLOSE);
   iMA_handle_m15=iMA(my_symbol,time_m15,iMA_period,0,MODE_SMA,PRICE_CLOSE);
   if(iMA_handle_d1==INVALID_HANDLE)                                  //check the availability of the indicator handle
   {
      Print("Failed to get the indicator handle");                 //if the handle is not obtained, print the relevant error message into the log file
      return(-1);                                                  //complete handling the error
   }
   if(iMA_handle_h1==INVALID_HANDLE)                                  //check the availability of the indicator handle
   {
      Print("Failed to get the indicator handle");                 //if the handle is not obtained, print the relevant error message into the log file
      return(-1);                                                  //complete handling the error
   }
   if(iMA_handle_h4==INVALID_HANDLE)                                  //check the availability of the indicator handle
   {
      Print("Failed to get the indicator handle");                 //if the handle is not obtained, print the relevant error message into the log file
      return(-1);                                                  //complete handling the error
   }
   if(iMA_handle_m15==INVALID_HANDLE)                                  //check the availability of the indicator handle
   {
      Print("Failed to get the indicator handle");                 //if the handle is not obtained, print the relevant error message into the log file
      return(-1);                                                  //complete handling the error
   }
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
   return(0);                                                      //return 0, initialization complete
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   IndicatorRelease(iMA_handle_d1);                                   //deletes the indicator handle and deallocates the memory space it occupies
   IndicatorRelease(iMA_handle_h1);
   IndicatorRelease(iMA_handle_h4);
   IndicatorRelease(iMA_handle_m15);
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
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()//每一次報價一次
{
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
           if(iMA_buf_d1[1]<last_tick.ask && iMA_buf_h1[1]<last_tick.ask && iMA_buf_h4[1]<last_tick.ask){                    
             m_Trade.Buy(position_volume, my_symbol,0,sl,tp,commentbuy);
             handle-=1;}
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
         if(iMA_buf_m15[1]<last_tick.ask && iMA_buf_h1[1]<last_tick.ask && iMA_buf_h4[1]<last_tick.ask){                       
           m_Trade.Buy(position_volume, my_symbol,0,sl,tp,commentbuy);
           handle-=1;}
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
          if(iMA_buf_d1[1]>last_tick.bid && iMA_buf_h1[1]>last_tick.bid && iMA_buf_h4[1]>last_tick.bid){                     
            m_Trade.Sell(position_volume, my_symbol,0,sl,tp,commentsell);
            handle-=1;}
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
          if(iMA_buf_m15[1]>last_tick.bid && iMA_buf_h1[1]>last_tick.bid && iMA_buf_h4[1]>last_tick.bid){                          
            m_Trade.Sell(position_volume,my_symbol,0,sl,tp,commentsell);
            handle-=1;}                      
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
 }
}