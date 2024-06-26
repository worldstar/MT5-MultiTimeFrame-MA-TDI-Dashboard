#include "Program.mqh"
//+------------------------------------------------------------------+
//| Create the graphical interface                                   |
//+------------------------------------------------------------------+

bool CProgram::CreateGUI(void)
  {
//--- Create the form for control elements
   if(!CreateWindow1("Stochastic signals"))
      return(false);
   if(!CreateTabs1(3,43))
      return(false);
   if(!CreateM15text(100,10,"M15"))
      return(false);
   if(!CreateH1text(150,10,"H1"))
      return(false);
   if(!CreateH4text(200,10,"H4"))
      return(false);
   if(!CreateD1text(250,10,"D1"))
      return(false);
   numSymbols = StringSplit(symbol_input, ',', symbols);
   ygap=40;
   xgap=10;
   element_push=0;
   element_push_b=0;
   int col_item=1;
   for(int i=0; i<numSymbols; i++){
      string symbol = symbols[i];
      if(!CreateSymbol1text(xgap, ygap, symbol))
         return(false);
         xgap+=90;
         for(int k=0; k<4; k++){
            if(!CreateSymbol1_m15r(xgap, ygap))
               return(false);
         xgap+=50;
      }
      if(i<=symbol_per_col-2){
         xgap=10;
      }else if(i==symbol_per_col*col_item-1 && (numSymbols-i)>1){
         if(!CreateM15text(100+330*col_item,10,"M15"))
            return(false);
         if(!CreateH1text(150+330*col_item,10,"H1"))
            return(false);
         if(!CreateH4text(200+330*col_item,10,"H4"))
            return(false);
         if(!CreateD1text(250+330*col_item,10,"D1"))
            return(false);
         xgap=340*col_item;
         int temp = m_window1.XSize();
         temp = 340+320*col_item;
         m_window1.ChangeWindowWidth(temp);
         col_item++;
      }else if(i>=symbol_per_col-1){
         xgap=340*(col_item-1);
      }
      if((i+1) % symbol_per_col == 0){
         ygap=40;
      } else if((i+1) % symbol_per_col != 0){
         ygap+=40;
      }
      if(symbol_per_col>3){
         int temp = m_window1.YSize();
         temp = 250+40*(symbol_per_col-3);
         m_window1.ChangeWindowHeight(temp);
      }
   }
   CWndEvents::CompletedGUI();
   return(true);
  }
  

//+------------------------------------------------------------------+
//| Create the controls form                                         |
//+------------------------------------------------------------------+
bool CProgram::CreateWindow1(const string caption_text)
  {
//--- Add the window pointer to the windows array
   CWndContainer::AddWindow(m_window1);
//--- Coordinates
   int x=(m_window1.X()>0) ? m_window1.X() : 1;
   int y=(m_window1.Y()>0) ? m_window1.Y() : 1;
//--- Properties
   m_window1.XSize(320);
   m_window1.YSize(250);
   m_window1.FontSize(9);
   m_window1.IsMovable(true);
   m_window1.ResizeMode(true);
   m_window1.CloseButtonIsUsed(true);
   m_window1.CollapseButtonIsUsed(true);
   m_window1.TooltipsButtonIsUsed(true);
   m_window1.FullscreenButtonIsUsed(true);
//--- Set tooltips
   m_window1.GetCloseButtonPointer().Tooltip("Close");
   m_window1.GetTooltipButtonPointer().Tooltip("Tooltips");
   m_window1.GetFullscreenButtonPointer().Tooltip("Fullscreen");
   m_window1.GetCollapseButtonPointer().Tooltip("Collapse/Expand");
//--- Create the form
   if(!m_window1.CreateWindow(m_chart_id,m_subwin,caption_text,x,y))
      return(false);
//---
   return(true);
}
  //+------------------------------------------------------------------+
//| Create tab group 1                                               |
//+------------------------------------------------------------------+
bool CProgram::CreateTabs1(const int x_gap,const int y_gap)
  {
#define TABS1_TOTAL 1
//--- Save the pointer to the main element
   m_tabs1.MainPointer(m_window1);
//--- Properties
   m_tabs1.IsCenterText(true);
   m_tabs1.PositionMode(TABS_TOP);
   m_tabs1.AutoXResizeMode(true);
   m_tabs1.AutoYResizeMode(true);
   m_tabs1.AutoXResizeRightOffset(3);
   m_tabs1.AutoYResizeBottomOffset(25);
//--- Add tabs with specified properties
   string tabs_names[TABS1_TOTAL]={"Trend"};
   for(int i=0; i<TABS1_TOTAL; i++)
      m_tabs1.AddTab(tabs_names[i],100);
//--- Create the control
   if(!m_tabs1.CreateTabs(x_gap,y_gap))
      return(false);
//--- Add the object to the general array of object groups
   CWndContainer::AddToElementsArray(0,m_tabs1);
   return(true);
  }
