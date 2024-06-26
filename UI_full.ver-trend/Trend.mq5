//+------------------------------------------------------------------+
//|                                                   TradePanel.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//--- Include application class
#include "Program.mqh"
#include "CreateGUI.mqh"
CProgram program;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int OnInit(void){
//--- Initialize program
   if(program.OnInitEvent()!=0){
      ::Print(__FUNCTION__," > Failed to initialize!");
      return(INIT_FAILED);
   }
//--- Create the graphical interface
   if(!program.CreateGUI()){
      ::Print(__FUNCTION__," > Could not create the GUI!");
      return(INIT_FAILED);
   }
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   program.OnDeinitEvent(reason);
}
  
void OnTick(){
   program.OnTickEvent();
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   program.ChartEvent(id,lparam,dparam,sparam);
}

void OnTimer(void){
   program.OnTimerEvent();   
}