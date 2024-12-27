gpt 3EMA範例
==================

透過比對3個EMA線的相對位置進行交易判斷的程式

gpt指令:
================
寫出寫一個mq5交易程式，
使用EMA5線,EMA8線和EMA13線作為交易判斷指標，
持續記錄最新的上升與下降k棒
當EMA5>EMA8>EMA13且前跟k棒為上升k棒時，
以當根k棒的收盤價進行買入，前三根k棒最低價為止損，
買進價和止損差距的兩倍量作為止盈;
當EMA5<EMA8<EMA13時且前跟k棒為下降k棒時，
以當根k棒的收盤價進行買入，前三根k棒最高價為止損，
買進價和止損差距的兩倍量作為止盈。

================

## 1.買單範例 ##
  ###### 達成止盈時: ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/gpt%20trade%201/%E8%B2%B7%E5%96%AE%E6%AD%A2%E7%9B%88.jpg) ######
  ###### 達成止損時: ######
  ###### ![image]()######
## 2.賣單範例 ##
  ###### 達成止盈時 ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/multiple-timefram/%E7%AF%84%E4%BE%8B%E5%9C%96%E7%89%872.jpg) ######
  -----------------------------------------------
  ###### 達成止損時 #######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/multiple-timefram/%E5%9C%96%E7%89%871.png) #######
