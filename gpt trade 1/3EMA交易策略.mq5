// Input variables for EMA periods
input int EMA5_period = 5;
input int EMA8_period = 8;
input int EMA13_period = 13;
ENUM_TIMEFRAMES   timeframe;
// Set stop loss and take profit multipliers
double stop_loss_multiplier = 1.0;
double take_profit_multiplier = 2.0;

// Order status flags to avoid multiple orders
bool isBuyOrderOpen = false;
bool isSellOrderOpen = false;

// OnTick function, where all the action happens
void OnTick()
{
   double Close[],Open[],Low[],High[];
   int OP_BUY,OP_SELL;
    // Get the current bar index (the most recent closed candle)
    int i = iBarShift(NULL, 0, TimeCurrent(), false);
    // Calculate EMA values
    double EMA5 = iMA(NULL, timeframe, EMA5_period, 0, MODE_EMA, PRICE_CLOSE);
    double EMA8 = iMA(NULL, timeframe, EMA8_period, 0, MODE_EMA, PRICE_CLOSE);
    double EMA13 = iMA(NULL, timeframe, EMA13_period, 0, MODE_EMA, PRICE_CLOSE);

    // Refresh order flags to check if there are open buy/sell orders
    CheckOpenOrders();

    // Check for EMA5 > EMA8 > EMA13 condition for a bullish signal and no buy order is open
    if (EMA5 > EMA8 && EMA8 > EMA13 && !isBuyOrderOpen)
    {
        // Find the first bullish (white) candle
        for (int j = i; j >= 0; j--)
        {
            if (Close[j] > Open[j]) // Bullish candle
            {
                double buy_price = Close[j];
                double stop_loss = Low[j];
                double take_profit = buy_price + 2 * (buy_price - stop_loss);

                // Open buy order
                int ticket = OrderSend(Symbol(), OP_BUY, 1.0, buy_price, 3, stop_loss, take_profit, "Buy Order", 0, 0, clrGreen);

                if (ticket >= 0)
                {
                    isBuyOrderOpen = true; // Set buy order flag to true
                }
                else
                {
                    Print("Error opening buy order: ", GetLastError());
                }
                break;
            }
        }
    }

    // Check for EMA5 < EMA8 < EMA13 condition for a bearish signal and no sell order is open
    if (EMA5 < EMA8 && EMA8 < EMA13 && !isSellOrderOpen)
    {
        // Find the first bearish (black) candle
        for (int j = i; j >= 0; j--)
        {
            if (Close[j] < Open[j]) // Bearish candle
            {
                double sell_price = Close[j];
                double stop_loss = High[j];
                double take_profit = sell_price - 2 * (stop_loss - sell_price);

                // Open sell order
                int ticket = OrderSend(Symbol(), OP_SELL, 1.0, sell_price, 3, stop_loss, take_profit, "Sell Order", 0, 0, clrRed);

                if (ticket >= 0)
                {
                    isSellOrderOpen = true; // Set sell order flag to true
                }
                else
                {
                    Print("Error opening sell order: ", GetLastError());
                }
                break;
            }
        }
    }
}

// Function to check if there are any open orders and update the flags
void CheckOpenOrders()
{
    isBuyOrderOpen = false;
    isSellOrderOpen = false;

    // Loop through all open orders
    for (int i = OrdersTotal() - 1; i >= 0; i--)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderType() == OP_BUY && OrderSymbol() == Symbol())
            {
                isBuyOrderOpen = true; // Found an open buy order
            }
            if (OrderType() == OP_SELL && OrderSymbol() == Symbol())
            {
                isSellOrderOpen = true; // Found an open sell order
            }
        }
    }
}
