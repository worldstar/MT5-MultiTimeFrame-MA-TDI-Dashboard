# Trend
## 檔案內容

1. Trend.mq5  
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
    根據動態生成的順序檢查是否有貨幣兌的按鈕被按下  
    並開啟相應交易視窗
    ```
    for(int i=0; i<numSymbols; i++){
        if(lparam==m_symbolsButton[i].Id()){
            long chartId = ChartOpen(symbols[i], PERIOD_H4);
        }
    }
    ```
3. CreateGUI.mqh  
    UI生成以及初始設定
    - UI生成
    UI動態生成的主要重點在這個部分,在Easy and Fast GUI中,  
    所有的物件生成都必須經過CreateGUI宣告才可使用,所以我們在這裡面執行動態生成的宣告,  
    再交由各個物件進行實際生成
    - 動態宣告
    ```
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
    }
    ```
    - 實際生成
    ```
    bool CProgram::CreateM15text(const int x_gap,int y_gap,const string text){
        CTextLabel* m_m15 = new CTextLabel(); //動態生成物件
        m_m15.MainPointer(m_tabs1);
        m_tabs1.AddToElementsArray(0,m_m15);
        m_m15.FontSize(12);
        m_m15.XSize(50);
        m_m15.YSize(30);
        m_m15.IsCenterText(true);
        if(!m_m15.CreateTextLabel(text, x_gap, y_gap))
            return(false);
        CWndContainer::AddToElementsArray(0, m_m15);
        m_timeText[text_push] = m_m15; //存入物件陣列已備調用
        text_push++;
        return(true);
    }
    ```
4. ex5為執行檔,可直接在xm中使用  
成品示例  
藉此可以清晰的觀察市場趨勢,若是需要交易可直接點選貨幣兌名稱以開啟相應的交易視窗  
![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/UI_full.ver-trend/Trend.jpg)
