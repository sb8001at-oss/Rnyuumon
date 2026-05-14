# 21  日時データの取り扱い

Code

時間とともに変化する値を記録したデータである**時系列データ**は、統計で取り扱う代表的なデータの一つです。時系列データの代表的な例として、為替や株価、温度や湿度、ネットワークへのアクセス数などが挙げられます。これらのデータを取り扱うためには、**日時データ**を適切に取り扱う必要があります。

日時データは通常文字列として記録されるため、Rでデータを読み込んだ際には、文字列のデータを日時データとして取り扱えるように変換する必要があります。この変換に関する関数をRは多数取り揃えています。

## 21.1 日時データのクラス：Date・POSIXct・POSIXlt・POSIXt

Rでは、日時データのクラスとして、**Date・POSIXct・POSIXlt・POSIXt**の4種類が設定されています。これらのうち、**Date型は日付**のみを取り扱う型、**POSIXct・POSIXlt・POSIXt型は日時（日付＋時間）**を取り扱う型です。これらの型は、それぞれ取り扱い方が少しずつ異なります。

Rには、表1に示す日時データ取り扱いのための関数が備わっています。以下にそれぞれの関数・データ型の取り扱いについて説明します。

| 関数名 | 適用する演算 |
|:---|:---|
| Sys.Date() | 現在の日付を返す(Date) |
| Sys.Time() | 現在の日時を返す(POSIXct) |
| Sys.timezone() | 現在のタイムゾーンを返す |
| as.POSIXlt(x) | xをPOSIXltに変換する |
| weekdays(x) | xの曜日を返す |
| months(x) | xの月名を返す |
| quarters(x) | xの四半期を返す |
| ISOdatetime(y, m, d, h, m, s) | POSIXctオブジェクトを作成 |
| seq(x, by, length.out) | xからbyの間隔でlength.outの長さのベクターを作成 |
| cut.POSIXt(x, breaks) | xをbreaksで丸めた因子を作成 |
| min(x) | xの最小値を返す |
| max(x) | xの最大値を返す |
| mean(x) | xの平均値を返す |
| range(x) | xの範囲を返す |
| difftime(x, y) | xとyの時間差を返す |
| round(x, unit) | xをunitにまるめて返す |
| Sys.sleep(sec) | 演算をsec秒停止する |
| tic() | 時間計測を開始（tictocパッケージ） |
| toc() | 時間計測を終了（tictocパッケージ） |

表1：R標準の日時関連関数群 {.caption-top .table .table-sm .table-striped .small}

> **TIP:**
>
> POSIXtクラスはPOSIXctとPOSIXltの親クラスです。Rの日時に関する関数の多くはPOSIXtクラスを引数に取るよう設定されているため、POSIXctもPOSIXltもほぼ同じように取り扱うことができます。

## 21.2 現在の日時を取得する

`Sys.Date`関数と`Sys.time`関数は、現在の日付・日時をそれぞれ取得するための関数です。`Sys.Date`関数は現在の日付をDateクラスで、`Sys.time`関数は現在の時刻をPOSIXctクラスで返します。同様の関数として`date`関数もありますが、この関数の返り値は文字列です。

`Sys.timezone`関数は、Rが演算に用いるタイムゾーンを返す関数です。日本で使用しているPCでは、通常Asia/Tokyo（GMT+9）をタイムゾーンとしています。

``` downlit
Sys.Date() # 現在の日付（Date）
## [1] "2026-05-15"

Sys.time() # 現在の日時（POSIXct）
## [1] "2026-05-15 05:02:30 +09"

date() # 現在の日時（文字列）
## [1] "Fri May 15 05:02:30 2026"

Sys.timezone() # システムのタイムゾーン
## [1] "Etc/GMT-9"


Sys.Date() |> class() # Sys.Dateの返り値はDate
## [1] "Date"

Sys.time() |> class() # Sys.timeの返り値はPOSIXct（POSIXt）
## [1] "POSIXct" "POSIXt"

date() |> class() # dateの返り値は文字列（character）
## [1] "character"
```

Dateクラスのデータ型は数値で、`as.numeric`関数で数値に変換すると1970年1月1日からの日数を返します。

``` downlit
Sys.Date() |> mode() # Dateクラスは数値型
## [1] "numeric"

Sys.Date() |> as.numeric() # 1970/1/1からの日数
## [1] 20588
```

同様に、POSIXctもデータ型は数値で、数値変換すると1970年1月1日0時0分0秒からの秒数を返します。

``` downlit
Sys.time() |> mode() # POSIXctクラスは数値型
## [1] "numeric"

Sys.time() |> as.numeric() # 1970/1/1からの時間（秒）
## [1] 1778788951
```

## 21.3 POSIXctクラスとPOSIXltクラス

POSIXctクラスのオブジェクトは、`as.POSIXlt`関数でPOSIXltクラスに変換することができます。また、`as.POSIXct`関数を用いてPOSIXltクラスのオブジェクトをPOSIXctクラスに変換することもできます。

POSIXctクラスとPOSIXltクラスの違いは、POSIXctが数値なのに対し、POSIXltにはクラスだけでなく、名前（`names`）とタイムゾーン（`tzone`）がアトリビュートとして設定されているリストである点です。POSIXltは名前付きリストですので、設定されている名前（`sec`、`min`、`hour`、`mday`など）を用いて、秒、分、時、日などの日時の部分データを呼び出すことができます。

