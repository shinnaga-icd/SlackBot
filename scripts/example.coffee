# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md


## slack bots controller
module.exports = (robot) ->

  robot.respond /おはよう/i, (res) ->
    res.reply "おはよう！"

  robot.respond /こんにちは/i, (res) ->
    res.reply "こんにちは！"

  robot.respond /おやすみ/i, (res) ->
    res.reply "おやすみ！"
  
  robot.hear /(.*)/i, (res) ->
    input = res.match[1]
    if !isNaN(input)
      res.reply if isFool(input) then convertFool(input) else input



## TODO:以下module化したい…
fool_units = new Map [
  [12, "ﾁｮｳ"]
  ,[8, "ｵｸ"]
  ,[4, "ﾏﾝ"]
  ,[0, ""]
]

fool_units_under9999 = new Map [
  [3, "ｾﾝ"]
  ,[2, "ﾋｬｸ"]
  ,[1, "ｼﾞｭｳ"]
  ,[0, ""]
]

fool_nums = new Map [
  [1, "ｲﾁ"]
  , [2, "ﾆ"]
  , [3, "ｻｧｰﾝ"]
  , [4, "ﾖﾝ"]
  , [5, "ｺﾞ"]
  , [6, "ﾛｸ"]
  , [7, "ﾅﾅ"]
  , [8, "ﾊﾁ"]
  , [9, "ｷｭ-"]
]

# 特殊な読み
fool_str_ex = new Map [
  ["ｲﾁｼﾞｭｳ", "ｼﾞｭｳ"]
  , ["ｲﾁﾋｬｸ", "ﾋｬｸ"]
  , ["ｻｧｰﾝﾋｬｸ", "ｻﾝﾋﾞｬｸ"]
  , ["ﾛｸﾞﾋｬｸ", "ﾛｯﾋﾟｬｸ"]
  , ["ﾊﾁﾋｬｸ", "ﾊｯﾋﾟｬｸ"]
  , ["ｲﾁｾﾝ", "ｾﾝ"]
  , ["ｻｧｰﾝｾﾝ", "ｻﾝｾﾞﾝ"]
  , ["ﾊﾁｾﾝ", "ﾊｯｯｾﾝ"]
]


isFool = (x) ->
  (x % 3) == 0 || x.match("3")

## 数字を馬鹿に変換
convertFool = (x) ->
  foolStr = ''

  if x >= Math.pow(10, 16)
    foolStr = 'ﾜｶﾘﾏｾｰﾝ!!'

  else
    fool_units.forEach (value, key) ->
      calcNum = Math.floor(x / Math.pow(10, key))
      foolStr += (if calcNum >= 1 then convertFoolUnder9999(calcNum) + value else '')
      x -= (Math.pow(10, key) * calcNum)

  x = foolStr + 'wwwwww'

## 0~9999を馬鹿に変換
convertFoolUnder9999 = (x) ->
  foolStr = ''

  fool_units_under9999.forEach (value, key) ->
    digitNum = Math.floor(x / Math.pow(10, key))
    foolStr += (if digitNum >= 1 then convertFoolNum(digitNum) + value else '')
    x -= (Math.pow(10, key) * digitNum)

  # 特殊なよみを変換
  fool_str_ex.forEach (value, key) ->
    foolStr = foolStr.replace key, value
    
  x = foolStr

## 0~9を馬鹿に変換
convertFoolNum = (x) ->
  foolStr = ''

  fool_nums.forEach (value, key) ->
    foolStr += (if x == key then value else '' )
  x = foolStr

