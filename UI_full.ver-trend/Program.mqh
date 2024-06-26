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

ENUM_TIMEFRAMES time_m15 = PERIOD_M15;
ENUM_TIMEFRAMES time_h4 = PERIOD_H4;
ENUM_TIMEFRAMES time_h12 = PERIOD_H12;
ENUM_TIMEFRAMES time_d1 = PERIOD_D1;
input string      symbol_input = "EURUSD,GBPUSD,USDCAD,AUDUSD,USDJPY,NZDUSD,USDCNH,USDDKK,USDMXN";
input int         symbol_per_col = 4;
int xgap = 10;
int ygap = 40;
int element_push=0;
int element_push_b=0;
int text_push=0;
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
   CTextLabel        m_symbolsText[150];
   CTextLabel        m_symbolsButton[150];
   CTextLabel        m_timeText[100];
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
   CTabs             m_tabs1;
   //--- Buttons
   CButton           m_buy;
   CButton           m_sell;
   CButton           m_stop;
   CButton           m_stop_sell;
   CButton           m_trend;
   //---
   CTextLabel        m_m15;
   CTextLabel        m_h1;
   CTextLabel        m_h4;
   CTextLabel        m_d1;
   CButton        m_symbol1;
   CTextLabel        m_symbol1_m15r;
   CTextLabel        m_symbol1_m15b;
   CTextLabel        m_symbol1_h1r;
   CTextLabel        m_symbol1_h1b;
   CTextLabel        m_symbol1_h4r;
   CTextLabel        m_symbol1_h4b;
   CTextLabel        m_symbol1_d1r;
   CTextLabel        m_symbol1_d1b;
public:
                     CProgram(void);
                    ~CProgram(void);
   //--- Initialization/deinitialization
   int               OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   void              OnTickEvent(void);
   //--- Timer
   void              OnTimerEvent(void);
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
   //input string symbol;
public:
   //--- Create the graphical interface
   bool              CreateGUI(void);
   //--- if trend change
   int               m_check_trend;
private:
   //--- Form
   bool              CreateWindow1(const string text);
   //--- Tabs
   bool              CreateTabs1(const int x_gap,const int y_gap);
   //--- Buttons
   bool              CreateBuy(const int x_gap,const int y_gap,const string text);
   bool              CreateSell(const int x_gap,const int y_gap,const string text);
   bool              CreateStop(const int x_gap,const int y_gap,const string text);
   bool              CreateStop_sell(const int x_gap,const int y_gap,const string text);
   //---Label
   bool              CreateM15text(const int x_gap, const int y_gap, const string text);
   bool              CreateH1text(const int x_gap, const int y_gap, const string text);
   bool              CreateH4text(const int x_gap, const int y_gap, const string text);
   bool              CreateD1text(const int x_gap, const int y_gap, const string text);
   bool              CreateSymbol1text(const int x_gap, const int y_gap, const string text);
   bool              CreateSymbol1_m15r(const int x_gap, const int y_gap);
   bool              CreateSymbol1_m15b(const int x_gap, const int y_gap);
   bool              CreateSymbol1_h1r(const int x_gap, const int y_gap);
   bool              CreateSymbol1_h1b(const int x_gap, const int y_gap);
   bool              CreateSymbol1_h4r(const int x_gap, const int y_gap);
   bool              CreateSymbol1_h4b(const int x_gap, const int y_gap);
   bool              CreateSymbol1_d1r(const int x_gap, const int y_gap);
   bool              CreateSymbol1_d1b(const int x_gap, const int y_gap);
   //---Button press
   bool              OnBuy(const long id);
   bool              OnSell(const long id);
   bool              OnStop(const long id);
   bool              OnStop_sell(const long id);
   
   bool              CreateSymbolSelect(const int x_gap,const int y_gap,const string text);
   bool              CreateExpertSelect(const int x_gap,const int y_gap,const string text);
   //--- Get handles
   //void              GetHandles(void);
   //--- Get indicator values on all symbols
   void              GetIndicatorValues(void);
   //---change color
   void              Change_trendcolor(int symbol_num, int trend, const string clr);
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
   m_counter1.SetParameters(16,100);
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
   return(0);
}
//+------------------------------------------------------------------+
//| Deinitialization                                                 |
//+------------------------------------------------------------------+
void CProgram::OnDeinitEvent(const int reason){
//--- Remove the interface
   CWndEvents::Destroy();
}
void CProgram::OnTickEvent(void){
   GetIndicatorValues();
}
  