``` downlit
Sys.time() |> as.POSIXct() # POSIXctに変換
## [1] "2026-05-15 05:02:30 +09"

Sys.time() |> as.POSIXlt() # POSIXltに変換
## [1] "2026-05-15 05:02:30 +09"


t <- Sys.time() # tはPOSIXct
t$year # POSIXctには名前が無いため、エラー
## Error in `t$year`:
## ! $ operator is invalid for atomic vectors

attributes(t) # class以外は設定されていない
## $class
## [1] "POSIXct" "POSIXt"


t1 <- as.POSIXlt(t) # t1はPOSIXlt
attributes(t1) # 名前とタイムゾーンが設定されている
## $names
##  [1] "sec"    "min"    "hour"   "mday"   "mon"    "year"   "wday"   "yday"  
##  [9] "isdst"  "zone"   "gmtoff"
## 
## $class
## [1] "POSIXlt" "POSIXt" 
## 
## $tzone
## [1] ""    "+09" "   "
## 
## $balanced
## [1] TRUE

as.numeric(t1) # POSIXltも数値に置き換えできる
## [1] 1778788951

mode(t1) # POSIXltはリスト
## [1] "list"

t1$mday # POSIXltは$で名前から呼び出し可能
## [1] 15

t1$hour
## [1] 5

t1$wday # 曜日は月曜日が1
## [1] 5

t1$zone # タイムゾーン
## [1] "+09"
```

POSIXltにはタイムゾーンがアトリビュートとして設定されており、POSIXctには設定されていませんが、いずれも`as.POSIXlt`、`as.POSIXct`関数の`tz`引数を設定することで、タイムゾーンを変更することができます。

ただし、POSIXltから`as.POSIXct`関数でタイムゾーンを変更するときにはタイムゾーンは変更になりますが、時間は修正されません。また、POSIXltクラスのオブジェクトを`as.POSIXlt`関数の引数とした場合にはタイムゾーンが変更されない仕様になっています。

``` downlit
Sys.time() |> class() # POSIXctクラスのオブジェクト
## [1] "POSIXct" "POSIXt"
as.POSIXct(Sys.time(), tz = "GMT") # POSIXct型のSys.time()をUTCに変換
## [1] "2026-05-14 20:02:30 GMT"

as.POSIXct(Sys.time(), tz = "EST") # アメリカ東時間に変換
## [1] "2026-05-14 15:02:30 EST"

as.POSIXlt(Sys.time(), "GMT") # POSIXlt型をUTCに変換
## [1] "2026-05-14 20:02:30 GMT"

as.POSIXlt(Sys.time(), "EST") # アメリカ東時間に変換
## [1] "2026-05-14 15:02:30 EST"

class(t1) # POSIXltクラスのオブジェクト
## [1] "POSIXlt" "POSIXt"
# 引数がPOSIXltだとタイムゾーンの変更ができない
as.POSIXlt(t1, tz = "EST")
## [1] "2026-05-15 05:02:30 +09"
# POSIXltからPOSIXctに変換するとタイムゾーンが変更できる（時刻は変更されない）
as.POSIXct(t1, tz = "EST")
## [1] "2026-05-15 05:02:30 EST"
```

POSIXct、POSIXltクラスのオブジェクトは、共にRの日時データに関する関数の引数として設定し、演算を行うことができます。

代表的な日時データに関する関数は、`weekdays`関数や`months`関数、`quarters`関数などです。いずれも日時データのベクターを引数に取り、曜日・月・四半期などの値を返します。

``` downlit
weekdays(t)
## [1] "金曜日"

weekdays(t, abbreviate = T) # 省略形
## [1] "金"

weekdays(as.POSIXlt(t, tz="EST")) # US時間に変更しても、日本語で出てくる
## [1] "木曜日"


t2 <- c(as.POSIXct("2023-10-10 11:11:11"), as.POSIXct("2024-1-11 11:11:11"))
weekdays(t2) # ベクターでも処理可能
## [1] "火曜日" "木曜日"

months(t2) # 月を返す関数
## [1] "10月" "1月"

quarters(t2) # 四半期を返す関数
## [1] "Q4" "Q1"
```

> **TIP:**
>
> weekdaysの表示はRの**Locale**に依存して決まっています。Localeは`Sys.getlocale`関数で確認できます。
>
> ``` downlit
> Sys.getlocale()
> ## [1] "LC_COLLATE=Japanese_Japan.utf8;LC_CTYPE=Japanese_Japan.utf8;LC_MONETARY=Japanese_Japan.utf8;LC_NUMERIC=C;LC_TIME=Japanese_Japan.utf8"
> ```
>
> Localeは`Sys.setlocale`関数で変更できますが、どうしても英語にしたい、といった場合を除けばあまりいじらなくてよいでしょう。

## 21.4 文字列を日時データに変換する

Excelやテキストファイルなどでは、日時データは文字列や数値で保存されています。Rでは文字列や数値をそのまま日時データとして取り扱うことはできないため、日時データに変換する必要があります。日時データへの変換にも、`as.POSIXct`関数や`as.POSIXlt`関数を用います。

文字列は、日本人が通常使うような日時の表現（`"2022/2/22 11:11:11"`や`"2022-2-22 11:11:11"`など）であれば、その文字列のみを引数に取り、`as.POSIXct`関数や`as.POSIXlt`関数で日時クラスに変換できます。

ただし、単に日時の数値を並べた文字列や、年月日等の日本語が混じった文字列では、どのような日時データなのかRが読み解くことができないため、`as.POSIXct`関数や`as.POSIXlt`関数で直接日時データに変換することはできません。

