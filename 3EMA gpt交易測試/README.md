gpt 3EMA交易法
==================

透過比對3個EMA線的相對位置進行交易判斷的程式

參考資料
==================
[🔴 5-8-13 EMA "SCALPING"](<https://www.youtube.com/watch?v=jCuKGC6a__0&t=1s&ab_channel=TraderDNA> "Title")


買單邏輯
==================
紀錄最新的下降k棒的最低價，
如果遇到新的下降k棒則覆蓋掉前一個紀錄。
當前一根k棒為上升k棒且收盤價高於紀錄的最高價，
指標EMA5>EMA8>EMA13以及存在紀錄的下降k棒時，
以現k棒開盤價作買進，前三根根k棒的最低價作為止損，
買進價與止損價差的兩倍做止盈
![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/3EMA%20gpt%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/ScreenHunter_356%20Feb.%2021%2014.32.jpg)
賣單邏輯
==================
紀錄最新的上升k棒的最低價和最高價，
如果遇到新的上升k棒則覆蓋掉前一個紀錄。
當前一根k棒為下降k棒且收盤價高於紀錄的最低價，
指標EMA5<EMA8<EMA13
且存在紀錄的上升k棒時，以現k棒開盤價作賣出，
前三根根k棒的最高價作為止損，
買進價與止損價差的兩倍做止盈
![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/3EMA%20gpt%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/ScreenHunter_357%20Feb.%2021%2014.34.jpg)
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
## 操作步驟和選項 ##
###### 選擇3EMA gpt交易.ex5作為主程式並選擇要交易的幣值 ######
![image](https://github.com/user-attachments/assets/76cbecfb-b3fb-4afd-898f-d35a4323e850)
###### 可以選擇交易止盈條件的倍率 ######
![image](https://github.com/user-attachments/assets/cb7fd10e-aa45-4f8f-9e01-33e3e9f38501)

## 1.買單範例 ##
  ###### 達成止盈時: ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/3EMA%20gpt%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/%E8%B2%B7%E5%96%AE%E6%AD%A2%E7%9B%88.jpg) ######
  ###### 達成止損時: ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/3EMA%20gpt%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/%E8%B2%B7%E5%96%AE%E6%AD%A2%E6%90%8D.jpg) ######
## 2.賣單範例 ##
  ###### 達成止盈時 ######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/3EMA%20gpt%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/%E8%B3%A3%E5%96%AE%E6%AD%A2%E7%9B%88.jpg) ######
  -----------------------------------------------
  ###### 達成止損時 #######
  ###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/3EMA%20gpt%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/%E8%B3%A3%E5%96%AE%E6%AD%A2%E6%90%8D.jpg) #######
