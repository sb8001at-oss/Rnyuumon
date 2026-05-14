# 11  エラー処理（error handler）

Code

Rでプログラミングを行うと、大抵の場合**エラー**が発生します。プログラミングにエラーはつきものです。プログラミングの途中でエラーが起こっても、それが本当に重大な影響を及ぼすことはほとんどありません。

Rは基本的にad hocな（その場一度限りの）統計処理に用いることを前提としているようなところがあるため、エラーが出たらスクリプトを書き換えて、もう一回実行すればよい、という場合がほとんどです。

しかし、通常のプログラミング言語と同様に、エラーが出たら困る、エラーが出た場合は特殊な処理をしたい、という場合もあります。このような場合に用いられるものが、**エラー処理（error handler）**です。

> **TIP:**
>
> PythonやRubyなどの汎用プログラミング言語ではエラー処理は非常に重要ですが、Rではそれほど使用頻度は高くありません。エラー処理を今すぐ使いたいという方以外は、この章を飛ばしても問題ありません。

## 11.1 エラーメッセージの分類

Rではエラーメッセージとして3種類の警告が出る仕組みを持っています。3種類とは、**message、warning、error**の3つです。**message**はプログラムを実行しても特に問題はないが、特別に伝えたいことがある場合に、**warning**はプログラムを実行したときに、問題が起こっている可能性が高い場合に、**error**は実行できない場合にそれぞれ表示されます。

これらのうち、messageはプログラムの実行に影響を与えません。warningはプログラムを実行したときに問題が起こることがあります。errorが起こるとプログラムの実行が止まります。ですので、エラーとして処理が必要となるのは、主にwarningとerrorです。

``` downlit
# messageが出る場合
readr::read_tsv("iris.txt")
## Rows: 150 Columns: 5
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: "\t"
## chr (1): Species
## dbl (4): Sepal.Length, Sepal.Width, Petal.Length, Petal.Width
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <chr>  
##  1          5.1         3.5          1.4         0.2 setosa 
##  2          4.9         3            1.4         0.2 setosa 
##  3          4.7         3.2          1.3         0.2 setosa 
##  4          4.6         3.1          1.5         0.2 setosa 
##  5          5           3.6          1.4         0.2 setosa 
##  6          5.4         3.9          1.7         0.4 setosa 
##  7          4.6         3.4          1.4         0.3 setosa 
##  8          5           3.4          1.5         0.2 setosa 
##  9          4.4         2.9          1.4         0.2 setosa 
## 10          4.9         3.1          1.5         0.1 setosa 
## # ℹ 140 more rows

# warning（警告）が出る場合
tibble::as.tibble(iris[1,])
## Warning: `as.tibble()` was deprecated in tibble 2.0.0.
## ℹ Please use `as_tibble()` instead.
## ℹ The signature and semantics have changed, see `?as_tibble`.
## # A tibble: 1 × 5
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##          <dbl>       <dbl>        <dbl>       <dbl> <fct>  
## 1          5.1         3.5          1.4         0.2 setosa

# error（エラー）が出る場合
100 + dog
## Error:
## ! object 'dog' not found
```

## 11.2 エラーメッセージ・エラーを表示させる

自分が作ったプログラムや関数を他人が使う場合には、計算に問題があるときにはエラーメッセージを出す処理を加える時があります。また、errorやwarningが起きたときには特別な処理を行いたいこともあります。このような場合のために、Rにはエラーを表示させるための関数があります。message、warning、errorを表示させるための関数は、それぞれ`message`関数、`warning`関数、`stop`関数です。`stop`関数ではその名の通り、エラーが表示され、プログラムの実行が止まります。エラーは`stopifnot`関数でも表示させることができます。`stopifnot`関数は引数に条件式を取り、**条件式が`FALSE`のとき**にエラーを表示します。

``` downlit
message("これはメッセージです。実行に問題はありません")
## これはメッセージです。実行に問題はありません

warning("これはwarning（警告）です。実行に問題があるかもしれません")
## Warning: これはwarning（警告）です。実行に問題があるかもしれません

stop("これはerrorです。実行を止めます。")
## Error:
## ! これはerrorです。実行を止めます。

stopifnot(FALSE) # 条件がFALSEだとエラーが出る
## Error:
## ! FALSE is not TRUE

stopifnot("エラーメッセージはこのように設定する" = FALSE) # =の後に条件式を書く
## Error:
## ! エラーメッセージはこのように設定する
```

## 11.3 tryとtryCatch