bool CProgram::CreateM15text(const int x_gap,int y_gap,const string text){
   CTextLabel* m_m15 = new CTextLabel();
   m_m15.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_m15);
   m_m15.FontSize(12);
   m_m15.XSize(50);
   m_m15.YSize(30);
   m_m15.IsCenterText(true);
   if(!m_m15.CreateTextLabel(text, x_gap, y_gap))
      return(false);
   CWndContainer::AddToElementsArray(0, m_m15);
   m_timeText[text_push] = m_m15;
   text_push++;
   return(true);
}

bool CProgram::CreateH1text(const int x_gap,int y_gap,const string text){
   CTextLabel* m_h1 = new CTextLabel();
   m_h1.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_h1);
   m_h1.FontSize(12);
   m_h1.XSize(50);
   m_h1.YSize(30);
   m_h1.IsCenterText(true);
   if(!m_h1.CreateTextLabel(text, x_gap, y_gap))
      return(false);
   CWndContainer::AddToElementsArray(0, m_h1);
   m_timeText[text_push] = m_h1;
   text_push++;
   return(true);
}

bool CProgram::CreateH4text(const int x_gap,int y_gap,const string text){
   CTextLabel* m_h4 = new CTextLabel();
   m_h4.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_h4);
   m_h4.FontSize(12);
   m_h4.XSize(50);
   m_h4.YSize(30);
   m_h4.IsCenterText(true);
   if(!m_h4.CreateTextLabel(text, x_gap, y_gap))
      return(false);
   CWndContainer::AddToElementsArray(0, m_h4);
   m_timeText[text_push] = m_h4;
   text_push++;
   return(true);
}

bool CProgram::CreateD1text(const int x_gap,int y_gap,const string text){
   CTextLabel* m_d1 = new CTextLabel();
   m_d1.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_d1);
   m_d1.FontSize(12);
   m_d1.XSize(50);
   m_d1.YSize(30);
   m_d1.IsCenterText(true);
   if(!m_d1.CreateTextLabel(text, x_gap, y_gap))
      return(false);
   CWndContainer::AddToElementsArray(0, m_d1);
   m_timeText[text_push] = m_d1;
   text_push++;
   return(true);
}

bool CProgram::CreateSymbol1text(const int x_gap,int y_gap,const string text){
   CButton* m_text = new CButton();
   m_text.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0, m_text);
   m_text.FontSize(12);
   m_text.XSize(80);
   m_text.YSize(30);
   m_text.IsCenterText(true);
   m_text.BackColor(clrWhite);
   m_text.BackColorHover(clrWhite);
   m_text.BorderColor(clrWhite);
   m_text.BorderColorHover(clrWhite);
   m_text.BackColorPressed(clrWhite);
   if(!m_text.CreateButton(text, x_gap, y_gap))
      return(false);
   CWndContainer::AddToElementsArray(0, m_text);
   m_symbolsButton[element_push_b] = m_text;
   element_push_b++;
   return(true);
}

bool CProgram::CreateSymbol1_m15r(const int x_gap,const int y_gap){
   CTextLabel* m_r = new CTextLabel();
   m_r.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_r);
   m_r.FontSize(12);
   m_r.XSize(40);
   m_r.YSize(30);
   m_r.BackColor(C'255,51,51');
   if(!m_r.CreateTextLabel("", x_gap, y_gap))
      return(false);
   CWndContainer::AddToElementsArray(0, m_r);
   m_symbolsText[element_push] = m_r;
   element_push++;
   return(true);
}

bool CProgram::CreateSymbol1_m15b(const int x_gap,const int y_gap){
   CTextLabel* m_b = new CTextLabel();
   m_b.MainPointer(m_tabs1);
   m_tabs1.AddToElementsArray(0,m_b);
   m_b.FontSize(12);
   m_b.XSize(40);
   m_b.YSize(30);
   m_b.BackColor(C'85,170,255');
   m_b.IsVisible(false);
   if(!m_b.CreateTextLabel("", x_gap, y_gap))
      return(false);
   CWndContainer::AddToElementsArray(0, m_b);
   m_symbolsText[element_push] = m_b;
   element_push++;
   return(true);
}