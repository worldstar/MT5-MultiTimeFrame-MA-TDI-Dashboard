gpt指令:
================
交易方法是紀錄每一天開盤後的第一個5分鐘K棒的高點與低點，後續的任一5分鐘K棒價格收盤後，有跌破第一根K棒的最低價則下一個SellLimit空單，空單進場價格為每日第一個5分鐘K棒的低點，止損價格則設在每日第一個5分鐘K棒的高點，停利點著設在止損價格減去進場價格2倍的訂單距離。反之，如果後續的任一5分鐘K棒價格收盤後突破開盤5分k棒的高點，則進行下BuyLimit多單，多單進場價格為每日第一個5分鐘K棒的高點，多單的止損價格設在每日第一個5分鐘K棒的低點，停利點著設在進場價格減去止損價格2倍的訂單距離。

================

## 1.買單範例 ##
  ###### 達成止盈時: ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B2%B7%E5%96%AE%E6%AD%A2%E7%9B%88.png) ######
  ###### 達成止損時: ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B2%B7%E5%96%AE%E6%AD%A2%E6%90%8D.png) ######
## 2.賣單範例 ##
  ###### 達成止盈時 ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B3%A3%E5%96%AE%E6%AD%A2%E7%9B%88.png) ######
  -----------------------------------------------
  ###### 達成止損時 #######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B3%A3%E5%96%AE%E6%AD%A2%E6%90%8D.png) #######
