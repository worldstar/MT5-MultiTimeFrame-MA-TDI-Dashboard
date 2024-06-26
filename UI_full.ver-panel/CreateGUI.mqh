#include "Program.mqh"
//+------------------------------------------------------------------+
//| Create the graphical interface                                   |
//+------------------------------------------------------------------+
bool CProgram::CreateGUI(void)
  {
//--- Create the form for control elements
   if(!CreateWindow2("Panel"))
      return(false);
   if(!CreateTabs2(3,43))
      return(false);
   if(!CreateBuy(2,10,"BUY"))
      return(false);
   if(!CreateSell(152,10,"SELL"))
      return(false);
   if(!CreateStop(2,70,"STOP_BUY"))
      return(false);
   if(!CreateStop_sell(152,70,"STOP_SELL"))
      return(false);
   if(!CreateSymbolSelect(10,170,"Symbol :"))
      return(false);
   if(!CreateExpertSelect(10,200,"Expert :"))
      return(false);
   if(!CreateSelect(245,126,"SELECT"))
      return(false);
   CWndEvents::CompletedGUI();
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the controls form                                         |
//+------------------------------------------------------------------+
bool CProgram::CreateWindow2(const string caption_text)
  {
//--- Add the window pointer to the windows array
   CWndContainer::AddWindow(m_window2);
//--- Coordinates
   int x=(m_window2.X()>0) ? m_window2.X() : 1;
   int y=(m_window2.Y()>0) ? m_window2.Y() : 1;
//--- Properties
   m_window2.XSize(320);
   m_window2.YSize(250);
   m_window2.FontSize(9);
   m_window2.IsMovable(true);
   m_window2.ResizeMode(true);
   m_window2.CloseButtonIsUsed(true);
   m_window2.CollapseButtonIsUsed(true);
   m_window2.TooltipsButtonIsUsed(true);
   m_window2.FullscreenButtonIsUsed(true);
//--- Set tooltips
   m_window2.GetCloseButtonPointer().Tooltip("Close");
   m_window2.GetTooltipButtonPointer().Tooltip("Tooltips");
   m_window2.GetFullscreenButtonPointer().Tooltip("Fullscreen");
   m_window2.GetCollapseButtonPointer().Tooltip("Collapse/Expand");
//--- Create the form
   if(!m_window2.CreateWindow(m_chart_id,m_subwin,caption_text,x,y))
      return(false);
//---
   return(true);
}
  //+------------------------------------------------------------------+
//| Create tab group 1                                               |
//+------------------------------------------------------------------+
bool CProgram::CreateTabs2(const int x_gap,const int y_gap)
  {
#define TABS1_TOTAL 1
//--- Save the pointer to the main element
   m_tabs2.MainPointer(m_window2);
//--- Properties
   m_tabs2.IsCenterText(true);
   m_tabs2.PositionMode(TABS_TOP);
   m_tabs2.AutoXResizeMode(true);
   m_tabs2.AutoYResizeMode(true);
   m_tabs2.AutoXResizeRightOffset(3);
   m_tabs2.AutoYResizeBottomOffset(25);
//--- Add tabs with specified properties
   string tabs_names[TABS1_TOTAL]={"Trade"};
   for(int i=0; i<TABS1_TOTAL; i++)
      m_tabs2.AddTab(tabs_names[i],100);
//--- Create the control
   if(!m_tabs2.CreateTabs(x_gap,y_gap))
      return(false);
//--- Add the object to the general array of object groups
   CWndContainer::AddToElementsArray(0,m_tabs2);
   return(true);
  }
  
  //+------------------------------------------------------------------+
//| Create the "Buy" button                                          |
//+------------------------------------------------------------------+
bool CProgram::CreateBuy(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_buy.MainPointer(m_tabs2);
//--- Attach to tab
   m_tabs2.AddToElementsArray(0,m_buy);
//--- Properties
   m_buy.XSize(145);
   m_buy.YSize(50);
   m_buy.IsCenterText(true);
   m_buy.BackColor(C'50,100,135');
   m_buy.BackColorHover(C'105,190,255');
   m_buy.BackColorLocked(C'85,170,255');
   m_buy.LabelColor(clrWhite);
   m_buy.LabelColorHover(clrWhite);
   m_buy.LabelColorLocked(clrWhite);
   m_buy.BorderColor(clrBlack);
   m_buy.BorderColorHover(clrBlack);
   m_buy.BorderColorLocked(clrBlack);
   m_buy.IsLocked(true);
//--- Create a control element
   if(!m_buy.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Add a pointer to the element to the base
   CWndContainer::AddToElementsArray(0,m_buy);
   return(true);
  }
  
//+------------------------------------------------------------------+
//| Create the "Sell" button                                         |
//+------------------------------------------------------------------+
bool CProgram::CreateSell(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_sell.MainPointer(m_tabs2);
//--- Attach to tab
   m_tabs2.AddToElementsArray(0,m_sell);
//--- Properties
   m_sell.XSize(145);
   m_sell.YSize(50);
   m_sell.IsCenterText(true);
   m_sell.BackColor(C'195,0,0');
   m_sell.BackColorHover(C'255,100,100');
   m_sell.BackColorLocked(C'255,51,51');
   m_sell.LabelColor(clrWhite);
   m_sell.LabelColorHover(clrWhite);
   m_sell.LabelColorLocked(clrWhite);
   m_sell.BorderColor(clrBlack);
   m_sell.BorderColorHover(clrBlack);
   m_sell.BorderColorLocked(clrBlack);
   m_sell.IsLocked(true);
//--- Create a control element
   if(!m_sell.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Add a pointer to the element to the base
   CWndContainer::AddToElementsArray(0,m_sell);
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Stop" button                                         |
//+------------------------------------------------------------------+
bool CProgram::CreateStop(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_stop.MainPointer(m_tabs2);
//--- Attach to tab
   m_tabs2.AddToElementsArray(0,m_stop);
//--- Properties
   m_stop.XSize(145);
   m_stop.YSize(50);
   m_stop.IsCenterText(true);
   m_stop.BackColor(C'152,143,143');
   m_stop.BackColorHover(C'174,168,168');
   m_stop.BackColorPressed(C'92,92,92');   
   m_stop.LabelColor(clrWhite);
   m_stop.LabelColorHover(clrWhite);
   m_stop.LabelColorPressed(clrWhite);
   m_stop.BorderColor(clrBlack);
   m_stop.BorderColorHover(clrBlack);
   m_stop.BorderColorPressed(clrBlack);
//--- Create a control element
   if(!m_stop.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Add a pointer to the element to the base
   CWndContainer::AddToElementsArray(0,m_stop);
   return(true);
}

bool CProgram::CreateStop_sell(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_stop_sell.MainPointer(m_tabs2);
//--- Attach to tab
   m_tabs2.AddToElementsArray(0,m_stop_sell);
//--- Properties
   m_stop_sell.XSize(145);
   m_stop_sell.YSize(50);
   m_stop_sell.IsCenterText(true);
   m_stop_sell.BackColor(C'152,143,143');
   m_stop_sell.BackColorHover(C'174,168,168');
   m_stop_sell.BackColorPressed(C'92,92,92');   
   m_stop_sell.LabelColor(clrWhite);
   m_stop_sell.LabelColorHover(clrWhite);
   m_stop_sell.LabelColorPressed(clrWhite);
   m_stop_sell.BorderColor(clrBlack);
   m_stop_sell.BorderColorHover(clrBlack);
   m_stop_sell.BorderColorPressed(clrBlack);
//--- Create a control element
   if(!m_stop_sell.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Add a pointer to the element to the base
   CWndContainer::AddToElementsArray(0,m_stop_sell);
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Symbol select" combo box                                |
//+------------------------------------------------------------------+
bool CProgram::CreateSymbolSelect(const int x_gap,const int y_gap,const string text){
#define ROWS3_TOTAL numSymbols
//--- Store the pointer to the main control
   m_symbol_select.MainPointer(m_window2);
//--- Properties
   m_symbol_select.XSize(215);
   m_symbol_select.ItemsTotal(ROWS3_TOTAL);
   m_symbol_select.GetButtonPointer().XSize(150);
   m_symbol_select.GetButtonPointer().AnchorRightWindowSide(true);
//--- Array of the chart line types
   string array[];
   ArrayResize(array, numSymbols+1);
   for(int i=0; i<numSymbols; i++)
      array[i]=symbols[i];
//--- Populate the combo box list
   for(int i=0; i<ROWS3_TOTAL; i++)
      m_symbol_select.SetValue(i,array[i]);
//--- List properties
   CListView *lv=m_symbol_select.GetListViewPointer();
   lv.LightsHover(true);
   lv.SelectItem(lv.SelectedItemIndex()==WRONG_VALUE ? 0 : lv.SelectedItemIndex());
//--- Create a control
   if(!m_symbol_select.CreateComboBox(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_symbol_select);
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Expert select" combo box                                |
//+------------------------------------------------------------------+
bool CProgram::CreateExpertSelect(const int x_gap,const int y_gap,const string text){
#define ROWS4_TOTAL 2
//--- Store the pointer to the main control
   m_expert_select.MainPointer(m_window2);
//--- Properties
   m_expert_select.XSize(215);
   m_expert_select.ItemsTotal(ROWS4_TOTAL);
   m_expert_select.GetButtonPointer().XSize(150);
   m_expert_select.GetButtonPointer().AnchorRightWindowSide(true);
//--- Array of the chart line types
   string array[]={"Multiple MA","TDI"};
//--- Populate the combo box list
   for(int i=0; i<ROWS4_TOTAL; i++)
      m_expert_select.SetValue(i,array[i]);
//--- List properties
   CListView *lv=m_expert_select.GetListViewPointer();
   lv.LightsHover(true);
   lv.SelectItem(lv.SelectedItemIndex()==WRONG_VALUE ? 0 : lv.SelectedItemIndex());
//--- Create a control
   if(!m_expert_select.CreateComboBox(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_expert_select);
   return(true);
}


bool CProgram::CreateSelect(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_select.MainPointer(m_tabs2);
//--- Attach to tab
   m_tabs2.AddToElementsArray(0,m_select);
//--- Properties
   m_select.XSize(50);
   m_select.YSize(50);
   m_select.IsCenterText(true);
   m_select.BackColor(C'152,143,143');
   m_select.BackColorHover(C'174,168,168');
   m_select.BackColorPressed(C'92,92,92');   
   m_select.LabelColor(clrWhite);
   m_select.LabelColorHover(clrWhite);
   m_select.LabelColorPressed(clrWhite);
   m_select.BorderColor(clrBlack);
   m_select.BorderColorHover(clrBlack);
   m_select.BorderColorPressed(clrBlack);
//--- Create a control element
   if(!m_select.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Add a pointer to the element to the base
   CWndContainer::AddToElementsArray(0,m_select);
   return(true);
}