このように、文字列を日時データに変換する場合には、変換のルールである**フォーマット**を指定する必要があります。フォーマットとは、%（パーセント）に特定のアルファベットを付けて、年や月、分などを指定するものです。例えば、年であれば`%Y`や`%y`、月であれば`%m`が対応するフォーマットとなります。フォーマットの一覧を以下の表2に示します。

| 記号 | 意味                                            |
|:-----|:------------------------------------------------|
| %a   | 省略した曜日名（Mon, Tueなど）                  |
| %A   | 省略しない曜日名（Mondayなど）                  |
| %b   | 省略した月名（Jan，Febなど）                    |
| %B   | 省略しない月名（Januaryなど）                   |
| %c   | 日時（通常表示はこれ，%Y-%m-%d %H:%M:%Sと同じ） |
| %C   | 世紀                                            |
| %d   | 日（01-30日）                                   |
| %D   | 日付（%Y-%m-%dと同じ）                          |
| %e   | 日（1-30日，ゼロがないもの）                    |
| %F   | %Y-%m-%dと同じ                                  |
| %g   | week-based-yearの最後2桁（1-99）                |
| %G   | week-based-year（01-99）                        |
| %h   | %bと同じ                                        |
| %H   | 時間（00-23）                                   |
| %I   | 時間（00-12）                                   |
| %j   | 年基準の日数（001-366）                         |
| %m   | 月（01-12）                                     |
| %M   | 分（00-59）                                     |
| %n   | 新しい行（出力），スペース（入力）              |
| %p   | AM・PMの表記                                    |
| %r   | %I:%M:%S %pと同じ                               |
| %R   | %H:%Mと同じ                                     |
| %S   | 秒（00-61）                                     |
| %t   | タブ切り（出力），スペース（入力）              |
| %T   | %H:%M:%Sと同じ                                  |
| %u   | 週の日数（1-7，1は月曜）                        |
| %U   | 日曜日を始めとするweek of the year（00-53）     |
| %V   | ISO8601に従ったweek of the year（01-53）        |
| %w   | 週の日数（0-6，0は日曜）                        |
| %W   | 月曜日を始めとするweek of the year（00-53）     |
| %x   | %y/%m/%dと同じ                                  |
| %X   | %H:%M:%Sと同じ                                  |
| %y   | 世紀表現なしの年（00-99）                       |
| %Y   | 正規表現込みの年（2023など）                    |
| %z   | UTCからの時間差表現（-0800など）                |
| %Z   | タイムゾーンの出力                              |

表2：日時formatの記載一覧 {.caption-top .table .table-sm .table-striped .small}

フォーマットを利用することで、日本語の混じった文字列や、単に数値だけの文字列であっても、日時データに変換することができます。

``` downlit
as.POSIXlt("2022-2-22 11:11:11")
## [1] "2022-02-22 11:11:11 +09"

as.POSIXlt("2022/2/22 11:11:11")
## [1] "2022-02-22 11:11:11 +09"

as.Date("2022/10/22")
## [1] "2022-10-22"


as.POSIXct("20221022 111111") # エラー
## Error in `as.POSIXlt.character()`:
## ! character string is not in a standard unambiguous format

as.POSIXct("20221022 111111", format = "%Y%m%d %H%M%S") # フォーマットを設定
## [1] "2022-10-22 11:11:11 +09"

as.Date("20221022", format = "%Y%m%d")
## [1] "2022-10-22"

 # 漢字が混じっていても、フォーマットを設定すると日時データに変換できる
as.POSIXct("2022年10月22日 11時11分11秒", format = "%Y年%m月%d日 %H時%M分%S秒")
## [1] "2022-10-22 11:11:11 +09"
```

## 21.5 数値を日時データに変換する

`as.Date`や`as.POSIXct`の引数に数値を指定すると、1970年1月1日からの日数・秒数に従い日時データに変換されてしまいます。したがって、数値を日時データに変換する場合には、まず文字列に変換しておく必要があります。

``` downlit
as.Date(20221022, format = "%Y%m%d") # 数値はうまく変換できない
## [1] "57333-04-12"

20221022 |> as.character() |> as.Date(format = "%Y%m%d") # 文字列に変換する
## [1] "2022-10-22"
```

### 21.5.1 ISOdatetime関数で日時データを作成する

`ISOdatetime`関数を用いて日時データを作成することもできます。`ISOdatetime`関数は引数に年、月、日、時、分、秒の数値を取り、引数に応じた日時データをPOSIXctクラスで返します。

``` downlit
ISOdatetime(2022, 2, 22, 2, 22, 22) # POSIXct型の2022/2/22 2:22:22を作成
## [1] "2022-02-22 02:22:22 +09"
```

## 21.6 連続した日時データの作成

ココまでは、1つの日時データの作成について見てきました。しかし、統計では日時データとして一定間隔で数時間～数年などの連続した時間を取り扱う場合が多いです。このような一定間隔での日時データの作成には、`seq`関数を用います。

数値ベクターでの`seq`関数と同じく、第一引数に始めの日時、第二引数に終わりの日時、`by`引数に時間間隔を入力すると、始めの日時から終わりの日時まで、`by`引数で指定した間隔での連続した日時データを作成することができます。

`seq`関数の引数には`Date`クラスも`POSIXt`クラスも利用することができますが、`Date`クラスと`POSIXt`クラスを同時に用いることはできません。

