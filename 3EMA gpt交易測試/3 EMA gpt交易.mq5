double preema5, preema8, preema13,pp5,pp8,pp13;
double recordbuyHighPrice = 0;  // 用來記錄下降K棒的開盤價
double recordsellLowPrice = 0;
double recordbuylowPrice =0;
double recordsellHighPrice=0;
double rrbp=0;
double rrsp=0;
bool foundDownCandlebuy = false; // 用來標記是否找到下降K棒
bool foundUpCandlesell = false;
bool hasbuy = false;
bool hassell =false;
datetime lastbar_timeopen = 0;  // 記錄上一根K線的開盤時間
datetime currentBarTime = iTime(Symbol(), 0, 0); 
int trade;
int n=2;
int sellPositionCount = 0;              // 初始化賣單數量計數
int buyPositionCount = 0;               // 初始化買單數量計數
ENUM_TIMEFRAMES   timeframe;
input int a=2;
void OnTick()
{   

    //CTrade trade;
    
    // 獲取當前交易池中的訂單總數
    int totalPositions = PositionsTotal();  // 獲取當前持倉總數
    string symbol = PositionGetSymbol(0);
    if(totalPositions==0){
      sellPositionCount=0;
      buyPositionCount=0;
    }
    else if(totalPositions==1){
      if (PositionSelect(symbol))  // 選擇頭寸
        {
            int positionType = PositionGetInteger(POSITION_TYPE);  // 獲取頭寸類型
            
            if (positionType == POSITION_TYPE_SELL)  // 如果是賣單
            {
                sellPositionCount=1;
                buyPositionCount=0;
            }
            else if (positionType == POSITION_TYPE_BUY)  // 如果是買單
            {
                buyPositionCount=1;
                sellPositionCount=0;
            }
        }
    }else{
       sellPositionCount=1;
       buyPositionCount=1;
    }

        pp5 = iMA(Symbol(), PERIOD_H4, 5, 2, MODE_EMA, PRICE_CLOSE);
        pp8 = iMA(Symbol(), PERIOD_H4, 8, 2, MODE_EMA, PRICE_CLOSE);
        pp13 = iMA(Symbol(), PERIOD_H4, 13, 2, MODE_EMA, PRICE_CLOSE);
        double ema5[], ema8[], ema13[];
    
    // 獲取當前K線 (shift = 0) 的 EMA 值
    if (CopyBuffer(pp5, 0, 0, 2, ema5) <= 0) {
        Print("Failed to get EMA5 data");
        return;
    }
    
    if (CopyBuffer(pp8, 0, 0, 2, ema8) <= 0) {
        Print("Failed to get EMA8 data");
        return;
    }
    
    if (CopyBuffer(pp13, 0, 0, 2, ema13) <= 0) {
        Print("Failed to get EMA13 data");
        return;
    }
        // 獲取當前和前一天的K線信息
        double currentOpen = iOpen(Symbol(), 0, 0);      // 當前K棒的開盤價
        double currentClose = iClose(Symbol(), 0, 0);    // 當前K棒的收盤價
        double previousOpen = iOpen(Symbol(), 0, 1);     // 前一天K棒的開盤價
        double previousClose = iClose(Symbol(), 0, 1);   // 前一天K棒的收盤價
        double ppo = iOpen(Symbol(), 0, 2);
        double ppc = iClose(Symbol(), 0, 2);
        double ph = iHigh(Symbol(), 0, 2);
        double pl = iLow(Symbol(), 0, 2);
        double previousLow = iLow(Symbol(), 0, 1);       // 前一天K棒的最低價
        double previousHigh = iHigh(Symbol(), 0, 1);
        double pppl=iLow(Symbol(),0,3);
        double ppph=iHigh(Symbol(),0,3);
        if(PositionsTotal() <= 1 ){
         if (ppo > ppc)
           {
            if(recordbuyHighPrice!=ph&&recordbuylowPrice!=pl){
                    recordbuyHighPrice = ph;
                    recordbuylowPrice=pl;
                    foundDownCandlebuy = true; // 標記已找到下降K棒
                }
                }
         else if (ppo < ppc)
           {
            if(recordsellHighPrice!=ph && recordsellLowPrice!=pl){
                    recordsellLowPrice = pl;
                    recordsellHighPrice = ph;
                    foundUpCandlesell = true; // 標記已找到上升K棒
                }
                }
         if ((ema13[0] > ema8[0] && ema8[0] > ema5[0])  && foundUpCandlesell)
           {
             if (previousClose < previousOpen && sellPositionCount==0) // 確保沒有未結單
               {
                    if (previousClose < recordsellLowPrice)
                    {
                        double sellPrice = currentOpen;    // 賣出價設為當天開盤價
                        double stopLoss; //=sellPrice + 2 * MathAbs(sellPrice-previousHigh); // 止損設為前一天的最高價
                        if(ph>ppph&&ph>previousHigh){
                           stopLoss = ph;
                        }
                        if(ppph>ph&&ppph>previousHigh){
                           stopLoss = ppph;
                        }
                        if(previousHigh>ppph&&previousHigh>ph){
                           stopLoss = previousHigh;
                        }
                        double takeProfit =  sellPrice - a * (stopLoss - sellPrice); // 設置止盈
                        // 執行賣單
                        OpenSellOrder(0.1, sellPrice, stopLoss, takeProfit);
                        // 重置
                        foundUpCandlesell = false;
                    }
            }
         }
       if (foundDownCandlebuy && (ema13[0] < ema8[0] && ema8[0] < ema5[0]))     
             {
          
              if (previousClose > previousOpen && buyPositionCount==0) // 確保沒有未結單
                   {
                    if (previousClose > recordbuyHighPrice)
                    {
                        double buyPrice = currentOpen;     // 買入價設為當天開盤價
                        double stopLoss; /*=buyPrice - 2 * MathAbs(buyPrice-previousLow)*/; // 止損設為前一天的最低價
                        if(pl<pppl&&pl<previousLow){
                           stopLoss = pl;
                        }
                        if(pppl<pl&&pppl<previousLow){
                           stopLoss = pppl;
                        }
                        if(previousLow<pppl&&previousLow<pl){
                           stopLoss = previousLow;
                        }
                        double takeProfit = buyPrice + a * (buyPrice - stopLoss); // 設置止盈
                        // 執行買單
                        OpenBuyOrder(0.1, buyPrice, stopLoss, takeProfit);
                        // 重置
                        foundDownCandlebuy = false;
                    }
               }
          }
     }   
}
// 買入單函數
void OpenBuyOrder(double volume, double price, double stop_loss, double take_profit)
{
    MqlTradeRequest request;
    MqlTradeResult result;
    ZeroMemory(request);
    ZeroMemory(result);

    request.action = TRADE_ACTION_DEAL;       // 即市交易
    request.symbol = Symbol();                // 交易品種
    request.volume = volume;                  // 交易手數
    request.price = price;                    // 買入價格
    request.sl = stop_loss;                   // 設置止損
    request.tp = take_profit;                 // 設置止盈
    request.type = ORDER_TYPE_BUY;            // 訂單類型：買單
    request.type_filling = ORDER_FILLING_IOC; // 使用IOC成交模式
    request.type_time = ORDER_TIME_GTC;       // 訂單有效時間

    if (OrderSend(request, result))
    {
        Print("Buy order sent successfully. Ticket: ", result.order);
    }
    else
    {
        Print("Error sending buy order: ", result.retcode);
    }
}

// 賣出單函數
void OpenSellOrder(double volume, double price, double stop_loss, double take_profit)
{
    MqlTradeRequest request;
    MqlTradeResult result;
    ZeroMemory(request);
    ZeroMemory(result);

    request.action = TRADE_ACTION_DEAL;       // 即市交易
    request.symbol = Symbol();                // 交易品種
    request.volume = volume;                  // 交易手數
    request.price = price;                    // 賣出價格
    request.sl = stop_loss;                   // 設置止損
    request.tp = take_profit;                 // 設置止盈
    request.type = ORDER_TYPE_SELL;           // 訂單類型：賣單
    request.type_filling = ORDER_FILLING_IOC; // 使用IOC成交模式
    request.type_time = ORDER_TIME_GTC;       // 訂單有效時間

    if (OrderSend(request, result))
    {
        Print("Sell order sent successfully. Ticket: ", result.order);
    }
    else
    {
        Print("Error sending sell order: ", result.retcode);
    }
}