void CProgram::buy_press(void){
   m_buy.IsLocked(true);
}

void CProgram::sell_press(void){
   m_sell.IsLocked(true);
}

void CProgram::stop_press(void){
   m_buy.IsLocked(false);
}

void CProgram::stop_sell_press(void){
   m_sell.IsLocked(false);
}

void CProgram::Change_trendcolor(int symbol_num, int trend, const string clr){
   //Print("%d in change", symbol_num);
   switch(trend){
      case 15:
         if(clr=="B"){
            m_symbolsText[5*symbol_num+1].BackColor(C'85,170,255');
            m_symbolsText[5*symbol_num+1].Update(true);
            //printf("change to B");
         }else{
            m_symbolsText[5*symbol_num+1].BackColor(C'255,51,51');
            m_symbolsText[5*symbol_num+1].Update(true);
            //printf("change to R");
         }
         break;
      case 4:
         if(clr=="B"){
            m_symbolsText[5*symbol_num+2].BackColor(C'85,170,255');
            m_symbolsText[5*symbol_num+2].Update(true);
            //printf("change to B");
         }else{
            m_symbolsText[5*symbol_num+2].BackColor(C'255,51,51');
            m_symbolsText[5*symbol_num+2].Update(true);
            //printf("change to R");
         }
         break;
      case 12:
         if(clr=="B"){
            m_symbolsText[5*symbol_num+3].BackColor(C'85,170,255');
            m_symbolsText[5*symbol_num+3].Update(true);
            //printf("change to B");
         }else{
            m_symbolsText[5*symbol_num+3].BackColor(C'255,51,51');
            m_symbolsText[5*symbol_num+3].Update(true);
            //printf("change to R");
         }
         break;
      case 1:
         if(clr=="B"){
            m_symbolsText[5*symbol_num+4].BackColor(C'85,170,255');
            m_symbolsText[5*symbol_num+4].Update(true);
            //printf("change to B");
         }else{
            m_symbolsText[5*symbol_num+4].BackColor(C'255,51,51');
            m_symbolsText[5*symbol_num+4].Update(true);
            //printf("change to R");
         }
         break;
      default:
         break;
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
      for(int i=0; i<numSymbols; i++){
         if(lparam==m_symbolsButton[i].Id()){
            long chartId = ChartOpen(symbols[i], PERIOD_H4);
         }
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

//+------------------------------------------------------------------+
//| Get indicator values on all symbols                              |
//+------------------------------------------------------------------+
void CProgram::GetIndicatorValues(void){
   for(int i=0; i<numSymbols; i++){
      m_symbols = symbols[i];
      ima_handle_m15=iMA(m_symbols,time_m15,40,0,MODE_SMA,PRICE_CLOSE);
      CopyBuffer(ima_handle_m15, 0, 0, 100, ima_buff_m15);
      CopyClose(m_symbols, time_m15, 0, 100, close_buff_m15);
      ima_handle_h4=iMA(m_symbols,time_h4,40,0,MODE_SMA,PRICE_CLOSE);
      CopyBuffer(ima_handle_h4, 0, 0, 100, ima_buff_h4);
      CopyClose(m_symbols, time_h4, 0, 100, close_buff_h4);
      ima_handle_h12=iMA(m_symbols,time_h12,40,0,MODE_SMA,PRICE_CLOSE);
      CopyBuffer(ima_handle_h12, 0, 0, 100, ima_buff_h12);
      CopyClose(m_symbols, time_h12, 0, 100, close_buff_h12);
      ima_handle_d1=iMA(m_symbols,time_d1,40,0,MODE_SMA,PRICE_CLOSE);
      CopyBuffer(ima_handle_d1, 0, 0, 100, ima_buff_d1);
      CopyClose(m_symbols, time_d1, 0, 100, close_buff_d1);
   
      if((ima_buff_m15[1]>close_buff_m15[1] && ima_buff_m15[0]<close_buff_m15[0]) || (ima_buff_m15[1]<close_buff_m15[1] && ima_buff_m15[0]<close_buff_m15[0])){
         Change_trendcolor(i, 15, "R");
         //Print(symbols[i]);
         //printf("%d m15_R trend", i);
      }else if((ima_buff_m15[1]<close_buff_m15[1] && ima_buff_m15[0]>close_buff_m15[0]) || (ima_buff_m15[1]>close_buff_m15[1] && ima_buff_m15[0]>close_buff_m15[0])){
         Change_trendcolor(i, 15, "B");
         //Print(symbols[i]);
         //printf("%d m15_B trend", i);
      }
   
      if((ima_buff_h4[1]>close_buff_h4[1] && ima_buff_h4[0]<close_buff_h4[0]) || (ima_buff_h4[1]<close_buff_h4[1] && ima_buff_h4[0]<close_buff_h4[0])){
         Change_trendcolor(i, 4, "R");
         //Print(symbols[i]);
         //printf("%d h4_R trend", i);
      }else if((ima_buff_h4[1]<close_buff_h4[1] && ima_buff_h4[0]>close_buff_h4[0]) || (ima_buff_h4[1]>close_buff_h4[1] && ima_buff_h4[0]>close_buff_h4[0])){
         Change_trendcolor(i, 4, "B");
         //printf("%d h4_B trend", i);
      }
   
      if((ima_buff_h12[1]>close_buff_h12[1] && ima_buff_h12[0]<close_buff_h12[0]) || (ima_buff_h12[1]<close_buff_h12[1] && ima_buff_h12[0]<close_buff_h12[0])){
         Change_trendcolor(i, 12, "R");
         //Print(symbols[i]);
         //printf("%d h12_R trend", i);
      }else if((ima_buff_h12[1]<close_buff_h12[1] && ima_buff_h12[0]>close_buff_h12[0]) || (ima_buff_h12[1]>close_buff_h12[1] && ima_buff_h12[0]>close_buff_h12[0])){
         Change_trendcolor(i, 12, "B");
         //Print(symbols[i]);
         //printf("%d h12_B trend", i);
      }
   
      if((ima_buff_d1[1]>close_buff_d1[1] && ima_buff_d1[0]<close_buff_d1[0]) || (ima_buff_d1[1]<close_buff_d1[1] && ima_buff_d1[0]<close_buff_d1[0])){
         Change_trendcolor(i, 1, "R");
         //Print(symbols[i]);
         //printf("%d d1_R trend", i);
      }else if((ima_buff_d1[1]<close_buff_d1[1] && ima_buff_d1[0]>close_buff_d1[0]) || (ima_buff_d1[1]>close_buff_d1[1] && ima_buff_d1[0]>close_buff_d1[0])){
         Change_trendcolor(i, 1, "B");
         //Print(symbols[i]);
         //printf("%d d1_B trend", i);
      }
   }
}
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+

void CProgram::OnTimerEvent(void){
//--- Exit if this is the tester
   /*if(::MQLInfoInteger(MQL_TESTER) || ::MQLInfoInteger(MQL_FRAME_MODE))
      return;*/
//--- Handling the elements
   CWndEvents::OnTimerEvent();
   if(m_counter1.CheckTimeCounter()){
      GetIndicatorValues();
   }
}
  
