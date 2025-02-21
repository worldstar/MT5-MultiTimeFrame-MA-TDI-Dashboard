K線圖趨勢策略交易
==================

透過觀察k線圖趨勢進行交易判斷的程式


## 參考影片
[YouTube 影片](https://www.youtube.com/watch?v=YaiLhrUfexY&t=257s)

## Outlines
- 1. 買進策略
- 2. 賣出策略
- 3. gpt指令輸入
- 4. 問題與改動
- 5. 回測結果


## 1. 買進策略
檢察連續的五根 K 棒數值，當第一根 K 棒的開盤價減掉第五根 K 棒的收盤價的絕對值，大於五根 K 棒中每一根的大小時：
- 若相減結果為負，則以第五根 K 棒的收盤價進行做多。
- 以兩倍相減數值作為止盈目標。
- 以一倍相減數值作為止損設定。

###### 買單示意圖: ######
###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/K%E7%B7%9A%E5%9C%96%E8%B6%A8%E5%8B%A2%E4%BA%A4%E6%98%93%20GPT%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/%E5%9C%96%E7%89%878.png)![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/K%E7%B7%9A%E5%9C%96%E8%B6%A8%E5%8B%A2%E4%BA%A4%E6%98%93%20GPT%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/%E5%9C%96%E7%89%879.png) ######

## 2. 賣出策略
檢察連續的五根 K 棒數值，當第一根 K 棒的開盤價減掉第五根 K 棒的收盤價的絕對值，大於五根 K 棒中每一根的大小時：
- 若相減結果為正，則以第五根 K 棒的收盤價進行做空。
- 以兩倍相減數值作為止盈目標。
- 以一倍相減數值作為止損設定。

###### 賣單示意圖: ######
###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/K%E7%B7%9A%E5%9C%96%E8%B6%A8%E5%8B%A2%E4%BA%A4%E6%98%93%20GPT%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/%E5%9C%96%E7%89%8710.png)![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/K%E7%B7%9A%E5%9C%96%E8%B6%A8%E5%8B%A2%E4%BA%A4%E6%98%93%20GPT%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/%E5%9C%96%E7%89%8711.png) ######

## 3. gpt指令:
寫一個mq5交易程式，
交易方法為檢察連續的五根k棒數值，
當第一根k棒的開盤價減掉第五根k棒的收盤價的絕對值
大於五根k棒中每一根的大小時，
若相減結果為負，則以第五根k棒的收盤價進行做多，
若相減結果為正，則以第五根k棒的收盤價進行做空，
都以兩倍相減數值為止益，一倍相減數值為止損。

## 4.問題與改動:
- 問題:Bar不能使用，疑似為版本問題導致Bar無法直接宣告，且因為沒有止損導致完全沒有交易
- 改動:因為bar的作用可有可無選擇去掉，並於後續加入了止損
- 新增:避免重複交易的判定(要在交易判定式內加入對應的PositionCount==0)


## 5.回測輸入與結果
###### ![image](https://github.com/worldstar/MT5-MultiTimeFrame-MA-TDI-Dashboard/blob/main/K%E7%B7%9A%E5%9C%96%E8%B6%A8%E5%8B%A2%E4%BA%A4%E6%98%93%20GPT%E4%BA%A4%E6%98%93%E6%B8%AC%E8%A9%A6/%E5%9C%96%E7%89%873.png) ######