``` downlit
day1 <- as.POSIXlt("2022-2-22")
day2 <- as.POSIXlt("2022-2-26")

# day1からday2まで、1日置きのベクター
seq(day1, day2, by="day")
## [1] "2022-02-22 +09" "2022-02-23 +09" "2022-02-24 +09" "2022-02-25 +09"
## [5] "2022-02-26 +09"

# 1日間隔で、5日間のベクター
seq(day1, by="day", length.out=5)
## [1] "2022-02-22 +09" "2022-02-23 +09" "2022-02-24 +09" "2022-02-25 +09"
## [5] "2022-02-26 +09"

# 1週間間隔で、5週間のベクター
seq(day1, by="week", length.out=5)
## [1] "2022-02-22 +09" "2022-03-01 +09" "2022-03-08 +09" "2022-03-15 +09"
## [5] "2022-03-22 +09"

# 2週間間隔で、10週間のベクター
seq(day1, by="2 week", length.out=5)
## [1] "2022-02-22 +09" "2022-03-08 +09" "2022-03-22 +09" "2022-04-05 +09"
## [5] "2022-04-19 +09"

day3 <- as.Date("2022-2-22") # Dateクラスでも同じ演算が使える
seq(day3, by="1 week", length.out=5)
## [1] "2022-02-22" "2022-03-01" "2022-03-08" "2022-03-15" "2022-03-22"

seq(day1, day3, by="day") # POSIXtとDateを同時に使うとエラー
## Error in `seq.POSIXt()`:
## ! 'to' must be a "POSIXt" object
```

> **TIP:**
>
> `seq`関数はジェネリック関数の一つで、引数が数値の場合には`seq.default`関数、整数の場合には`seq.int`関数、引数がPOSIXtの場合には`seq.POSIXt`関数、引数がDateの場合は`seq.Date`関数がそれぞれ実行されます。`seq`関数の第一引数と第二引数のクラスは同じである必要があります。引数にDateとPOSIXtを指定すると、第一引数に従い用いる関数が変化するため（第一引数がDateなら`seq.Date`、POSIXtなら`seq.POSIXt`が呼び出される）、第一引数と第二引数のデータ型が異なるとエラーとなります。

## 21.7 cut関数

`cut`関数は、第一引数に日時データのベクター、第二引数`by`に時間間隔（`"weeks"`、`"months"`など）を取り、時間間隔で指定した範囲の日時データを同一の値に変換する関数です。返り値は因子になるため、週や月、年の集計データを収集したい場合などに利用できます。

``` downlit
hdays <- seq(day1, by="day", length.out = 25) # 2022-2-22から25日間のデータ
cutdays <- cut(hdays, "weeks") # hdaysを週ごとに分けて、因子にする
cutdays[1:14] # 同一週の日時は同じ因子のレベルが振り当てられる
##  [1] 2022-02-21 2022-02-21 2022-02-21 2022-02-21 2022-02-21 2022-02-21
##  [7] 2022-02-28 2022-02-28 2022-02-28 2022-02-28 2022-02-28 2022-02-28
## [13] 2022-02-28 2022-03-07
## Levels: 2022-02-21 2022-02-28 2022-03-07 2022-03-14

class(cutdays) # cut関数の返り値は因子
## [1] "factor"

levels(cutdays) # 週ごとにレベルが設定される
## [1] "2022-02-21" "2022-02-28" "2022-03-07" "2022-03-14"
```

## 21.8 日時データを引数に取る関数

上記の`cut`関数以外にも、Rには日時データを引数に取る関数が多数設定されています。例えば最初の日時、最後の日時を返す`min`・`max`関数、平均の日時を返す`mean`関数、最初と最後の日時を返す`range`関数などが代表例です。日時の差は`difftime`関数で計算することができますが、単に日時データを引き算することでも計算できます。また、特定の単位（年、月、日など）で丸める場合には、`round`関数を用いることができます。

``` downlit
min(hdays)
## [1] "2022-02-22 +09"

max(hdays)
## [1] "2022-03-18 +09"

mean(hdays)
## [1] "2022-03-06 +09"

range(hdays)
## [1] "2022-02-22 +09" "2022-03-18 +09"

difftime(max(hdays), min(hdays))
## Time difference of 24 days

max(hdays) - min(hdays)
## Time difference of 24 days

round(t, unit="year")
## [1] "2026-01-01 +09"
```

## 21.9 演算を一時停止する：Sys.sleep関数

`Sys.sleep`関数はRの演算の途中で、演算を指定した時間だけ一時停止するための関数です。一時停止する時間（秒）を数値で引数に取ります。

``` downlit
Sys.sleep(5) # 5秒待つ
```

## 21.10 演算時間の計測

`Sys.time`関数を用いると、演算にかかる時間を計測することができます。繰り返し計算などで、とても時間がかかる演算を含む場合には、あらかじめ演算時間を計測しておくと、繰り返し計算全体でどの程度時間がかかるのか把握しやすくなります。

まず、`Sys.time`関数の返り値である、現在の時刻を変数`t`に代入します。その後何らかの演算を行い（下の例では`Sys.sleep`関数で3秒停止）、その後、演算後の現在時刻から`t`を引くと、`Sys.sleep`関数による演算の時間を計測することができます。`Sys.sleep`関数による3秒の停止以外にも、代入等でわずかに時間がかかるため、3秒よりほんの少し時間がかかっていることが計測できます。

同様の時間計測は、`system.time`関数を用いても行うことができます。`system.time`関数は演算全体を引数に取り、その演算にかかる時間を計測します。

``` downlit
t <- Sys.time() # 現在時刻を記録
Sys.sleep(3) # 3秒スリープ
Sys.time() - t # 現在時刻と記録した時刻の差を計算
## Time difference of 3.050647 secs

# system.time関数でも演算時間を計測できる
system.time(for(i in 1:100000){mean(1:i)})
##    user  system elapsed 
##    8.65    0.03   16.00
```

