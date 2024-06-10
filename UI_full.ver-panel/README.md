# Panel
## 檔案內容

1. Panel.mq5  
    主要執行程式
2. Program.mqh  
    物件宣告,動作判別以及執行
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

成品示例  
![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/UI_full.ver-panel/Panel.jpg)
