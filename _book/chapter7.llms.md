# 7  型・クラスの確認と変換

Code

## 7.1 型・クラスの確認：is.関数群

Rでは、型やクラスを確認するための関数として、`typeof`関数・`mode`関数・`class`関数以外に、`is.`関数というものを備えています。`is.`関数を用いると、オブジェクトの型が、ある型と一致しているかどうかを確認することができます。引数が数値であるかどうかは、`is.numeric`関数、`is.integer`関数、`is.double`関数を用いて確認することができます。例えば**`is.numeric(1)`は`TRUE`**を返し、**`is.numeric("dog")`は`FALSE`**を返します。この`is.`関数には、文字列や`NA`、`NaN`等を確認する関数もあります。`is.`関数を以下の表1に示します。

| is.関数名        | チェックする型 |
|:-----------------|:---------------|
| is.numeric(x)    | 数値型         |
| is.integer(x)    | 整数型         |
| is.double(x)     | double型       |
| is.complex       | 複素数型       |
| is.character(x)  | 文字列型       |
| is.logical(x)    | 真偽型         |
| is.factor(x)     | 因子型         |
| is.atomic(x)     | ベクター       |
| is.list(x)       | リスト         |
| is.matrix(x)     | マトリックス   |
| is.data.frame(x) | データフレーム |
| is.na(x)         | NA             |
| is.nan(x)        | NaN            |
| is.null(x)       | NULL           |
| is.infinite(x)   | 無限大         |

表1：xの型の確認に用いる関数 {.caption-top .table .table-sm .table-striped .small}

`is.`関数の中では、`is.na`関数の使用頻度が高いです。`is.na`関数を用いると、ベクターやデータフレームからNAを含む要素をうまく取り除くことができます。

``` downlit
c(is.numeric(1), is.numeric("1")) # 文字列（"1"）は数値ではない
## [1]  TRUE FALSE

c(is.integer(1L), is.integer(1)) # Lが付いていないとdoubleになる
## [1]  TRUE FALSE

c(is.double(1), is.double(1L)) # Lが付いているとintegerになる
## [1]  TRUE FALSE

c(is.complex(1+1i), is.complex(1+1)) # iがあると複素数になる
## [1]  TRUE FALSE

c(is.character("dog"), is.character(1)) # 数値は文字列ではない
## [1]  TRUE FALSE

# 0はFALSE扱いされるが、logicalではない
c(is.logical(T), is.logical(0), is.logical("dog")) 
## [1]  TRUE FALSE FALSE

c(is.factor(factor(1)), is.factor(1))
## [1]  TRUE FALSE

c(is.atomic(1), is.atomic(list(1))) # ベクターはTRUE、リストはFALSE
## [1]  TRUE FALSE

c(is.vector(1), is.vector(list(1))) # is.vectorもあるが、リストもTRUEになる
## [1] TRUE TRUE

c(is.list(list(1)), is.list(1))# ベクターはFALSE、リストはTRUE
## [1]  TRUE FALSE

c(is.matrix(matrix(1, ncol=1)), is.matrix(1))
## [1]  TRUE FALSE

c(is.data.frame(data.frame(1)), is.data.frame(list(1))) # リストはFALSE
## [1]  TRUE FALSE

# NAとNaNはNA扱い、NULLは無いもの扱い
c(is.na(NA), is.na(1), is.na(NaN), is.na(Inf), is.na(NULL)) 
## [1]  TRUE FALSE  TRUE FALSE

# NULLは無いもの扱い
c(is.nan(NA), is.nan(1), is.nan(NaN), is.nan(Inf), is.nan(NULL))
## [1] FALSE FALSE  TRUE FALSE

# NULLを評価する
c(is.null(NA), is.null(1), is.null(NaN), is.null(Inf), is.null(NULL)) 
## [1] FALSE FALSE FALSE FALSE  TRUE

# NULLは無いもの扱い
c(is.infinite(NA), is.infinite(1), is.infinite(NaN), is.infinite(Inf), is.infinite(NULL)) 
## [1] FALSE FALSE FALSE  TRUE
```

> **TIP:**
>
> ベクターは`is.atomic`関数で評価します。これは、ベクターのことをatomic vectorと呼ぶためです。atomic vectorはvectorと同じ意味を持ちます。エラーやメッセージには時々このatomic vectorという表記が出てきますが、これは通常のベクターのことを述べているだけで、atomic vectorという特別なものがあるわけではありません。

## 7.2 型・クラスの変換：as.関数群

`is.`関数はデータのクラスや型をチェックし、論理型を返す関数です。Rには、関数名がよく似た`as.`関数があります。`as.`関数は、引数の型を指定した型に変換する関数です。例えば、`as.numeric`関数は引数をnumericに変換する関数です。`as.`関数の一覧を以下の表2に示します。

| as.関数名        | 変換する型           |
|:-----------------|:---------------------|
| as.numeric(x)    | 数値型に変換         |
| as.integer(x)    | 整数型に変換         |
| as.double(x)     | double型に変換       |
| as.complex       | 複素数型に変換       |
| as.character(x)  | 文字列型に変換       |
| as.logical(x)    | 真偽型に変換         |
| as.factor(x)     | 因子型に変換         |
| as.Date          | 日時型に変換         |
| as.POSIXct       | POSIXct型に変換      |
| as.POSIXlt       | POSIXlt型に変換      |
| as.list(x)       | リストに変換         |
| as.matrix(x)     | マトリックスに変換   |
| as.data.frame(x) | データフレームに変換 |
| as.null(x)       | NULLに変換           |

表2：xの型の変換に用いる関数 {.caption-top .table .table-sm .table-striped .small}

``` downlit
as.numeric(TRUE)
## [1] 1

as.integer(1.1)
## [1] 1

as.double(1L)
## [1] 1

as.complex(1)
## [1] 1+0i

as.character(1)
## [1] "1"

c(as.logical(1), as.logical(0))
## [1]  TRUE FALSE

as.factor(c("dog", "cat"))
## [1] dog cat
## Levels: cat dog

as.Date("2022-02-22") # わかりにくいが、日付型になっている
## [1] "2022-02-22"

# わかりにくいが、日時型になっている
as.POSIXct("2022-02-22 15:00:00")
## [1] "2022-02-22 15:00:00 +09"

as.POSIXlt("2022-02-22 15:00:00")
## [1] "2022-02-22 15:00:00 +09"

as.list(1)
## [[1]]
## [1] 1

as.data.frame(list(1, 1))
##   X1 X1.1
## 1  1    1

as.matrix(data.frame(x=1, y=1))
##      x y
## [1,] 1 1

as.null(1)
## NULL
```

Back to top