### 21.10.1 tictocパッケージ

もう少しスマートに演算時間を計測する方法を[`tictoc`](https://cran.r-project.org/web/packages/tictoc/index.html)パッケージ ([Izrailev 2023](#ref-tictoc_bib))が提供しています。`tictoc`パッケージには`tic`関数と`toc`関数が設定されており、`tic`関数で計測を開始し、`toc`関数で計測を終了、演算時間を返します。

`tic`関数は引数に文字列を取ることができ、`toc`関数で計測時間が返ってくる時に、この`tic`関数の引数を同時に返してくれます。`tic`関数、`toc`関数による時間計測は、**後入れ先出し（Last In, First Out, LIFO）**のルールに従い時間を計測します。ですので、後から`tic`関数で計測をスタートした演算時間は、先の`toc`関数で返ってくる仕組みになっています。

``` downlit
pacman::p_load(tictoc)
tic()
Sys.sleep(3)
toc()
## 3.04 sec elapsed

tic("first")
tic("second")
tic("third")
toc() # 後のtic（third）からの時間がまず返ってくる
## third: 0 sec elapsed

toc()
## second: 0 sec elapsed

toc() # 先のtic（first）が最後に返ってくる
## first: 0 sec elapsed
```

## 21.11 時系列データ：tsクラス

**時系列データ（time series data）**は、日時データとセットになった測定値です。例えば、[18章](chapter18.llms.md#nile)で説明した`Nile`のデータセットは時系列データの代表的な例です。`Nile`は1871年から1970年のナイル川の流量を年ごとに測定したデータです。

``` downlit
Nile # 時系列データの代表例：ナイル川の流量
## Time Series:
## Start = 1871 
## End = 1970 
## Frequency = 1 
##   [1] 1120 1160  963 1210 1160 1160  813 1230 1370 1140  995  935 1110  994 1020
##  [16]  960 1180  799  958 1140 1100 1210 1150 1250 1260 1220 1030 1100  774  840
##  [31]  874  694  940  833  701  916  692 1020 1050  969  831  726  456  824  702
##  [46] 1120 1100  832  764  821  768  845  864  862  698  845  744  796 1040  759
##  [61]  781  865  845  944  984  897  822 1010  771  676  649  846  812  742  801
##  [76] 1040  860  874  848  890  744  749  838 1050  918  986  797  923  975  815
##  [91] 1020  906  901 1170  912  746  919  718  714  740
```

このような時系列データをRで取り扱うために準備されているクラスが、**tsクラス**です。tsクラスには計測されたデータと共に、日時に関する情報が付属しています。

``` downlit
attributes(Nile) # 日時に関するattribute（tsp）が記録されている
## $tsp
## [1] 1871 1970    1
## 
## $class
## [1] "ts"
```

tsクラスを引数とする関数が、Rには複数備わっています。tsクラスを引数とする関数の一覧を以下の表3に示します。

| 関数名 | 適用する演算 |
|:---|:---|
| ts(x, frequency, start) | frequency周期で，startから始まるtsオブジェクトを作成する |
| as.ts(x) | tsに変換する |
| is.ts(x) | tsかどうか確認する |
| tsp(x) | tsオブジェクトを要約したベクターに変換する |
| cycle(x) | frequencyの周期の位置を返す |
| frequency(x) | frequencyを返す |
| deltat(x) | データの時間間隔を返す |
| window(x, start, end) | startからendまでのデータを返す |
| time(x) | 時間に変換する |
| start(x) | 開始日時を返す |
| end(x) | 終了日時を返す |

表3：tsクラスを引数とする関数群 {.caption-top .table .table-sm .table-striped .small}

``` downlit
value <- rep(1:3, 8) # 時系列の元になる値
# tsクラスの変数を作成
tsobj <- ts(value, frequency = 1, start=c(2023)) 
tsobj # 2023年から2046年までのtsクラスのデータ
## Time Series:
## Start = 2023 
## End = 2046 
## Frequency = 1 
##  [1] 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3

as.ts(1:12) # tsに変換
## Time Series:
## Start = 1 
## End = 12 
## Frequency = 1 
##  [1]  1  2  3  4  5  6  7  8  9 10 11 12

tsobj |> is.ts() # tsオブジェクトであることを確認
## [1] TRUE

ts(value, frequency = 4, start=c(2023)) # 4半期ごとのデータ
##      Qtr1 Qtr2 Qtr3 Qtr4
## 2023    1    2    3    1
## 2024    2    3    1    2
## 2025    3    1    2    3
## 2026    1    2    3    1
## 2027    2    3    1    2
## 2028    3    1    2    3

ts(value, frequency = 12, start=c(2023)) # 月次のデータ
##      Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
## 2023   1   2   3   1   2   3   1   2   3   1   2   3
## 2024   1   2   3   1   2   3   1   2   3   1   2   3

tsobj2 <- ts(value, frequency = 4, start=c(2023))
tsobj2 |> tsp() # 2023年から2028年4Qまで四半期置きのデータ
## [1] 2023.00 2028.75    4.00

tsobj2 |> cycle() # 四半期（cycle）についてのラベル
##      Qtr1 Qtr2 Qtr3 Qtr4
## 2023    1    2    3    4
## 2024    1    2    3    4
## 2025    1    2    3    4
## 2026    1    2    3    4
## 2027    1    2    3    4
## 2028    1    2    3    4

tsobj2 |> frequency() # frequencyは4
## [1] 4

tsobj2 |> deltat() # データの間隔は1/4年
## [1] 0.25

# 2025年1Qから2026年4Qまでのデータを返す
tsobj2 |> window(c(2025, 1), c(2026, 4)) 
##      Qtr1 Qtr2 Qtr3 Qtr4
## 2025    3    1    2    3
## 2026    1    2    3    1

tsobj2 |> time() # 各データの時点に変換
##         Qtr1    Qtr2    Qtr3    Qtr4
## 2023 2023.00 2023.25 2023.50 2023.75
## 2024 2024.00 2024.25 2024.50 2024.75
## 2025 2025.00 2025.25 2025.50 2025.75
## 2026 2026.00 2026.25 2026.50 2026.75
## 2027 2027.00 2027.25 2027.50 2027.75
## 2028 2028.00 2028.25 2028.50 2028.75

tsobj2 |> start() # 2023年1Qからのデータ
## [1] 2023    1

tsobj2 |> end() # 2028年4Qまでのデータ
## [1] 2028    4
```

> **TIP:**
>
> 時系列データを取り扱う場合に、必ずしもtsクラスのオブジェクトを用いないといけない、というわけではありません。日時データと値の2つのベクターを用いても、時系列の解析を行うことはできます。
>
> 時系列データの解析には、[Stan](https://mc-stan.org/) ([Carpenter et al. 2017](#ref-carpenter2017stan))などの外部ツールを用いる場合もあるため、場合によってはtsクラスではないデータの方が取り扱いやすい場合もあります。

## 21.12 lubridateパッケージ

上記のように、Rには時間を取り扱うクラスとして、Date、POSIXct、POSIXlt、tsなどを備えています。ただし、フォーマットの設定や関数に見られるように、必ずしもすべてのクラスが時系列データの解析において使いやすい、というわけではありません。

Rでの日時データの取り扱いを簡単にするためのパッケージが、[`lubridate`](https://lubridate.tidyverse.org/)パッケージ ([Grolemund and Wickham 2011](#ref-lubridate_bib))です。`lubridate`パッケージは日時データを取り扱うための関数のセットを提供しており、様々なフォーマットの文字列を簡単に日時データに変換し、演算に用いることができます。

`lubridate`パッケージが提供する関数群を以下の表4に示します。

| 関数名 | 適用する演算 |
|:---|:---|
| ymd(x), mdy(x), dmy(x) | xを日付に変換 |
| ymd_hms(x), ymd_hm(x) | xを日時に変換 |
| hms(x) | xを時間に変換 |
| parse_date_time(x, order) | xをorderに従い日時に変換 |
| year(x) | xの年を返す |
| year(x)\<- | xの年を代入値に変換する |
| month(x) | xの月を返す |
| day(x) | xの日を返す |
| hour(x) | xの時間を返す |
| minute(x) | xの分を返す |
| second(x) | xの秒を返す |
| tz(x) | タイムゾーンを返す |
| now() | 現在の日時を返す |
| today() | 現在の日付を返す |
| stamp(char)(x) | xをcharの文字列に合わせて返す |
| duration(x, units) | 単位がunits，値がxの時間差（period）オブジェクトを作成 |
| years(n) | n年のperiodオブジェクトを作成 |
| months(n) | n月のperiodオブジェクトを作成 |
| days(n) | n日のperiodオブジェクトを作成 |
| hours(n) | n時間のperiodオブジェクトを作成 |
| minutes(n) | n分のperiodオブジェクトを作成 |
| seconds(n) | n秒のperiodオブジェクトを作成 |
| am(x) | xが午前中ならTRUEを返す |
| pm(x) | xが午後ならTRUEを返す |
| interval(x, y) | xとyのintervalオブジェクトを作成 |
| int_length(x) | xの期間の長さを返す |
| int_overlaps(x, y) | xとyに時間の重なりがあればTRUEを返す |

表4：lubridateパッケージの関数群 {.caption-top .table .table-sm .table-striped .small}

### 21.12.1 日付データへの変換：ymd関数

文字列を日時データに変換する場合、`as.POSIXlt`関数や`as.Date`関数で、フォーマットを指定するのがRのデフォルトの手法です。この手順を簡単に行うことができる関数が、`ymd`関数を含む関数群です。`ymd`は、「year, month, day」の略で、この年月日の順で数値が記載された文字列や数値であれば、かなり適当に記載した文字列・数値であっても、正確に日時データに変換してくれます。

日本では年月日の順で日付を書くのが一般的ですが、アメリカでは月日年、ヨーロッパでは日月年の順で日付を書くことになっています。このように、年月日の順番が異なる場合には、`ymd`関数ではなく、`mdy`関数や`dmy`関数を用いることで、日時データに簡単に変換することができます。

``` downlit
pacman::p_load(lubridate)

# どんな書き方でも変換してくれる
ymd("20231020")
## [1] "2023-10-20"

ymd("2023/10/20")
## [1] "2023-10-20"

ymd("2023-10-20")
## [1] "2023-10-20"

ymd("23 10 20")
## [1] "2023-10-20"

ymd("2023年10月20日") # 漢字が入っていても変換可能
## [1] "2023-10-20"

ymd(20231020) # 数値でも変換可能
## [1] "2023-10-20"

ymd(231020)
## [1] "2023-10-20"

mdy("10/20/2023") # USでは月/日/年
## [1] "2023-10-20"

dmy("20/10/2023") # ヨーロッパでは日/月/年
## [1] "2023-10-20"

ym("2023/10") # yearとmonthだけのデータも対応できる
## [1] "2023-10-01"
```

### 21.12.2 日時データの変換：ymd_hms関数

時間を含むデータの場合には、`ymd_hms`関数などの関数群を用います。こちらも、かなりいい加減な記載の日時データでも、簡単にPOSIXctクラスに変換してくれます（デフォルトのタイムゾーンはUTC、グリニッジ標準時）。タイムゾーンは`tz`引数に文字列で指定（[TZ identifier](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)で指定）することで変更できます。

``` downlit
ymd_hms("2023/10/20 22:22:22") # POSIXctに変換
## [1] "2023-10-20 22:22:22 UTC"

ymd_hms("2023年10月20日 22時22分22秒") # POSIXctに変換
## [1] "2023-10-20 22:22:22 UTC"

ymd_hms(231020222222) # 数値も変換できる
## [1] "2023-10-20 22:22:22 UTC"

ymd_hms("2023年10月20日 22時22分22秒", tz="Asia/Tokyo") # JSTに変換
## [1] "2023-10-20 22:22:22 JST"
```

`ymd`関数群や`ymd_hms`関数群などの機能を1つの関数に落とし込んだものが、`parse_date_time`関数です。この`parse_date_time`関数では、関数名で年月日の順番を指定するのではなく、`orders`という引数で年月日、時間の順番を指定します。

``` downlit
parse_date_time("2023/12/21", "ymd")
## [1] "2023-12-21 UTC"

parse_date_time("2023/12/21 12:25:30", "ymdHMS")
## [1] "2023-12-21 12:25:30 UTC"
```

`lubridate`には、日時データから年や月などの一部を取り出す関数群として、`year`、`month`、`week`、`day`、`hour`、`minute`、`second`が設定されています。日時データを引数に取り、関数に数値を代入することで、特定の値を変更することもできます。

また、日時データのタイムゾーンを`tz`関数で取得することができ、日時データを引数に取った`tz`関数にタイムゾーンを代入することで、タイムゾーンを変更することもできます。

``` downlit
t <- ymd("2023/10/20") # Dateクラスの変数を作成
year(t)
## [1] 2023

year(t) <- 2024 # 代入で変更できる
t
## [1] "2024-10-20"

tz(t) # タイムゾーンを返す関数
## [1] "UTC"

tz(t) <- "Asia/Tokyo" # 代入でタイムゾーンも変更可能
tz(t)
## [1] "Asia/Tokyo"
```

### 21.12.3 現在時刻の取得：today関数とnow関数

`Sys.Date`関数や`Sys.time`関数と同じような関数として、`lubridate`には`today`関数と`now`関数が設定されています。

``` downlit
today() # 今日の日付
## [1] "2026-05-15"

now() # 今の日時
## [1] "2026-05-15 05:02:53 +09"
```

### 21.12.4 時刻を整形した文字列に変換：stamp関数

`stamp`関数は日時データを整形し、文字列として返すための関数です。`stamp`関数の引数は日時を表記するための文字列で、日時自体はどのような時間でも問題ありません。`stamp`関数の後にカッコを付けて、カッコ内に文字列に変換したい日時データを与えます。この関数を実行すると、カッコ内の日時データを、`stamp`関数の引数の形に従って整形した文字列に変換して返してくれます。

文字列が日付のみで、日時データがPOSIXctなどの時間を含むデータだと、正しく変更できない場合もあります。

``` downlit
stamp("1970/1/1 12:00:00")(now())
## Multiple formats matched: "%Y/%Om/%d %H:%M:%S"(1), "%Y/%d/%Om %H:%M:%S"(1), "%Y/%m/%d %H:%M:%S"(1), "%Y/%d/%m %H:%M:%S"(1)
## Using: "%Y/%Om/%d %H:%M:%S"
## [1] "2026/05/15 05:02:53"

stamp("1970/1/1 12:00:00に作成されたデータ")(now())
## Multiple formats matched: "%Y/%Om/%d %H:%M:%Sに作成されたデータ"(1), "%Y/%d/%Om %H:%M:%Sに作成されたデータ"(1), "%Y/%m/%d %H:%M:%Sに作成されたデータ"(1), "%Y/%d/%m %H:%M:%Sに作成されたデータ"(1)
## Using: "%Y/%Om/%d %H:%M:%Sに作成されたデータ"
## [1] "2026/05/15 05:02:53に作成されたデータ"

# うまくいかないときもある（月と日を曜日に変換している）。
stamp_date("1970年01月01日")(now()) 
## Multiple formats matched: "%Y年%Om%a%d%a"(1), "%Y年%d%a%Om%a"(1), "%Y年%m%a%d%a"(1), "%Y年%d%a%m%a"(1), "%Y年%Om月%d日"(1), "%Y年%d月%Om日"(1), "%Y年%m月%d日"(1), "%Y年%d月%m日"(1)
## Using: "%Y年%Om%a%d%a"
## [1] "2026年05金15金"
```

## 21.13 periodクラス

ココまではDateクラス、POSIXct・POSIXlt型に関する`lubridate`の関数について示してきました。`lubridate`には、Date・POSIXct・POSIXlt以外に、時間の間隔を取り扱うクラスとして、**periodクラス**が備わっています。

DateクラスやPOSIXctクラスは基本的に数値型ですので、足し算や引き算で日時を変更することができます。ただし、例えばPOSIXct型で1年3ヶ月と10日後の、3時間前といった変更をしたい場合には、すべて秒として換算し直して演算を行う必要があります。これはあまり直感的ではありませんし、月ごとに日数が異なっているため、正確に演算することも困難です。

``` downlit
today()
## [1] "2026-05-15"

today() + 10 # 10日後
## [1] "2026-05-25"

now()
## [1] "2026-05-15 05:02:53 +09"

now() + 60 # 1分後
## [1] "2026-05-15 05:03:53 +09"

today() + 365 * 1 + 3 * 30 + 10 # 1年3ヶ月と10日後
## [1] "2027-08-23"
```

このような複雑な日時データの演算に対応するため、`lubridate`ではperiodクラスのオブジェクトを作成し、このオブジェクトを演算に用いることができるようになっています。

periodクラスのオブジェクトを作成するには、`duration`関数を用いる、または、`years`、`months`、`days`、`hours`、`minutes`、`seconds`の、「時間の単位+s」の名前が付いた関数を用います。

`duration`関数は引数に数値と時間の単位を取り、引数の時間単位で数値の値を持つオブジェクトを作成する関数です（クラスはDuration）。このオブジェクトはDateクラスやPOSIXctクラスとの演算に用いることができます。

例えば、Periodクラスのオブジェクトである`months(20)`を用いて、「`now() + months(20)`」とすると、現在時刻から20ヶ月後を演算することができます。「1年3ヶ月と10日後の、3時間前」といった複雑な計算も、このperiodクラスを用いれば簡単に行うことができます。

``` downlit
duration(90, "seconds") # 90秒のperiod
## [1] "90s (~1.5 minutes)"

now() + duration(10, "years") # 10年後
## [1] "2036-05-14 17:02:53 +09"

now() + years(10) # 上と同じ
## [1] "2036-05-15 05:02:53 +09"

now() + months(20) # 20ヶ月後
## [1] "2028-01-15 05:02:53 +09"

now() + days(30)
## [1] "2026-06-14 05:02:53 +09"

now() + hours(40)
## [1] "2026-05-16 21:02:53 +09"

now() + minutes(50)
## [1] "2026-05-15 05:52:53 +09"

now() + seconds(60)
## [1] "2026-05-15 05:03:53 +09"
```

### 21.13.1 hms関数

時間に関するperiodクラスのオブジェクトを作成する場合には、`ymd`関数のように、文字列を自動的にperiodクラスのオブジェクトに変換してくれる関数である、`hms`関数を用いることができます。`hms`関数は文字列を時・分・秒を持つperiodクラスのオブジェクトに変換し、返してくれます。`ymd`とは異なり、`hms`関数は数値をperiodに変換することはできません。

``` downlit
hms("2:22:22")
## [1] "2H 22M 22S"

hms(22222) # エラー
## Warning in .parse_hms(..., order = "HMS", quiet = quiet): Some strings failed
## to parse
## [1] NA
```

### 21.13.2 時間の切り上げ・切り下げ

日時データを四捨五入する際には、Rの`round`関数を用いることができます。ただし、切り下げ（`floor`）や切り上げ（`ceiling`）の関数は、DateクラスやPOSIXtクラスには対応していません。

日時の四捨五入・切り下げ・切り上げには、`round_date`、`floor_date`、`ceiling_date`関数を用いることができます。切り上げ等の単位は、`unit`引数に指定します。

``` downlit
now() |> round_date(unit="month") # 月で四捨五入
## [1] "2026-05-01 +09"

now() |> floor_date(unit="hour") # 時間で切り下げ
## [1] "2026-05-15 05:00:00 +09"

now() |> ceiling_date(unit="hour") # 時間で切り上げ
## [1] "2026-05-15 06:00:00 +09"
```

### 21.13.3 am・pm関数

日時データが午前か午後かを判別する関数が、`am`関数と`pm`関数です。共に論理型（`TRUE`・`FALSE`）を返す関数で、引数が午前なら`am`関数は`TRUE`、`pm`関数は`FALSE`を返します。

``` downlit
now() |> am()
## [1] TRUE

now() |> pm()
## [1] FALSE
```

### 21.13.4 interval

`lubridate`には、ある期間（interval）を評価するためのクラスとして、Intervalクラスが設定されています。このIntervalクラスのオブジェクトは`interval`関数に始めと最後の日時を与えることで作成できます。Intervalの期間の長さは`int_length`関数で、2つのIntervalクラスオブジェクトに重複があるかどうかは`int_overlaps`関数を用いて判別できます。

``` downlit
intr1 <-  interval(ymd("2023-10-20"), ymd("2023-10-30"))
intr2 <-  interval(ymd("2023-10-25"), ymd("2023-11-5"))

intr1 # 始めと最後の日が記録されている
## [1] 2023-10-20 UTC--2023-10-30 UTC

intr1 |> class() # データ型はInterval
## [1] "Interval"
## attr(,"package")
## [1] "lubridate"

int_length(intr1) # 期間の長さの単位は秒
## [1] 864000

int_overlaps(intr1, intr2) # 重複があればTRUEが返ってくる
## [1] TRUE
```

Carpenter, Bob, Andrew Gelman, Matthew D Hoffman, et al. 2017. “Stan: A Probabilistic Programming Language.” *Journal of Statistical Software* 76 (1).

Grolemund, Garrett, and Hadley Wickham. 2011. “Dates and Times Made Easy with lubridate.” *Journal of Statistical Software* 40 (3): 1–25. <https://www.jstatsoft.org/v40/i03/>.

Izrailev, Sergei. 2023. *Tictoc: Functions for Timing r Scripts, as Well as Implementations of "Stack" and "StackList" Structures*. <https://CRAN.R-project.org/package=tictoc>.

Back to top
