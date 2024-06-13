# Panel
## 檔案內容

1. Panel.mq5  
    主要執行程式
2. Program.mqh  
    物件宣告,動作判別以及執行
    - 物件宣告
    ```
    class CProgram : public CWndEvents{
    private:
        //--- Trading operations
        CTrade            m_trade;
        //--- Time counters
        CTimeCounter      m_counter1;
        CTimeCounter      m_counter2;
        CTimeCounter      m_counter3;
                    .
                    .
                    .
    }
    ```
    - 動作判別  
    以id中的標籤(ex. ON_CLICK_BUTTON為按鈕按下)決定檢測的動作,lparam(ex, m_buy.id())檢測動作的物件  
    並以該物件id呼叫動作函數執行
    ```
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
                    .
                    .
                    .
        }
    }
    ```
    - 執行  
    接收到動作判別指令受執行動作  
    (以下兩函式應可合併為一個)
    ```
    bool CProgram::OnBuy(const long id){
        buy_press();
        return true;
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
    ```
    - 抓取indicator
   在ontick中,以迴圈遍歷所有的symbol,  
   以if(Symbol_trade[i]==1)判斷使用的交易方法,  
   將交易演算法放置於if中即可使用
   (使用的indicator也宣告於此)  
    ```
    void CProgram::OnTickEvent(void){
    for (int i = 0; i < numSymbols; i++){
      my_symbol=symbols[i];      
      if(Symbol_trade[i]==1){
                .
                .
                .
    }
    ```
3. CreateGUI.mqh  
    UI生成以及初始設定
    - UI生成
    ```
    bool CProgram::CreateGUI(void){
        //--- Create the form for control elements
        if(!CreateWindow2("Panel"))
            return(false);
        if(!CreateTabs2(3,43))
            return(false);
                .
                .
                .
                .
        CWndEvents::CompletedGUI();
        return(true);
    }
    ```
    - 初始設定
    ```
    bool CProgram::CreateWindow2(const string caption_text){
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
    ```
4. ex5為執行檔,可在xm直接使用  
成品示例
按鈕可設定交易取向,並由下方的下拉選單決定選擇的交易貨幣對以及想使用的演算法  
![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/UI_full.ver-panel/Panel.jpg)