Rでのエラー処理には、`try`関数と`tryCatch`関数の2つが用いられます。`try`関数はエラーが出る処理を行った場合に、プログラムを止めずにエラーを返す機能を持ちます。`tryCatch`関数はエラーが出る処理に対応して別の処理を行う際に用います。

`try`関数は第一引数を評価し、エラーならエラーを表示し、続けてプログラムを実行します。下の`for`文では、どちらも`"dog"`に数値を足す計算でエラーが出ます。`try`がない場合にはエラーが出た時点でプログラムが停止しますが、`try`関数の引数にエラーが出る処理がある場合にはエラーが出た後にも計算が継続します。`try`は返り値として第一引数の演算結果を返しますが、エラーが出た場合にはtry-errorクラスのオブジェクトを返します。

``` downlit
d <- data.frame(a=1, b=2, c="dog", d=4, e=5)
d # 1行5列のデータフレーム
##   a b   c d e
## 1 1 2 dog 4 5

for(i in 1:5){ # エラーが出るので、評価が中断する
  print(d[1,i] + 1)
}
## [1] 2
## [1] 3
## Error in `d[1, i] + 1`:
## ! non-numeric argument to binary operator

for(i in 1:5){ # エラーが出ても、評価は継続する
  try(print(d[1,i] + 1))
}
## [1] 2
## [1] 3
## Error in d[1, i] + 1 : non-numeric argument to binary operator
## [1] 5
## [1] 6

err_ <- try(1+"dog") # エラーが出たとき
## Error in 1 + "dog" : non-numeric argument to binary operator

class(err_) # エラーのクラス（try-error）を返す
## [1] "try-error"

warning_ <- try(as.numeric("dog")) # warningが出たとき
## Warning in doTryCatch(return(expr), name, parentenv, handler): NAs introduced
## by coercion

warning_ # 演算はできるので、演算結果（NA）が返ってくる
## [1] NA

class(warning_) # クラスはnumeric
## [1] "numeric"
```

> **TIP:**
>
> （`try(as.numeric("dog")`) の結果）のクラスがnumericになっています。NAは内部的にはNA_integer\_（整数のNA）、NA_real\_（実数のNA）、NA_complex\_（複素数のNA）、NA_character\_（文字列のNA）の4種類として扱われており、上記の場合ではNA_real\_、つまり実数タイプのNAが返ってきています。このようにNAには型が複数あるため、ベクター中にNAが埋め込まれていても、ベクター全体の型が変化することはありません。

`try`関数では、エラーが出たときにはtry-errorクラスが返ってくるので、try-errorクラスであることを利用してエラー時に行う処理を設定することができます。また、引数に「`silent = TRUE`」を取ると、エラーメッセージが表示されなくなります。

``` downlit
# tryの結果のクラスがtry-errorなら、文字列を返すif文
if(class(try(1+"dog"))=="try-error"){"エラーが起きています。"}
## Error in 1 + "dog" : non-numeric argument to binary operator
## [1] "エラーが起きています。"

try(1+"dog", silent=T) # 何も表示されない
```

`try`関数でもエラー処理はできますが、通常エラー処理で用いられるのは**`tryCatch`**関数です。`tryCatch`関数では、`error`が起きたときの処理、`warning`が起きたときの処理、最終的に行う処理（`finally`）をそれぞれ設定できます。この時、`error`、`warning`の処理は**関数**で、`finally`は**そのまま**書きます。`warning`や`error`に用いる関数は別途作成しておくこともできますが、下のように`tryCatch`関数内で関数として定義する形でも書くこともできます。

``` downlit
errorCatcher <- function(x){ # 対数計算のエラーを捉える関数
  tryCatch(
    log(x), # 対数計算を評価する
    warning = \(w){"警告あり"}, # warningが出たときの処理
    error = \(e){"エラーあり"}, # errorが出たときの処理
    finally = print("エラーがあってもなくても表示される") # エラーの有無に関わらず行う処理
  )
}

errorCatcher(0) # エラーなし
## [1] "エラーがあってもなくても表示される"
## [1] -Inf
errorCatcher(-1) # warning
## [1] "エラーがあってもなくても表示される"
## [1] "警告あり"
errorCatcher("dog") # error
## [1] "エラーがあってもなくても表示される"
## [1] "エラーあり"
```

> **TIP:**
>
> warningやerrorで記載している関数（`\(e)`や`\(w)`）は名前を決めずに用いる関数で、無名関数と呼ばれるものです。用途によってはこのような無名関数を用いて処理を書くことがあります。

Back to top
