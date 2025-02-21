gpt指令:
================
交易方法是紀錄每一天開盤後的第一個5分鐘K棒的高點與低點，後續的任一5分鐘K棒價格收盤後，有跌破第一根K棒的最低價則下一個SellLimit空單，空單進場價格為每日第一個5分鐘K棒的低點，止損價格則設在每日第一個5分鐘K棒的高點，停利點著設在止損價格減去進場價格2倍的訂單距離。反之，如果後續的任一5分鐘K棒價格收盤後突破開盤5分k棒的高點，則進行下BuyLimit多單，多單進場價格為每日第一個5分鐘K棒的高點，多單的止損價格設在每日第一個5分鐘K棒的低點，停利點著設在進場價格減去止損價格2倍的訂單距離。

## 參考影片
[YouTube 影片](https://youtu.be/4cT8WTyxhYY?si=8LpmV4wrbVHgd_YA)

================
## 買單（Buy）策略

### 1. 標記關鍵價格
- 紀錄每日開盤後第一個 5 分鐘 K 棒的 **高點** 和 **低點**。

### 2. 進場條件
- 若後續的任一 5 分鐘 K 棒 **收盤價** 突破該日第一個 5 分鐘 K 棒的 **高點**，則於 **該 K 棒收盤後** 設定 **Buy Limit** 多單。
- 多單進場價格 = **該日第一個 5 分鐘 K 棒的高點**。

### 3. 風險控管
- **止損（SL）**：設在 **該日第一個 5 分鐘 K 棒的低點**。
- **停利（TP）**：以 **止損距離的 2 倍** 設定。

  ```math
  TP = 進場價格 + 2 \times (進場價格 - 止損價格)

###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B2%B7%E5%96%AE.png) ######


## 1.買單範例 ##
  ###### 達成止盈時: ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B2%B7%E5%96%AE%E6%AD%A2%E7%9B%88.png) ######
  ###### 達成止損時: ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B2%B7%E5%96%AE%E6%AD%A2%E6%90%8D.png) ######

## 賣單（Sell）策略

## 1. 標記關鍵價格
- 紀錄每日開盤後第一個 5 分鐘 K 棒的 **高點** 和 **低點**。

## 2. 進場條件
- 若後續的任一 5 分鐘 K 棒 **收盤價** 跌破該日第一個 5 分鐘 K 棒的 **低點**，則於 **該 K 棒收盤後** 設定 **Sell Limit** 空單。
- **空單進場價格** = 該日第一個 5 分鐘 K 棒的 **低點**。

## 3. 風險控管
- **止損（SL）**：設在 **該日第一個 5 分鐘 K 棒的高點**。
- **停利（TP）**：以 **止損距離的 2 倍** 設定。

  ```math
  TP = 進場價格 - 2 \times (止損價格 - 進場價格)
###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B3%A3%E5%96%AE.png) ######


## 2.賣單範例 ##
  ###### 達成止盈時 ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B3%A3%E5%96%AE%E6%AD%A2%E7%9B%88.png) ######
  -----------------------------------------------
  ###### 達成止損時 #######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/Opening%2015%20Reversal%20Breakout%20Strategy/%E8%B3%A3%E5%96%AE%E6%AD%A2%E6%90%8D.png) #######
