# 13  文字列

Code

多くのプログラミング言語では、**文字列（character）**の取り扱いが非常に重要視されます。住所や氏名は文字列ですし、電話番号も通常は数値というより文字列のような取り扱いを受けます。フォルダの位置（ディレクトリ）やウェブページ（html）なども文字列で構築されています。Rは統計の言語ですので、文字列には数値ほど色々な関数は実装されていませんが、Rにも基本的な文字列処理の関数は備わっています。現代では文字列を統計で取り扱う機会も増えていますので（[Word2Vec](https://ja.wikipedia.org/wiki/Word2vec)や生成AIなど）、文字列の取り扱いは統計においても重要性を増してきています。

## 13.1 文字列を取り扱う関数

### 13.1.1 文字列の結合：pasteとpaste0関数

Rには文字列を取り扱う関数が一通り備わっています。まずは`paste`関数について紹介します。`paste`関数は引数の文字列をつないで、1つの文字列にする関数です。各引数の文字列をつなぐ部分には、`sep`引数で指定した文字列が入ります。`paste`関数では、`sep`のデフォルトがスペースとなっているので、`sep`を設定しなければスペースが自動的に文字列の間に入ります。`paste0`関数では`sep`が空、つまり文字列のつなぎには何も入力されない形となります。

``` downlit
paste("A dog", "is running") # 引数同士をスペースを挟んでつなぐ
## [1] "A dog is running"

paste("A", "dog", "is", "running") # 引数は2つ以上でもよい
## [1] "A dog is running"

paste("A dog", "is running", sep="/") # sepに指定した文字が引数の間に入る
## [1] "A dog/is running"

paste0("A dog", "is running") # sepに何も追加したくない場合
## [1] "A dogis running"
```

### 13.1.2 sprintf関数

他のプログラミング言語と同様に、`sprintf`関数と呼ばれる、文字列に変数を挿入する関数をRでも用いることができます。`sprintf`関数は第一引数に文字列を取り、この文字列中の`"%s"`や`"%f"`の部分に第二引数で指定した変数を挿入する関数です。`"%s"`には文字列、`"%f"`には数値が入ります。第二引数以降の変数は挿入する順番に指定する必要があります。

``` downlit
sprintf("%f", pi)
## [1] "3.141593"

# .2fで小数点2桁まで表示
sprintf("%sは%.2fです。", "円周率", pi)
## [1] "円周率は3.14です。"

# 文字列の部分に数値、数値の部分に文字列が来るのでエラー
sprintf("%sは%.2fです。", pi, "円周率") 
## Error in `sprintf()`:
## ! invalid format '%.2f'; use format %s for character objects
```

### 13.1.3 文字数をカウントする：nchar

文字数をカウントする関数が`nchar`関数です。`nchar`関数は引数に取った文字列の文字数を返します。`type`引数を指定すると、文字列のバイト数や文字幅を求める事もできます。

``` downlit
nchar("Hello R") # スペースを含めて7文字
## [1] 7

x <- c("A dog is running", "A cat is running")
nchar(x) # ベクターの要素それぞれについて計算
## [1] 16 16

nchar("日本語") # 日本語でも文字数がカウントされる
## [1] 3

nchar("日本語", type="bytes") # バイト数は3倍
## [1] 9

nchar("日本語", type="width") # 等角文字は半角文字の2倍幅
## [1] 6
```

### 13.1.4 文字列から一部抜き出す：substr

文字列の一部を抜き出す関数が`substr`関数です。文字列のうち、`start`で指定した位置の文字から`stop`で指定した位置の文字までを返します。位置の指定はインデックスと同じで、1文字目が1、2文字目が2、という形を取ります。`substr`関数によく似た`substring`関数もほぼ同じ機能を持ちますが、引数名が`first`と`last`になっており、`last`のデフォルト値がとても大きく(1000000L) なっています。ですので、`first`だけを引数として指定し、それ以降の文字列を返す形で利用するものになっています。

``` downlit
x
## [1] "A dog is running" "A cat is running"

substr(x, start = 3, stop = 5) # xの3文字目から5文字目
## [1] "dog" "cat"

substring(x, 3) # 3文字目以降を取得
## [1] "dog is running" "cat is running"
```

### 13.1.5 文字列を分割する：strsplit

`strsplit`関数は、文字列をある特定の文字で分割し、リストの要素として返す関数です。区切りの文字は1文字でも、複数の文字でも問題ありません。

``` downlit
x
## [1] "A dog is running" "A cat is running"

strsplit(x, " ") # スペースで分離。リストが返ってくる
## [[1]]
## [1] "A"       "dog"     "is"      "running"
## 
## [[2]]
## [1] "A"       "cat"     "is"      "running"

strsplit(x, "i") # i で分離
## [[1]]
## [1] "A dog " "s runn" "ng"    
## 
## [[2]]
## [1] "A cat " "s runn" "ng"
```

### 13.1.6 パターンにあう位置を調べる：grepとmatch

文字列が一定のパターン（例えば英単語など）を含むかどうかを調べるのが、`grep`関数と`match`関数です。

`grep`関数は文字列のベクターに適用し、パターンを含むインデックスを返します。ベクターの要素がパターンを含まない場合には、長さ0のベクター（`integer(0)`）が返ってきます。

`match`関数は、パターンが全部一致する要素のインデックスを返す関数です。一部が一致する場合にはインデックスは返ってきません。どの要素にも全部一致するものがなければ、`NA`が返ってきます。パターンが部分一致する場合にインデックスを返すのが`pmatch`関数です。`pmatch`関数では、パターンが部分一致する要素が複数あると`NA`が返ってきます。

``` downlit
x
## [1] "A dog is running" "A cat is running"

grep(pattern = "dog", x)
## [1] 1

grep(pattern = "cat", x)
## [1] 2

grep(pattern = "is", x)
## [1] 1 2

grep(pattern = "rat", x)
## integer(0)


match("median",   c("mean", "median", "mode")) # 全文マッチするベクターの位置を返す
## [1] 2

match("med",   c("mean", "median", "mode")) # 一部マッチではNA
## [1] NA


pmatch("mo",   c("mean", "median", "mode")) # 一部マッチするベクターの位置を返す
## [1] 3

pmatch("me",   c("mean", "median", "mode")) # マッチするものが2つ以上あるとNA
## [1] NA
```

### 13.1.7 文字列の置き換え：subとgsub

文字列の中で、パターンが一致したものを別のパターンに置き換えるのが、`sub`関数、`gsub`関数です。`sub`関数、`gsub`関数は引数として、パターン（`pattern`）、置き換える文字列（`replacement`）、文字列のベクターを取ります。`sub`関数が文字列のうち、前からサーチして一番始めのパターンのみを置き換えるのに対して、`gsub`関数はパターンが一致した部分をすべて置き換えるものとなっています。`gsub`関数と同じような働きを持つ`chartr`関数というものもあります。

``` downlit
x
## [1] "A dog is running" "A cat is running"

sub(pattern = "n", replacement = "N", x) # 始めの要素だけ置き換え
## [1] "A dog is ruNning" "A cat is ruNning"

gsub(pattern = "n", replacement = "N", x) # すべて置き換え
## [1] "A dog is ruNNiNg" "A cat is ruNNiNg"

chartr("n", "N", x) # 上のgsub関数と同じ結果
## [1] "A dog is ruNNiNg" "A cat is ruNNiNg"
```

### 13.1.8 小文字、大文字に変換：tolower toupper

文字列を小文字に置き換えるのが`tolower`関数、大文字に置き換えるのが`toupper`関数です。

``` downlit
tolower("A CAT IS RUNNING") # 小文字に変換
## [1] "a cat is running"

x
## [1] "A dog is running" "A cat is running"

toupper(x) # 大文字に変換
## [1] "A DOG IS RUNNING" "A CAT IS RUNNING"
```

| 関数名 | 文字列xに適用される演算 |
|:---|:---|
| paste(x, y, sep = z) | xとyをzを挟んで結合 |
| paste0(x, y) | xとyを何も挟まず結合 |
| nchar(x) | xの文字数をカウントする |
| substr(x, start, stop) | xから文字を切り出す |
| substring(x, y) | xのy文字目以降を切り出す |
| strsplit(x, pattern) | xをpatternで分割する |
| grep(pattern, x) | patternを含むxのインデックスを返す |
| match(pattern, x) | pattern全文を含む要素のインデックスを返す |
| pmatch(pattern, x) | patternを一部含む要素のインデックスを返す |
| sub(x, pattern, replacement) | 始めに一致するpatternをreplacementに置き換える |
| gsub(x, pattern, replacement) | patternをreplacementにすべて置き換える |
| chartr(old, new, x) | oldをnewにすべて置き換える |
| tolower(x) | 大文字を小文字に変換 |
| toupper(x) | 小文字を大文字に変換 |

表1：Rの文字列に関する関数 {.caption-top .table .table-sm .table-striped .small}

## 13.2 stringr

Rのデフォルトの文字列関連の関数だけでも色々な文字列の操作ができますが、名前に統一感がなく、返ってくるものがリストだったりするものもあり、なかなか覚えにくく、使いにくいところがあります。

この使いにくさを解消し、統一感のある関数名を付けたパッケージが[`stringr`](https://stringr.tidyverse.org/)([Wickham 2023](#ref-stringr_bib))です。`stringr`には文字列を操作する関数が40程度登録されており、ほぼいずれの関数も「`str_`」から名前が始まります。Rstudioでは、「`str_`」と入力すると入力候補と入力候補の説明文が示されるため、比較的簡単に関数を検索し、利用することができます。文字列を取り扱う場合にRのデフォルトの関数群を用いても特に問題はありませんが、`stringr`の関数群を用いると返り値の利便性や速度に利点があります。

`stringr`は`tidyverse`に含まれるパッケージです。`stringr`のインストール、ロードには[`pacman::p_load`](https://rdrr.io/pkg/pacman/man/p_load.html)関数を用います。

``` downlit
pacman::p_load(tidyverse) # あらかじめpacmanのインストールが必要
```

以下に、`stringr`の代表的な関数の使い方を示します。

| 関数名 | 文字列xに適用される演算 |
|:---|:---|
| str_detect(x, pattern) | patternがあるとTRUEを返す |
| str_which(x, pattern) | patternを含むインデックスを返す |
| str_locate(x, pattern) | patternの位置を調べる |
| str_locate_all(x, pattern) | patternの位置をすべて調べる |
| str_count(x, pattern) | patternが含まれる数を返す |
| str_length(x) | 文字数を返す |
| str_trim(x) | xの前後のスペースを取り除く |
| str_trunc(x, width) | xをwidthの長さに省略する |
| str_sub(x, start, end) | startからendの位置までの文字列を取り出す |
| str_subset(x, pattern) | patternを含む要素を取り出す |
| str_extract(x, pattern) | patternを取り出す |
| str_extract_all(x, pattern) | patternをすべて取り出す |
| str_match(x, pattern) | patternを行列で取り出す |
| str_match_all(x, pattern) | patternを行列ですべて取り出す |
| str_c(x, y, sep) | xとyをsepを挟んで結合する |
| str_flatten(x, y, collapse) | xとyをcollapseを挟んで結合する |
| str_split(x, pattern) | xをpatternで分割する |
| str_split_fixed(x, pattern, n) | xをpatternでn個に分割する |
| str_split_i(x, pattern, i) | xをpatternで分割し、i番目の要素を返す |
| str_replace(x, pattern, replacement) | 始めに一致するpatternをreplacementに置き換える |
| str_replace_all(x, pattern, replacement) | patternをreplacementにすべて置き換える |
| str_to_lower(x) | 大文字を小文字に変換する |
| str_to_upper(x) | 小文字を大文字に変換する |

表2：stringrの関数 {.caption-top .table .table-sm .table-striped .small}

> **TIP:**
>
> `stringr`は[`stringi`](https://stringi.gagolewski.com/)([Gagolewski 2022](#ref-stringi_bib))というパッケージのラッパー（wrapper）です。ラッパーとは既存の関数の名前や引数の順序を統一したり、使用頻度の高い関数を選んだり、部分的に機能を追加することで利用しやすくしたものです。`stringi`はC言語由来の文字列処理を用いているため、Rのデフォルトの関数よりも計算が速いという特徴があります。

### 13.2.1 パターンの検出：str_detect

`str_detect`関数はパターンを検索し、論理型を返す関数です。パターンが含まれる要素には`TRUE`、含まれない要素には`FALSE`が返ってきます。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_detect(x, "dog")
## [1]  TRUE FALSE
```

### 13.2.2 パターンの検出：str_which

`str_which`関数は上記の`grep`関数と同じく、パターンに一致するベクターのインデックスを返す関数です。複数の要素が一致する場合には、一致するすべてのインデックスを返します。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_which(x, "dog")
## [1] 1

str_which(x, "cat")
## [1] 2

str_which(x, "is")
## [1] 1 2
```

### 13.2.3 パターンの位置を調べる：str_locate

もっと厳密に、そのパターンが存在する文字列上の位置を特定するための関数が`str_locate`関数です。`str_locate`関数は行列、もしくは行列のリストを返します。行列のstart列がパターンの開始位置、endが終了位置を示します。パターンが複数含まれる場合には、行列のリストが返ってきます。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_locate(x, "dog") # 1つ目の要素のみにパターンが含まれる時
##      start end
## [1,]     3   5
## [2,]    NA  NA

str_locate_all(x, "n") # 2つの要素にパターンが複数含まれる時
## [[1]]
##      start end
## [1,]    12  12
## [2,]    13  13
## [3,]    15  15
## 
## [[2]]
##      start end
## [1,]    12  12
## [2,]    13  13
## [3,]    15  15
```

### 13.2.4 パターンが含まれる数を数える：str_count

パターンが何回含まれるかを数える関数が`str_count`関数です。パターンが含まれていればそのパターンの個数を、含まれていなければ0を返します。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_count(x, "dog") # 1つ目の要素に1つだけパターンが含まれる場合
## [1] 1 0

str_count(x, "n") # 2つの要素に3つずつパターンが含まれる場合
## [1] 3 3
```

### 13.2.5 文字数を数える：str_length

`str_length`関数は`nchar`関数と同じく、文字数を返す関数です。どちらを使っても結果は同じですが、他の言語では文字数を数える関数に「`length`」関数を当てることが多いため、`str_length`の方が直感的に使い方がわかりやすい名前になっています。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_length(x)
## [1] 16 16

nchar(x)
## [1] 16 16
```

### 13.2.6 文字列を整える：str_trim、str_trunc

`str_trim`関数は文字列の前と後ろのスペースを取り除く関数です。文字列の演算では、スペースが前後に残って邪魔になることがよくあります。このような場合には`str_trim`でスペースを取り除き、形を整えることができます。

`str_trunc`関数は、文字列の前や後ろを切り取り、「…」で置き換えて省略してくれる関数です。長い文字列をラベル等に用いるときに使用します。

``` downlit
str_trim(" x ") # スペースを取り除く
## [1] "x"

x
## [1] "A dog is running" "A cat is running"

str_trunc(x, 12) # 後ろを切り取って...で省略
## [1] "A dog is ..." "A cat is ..."

str_trunc(x, 12, side="left") # 前を切り取って...で省略
## [1] "...s running" "...s running"
```

### 13.2.7 文字を切り出す：str_subとstr_subset

`str_sub`関数は`substr`関数とほぼ同じ働きを持つ関数で、`start`の位置から`end`の位置までの文字列を抜き出します。

`str_subset`関数はやや異なり、パターンを含むベクターの要素のみを取り出す関数です。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_sub(x, start=3, end=5) # 位置を特定して抽出
## [1] "dog" "cat"

str_subset(x, "cat") # 文字を含む要素を抽出
## [1] "A cat is running"

str_subset(x, "is")
## [1] "A dog is running" "A cat is running"

str_subset(x, "rat")
## character(0)
```

### 13.2.8 文字列を抽出する：str_extract

`str_extract`関数は、パターンがマッチしたときに、そのパターンを返す関数です。パターンに一致する部分がない場合には、`NA`を返します。`str_extract`関数はマッチした始めのパターンのみを返し、`str_extract_all`関数はマッチしたパターンをすべて返します。`str_extract_all`関数の返り値はリストになります。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_extract(x, "is") # 特定の文字列を抽出
## [1] "is" "is"

str_extract(x, "dog") # 抽出できないとNAを返す
## [1] "dog" NA

str_extract_all(x, "n") # パターン一致するものをすべて抽出
## [[1]]
## [1] "n" "n" "n"
## 
## [[2]]
## [1] "n" "n" "n"
```

### 13.2.9 パターンマッチング：str_match

`str_match`関数も一致したパターンを返す関数です。`str_match`関数は始めにマッチしたパターンを行列で返し、`str_match_all`関数はマッチしたすべてのパターンを行列のリストで返します。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_match(x, "dog") # パターンがあれば、そのパターンを返す
##      [,1] 
## [1,] "dog"
## [2,] NA

str_match_all(x, "n") # パターンがあれば、それをすべて返す
## [[1]]
##      [,1]
## [1,] "n" 
## [2,] "n" 
## [3,] "n" 
## 
## [[2]]
##      [,1]
## [1,] "n" 
## [2,] "n" 
## [3,] "n"
```

### 13.2.10 文字列をつなぐ：str_cとstr_flatten

`str_c`関数と`str_flatten`関数はいずれも文字列をつなぐ関数です。ともに`paste`関数と`paste0`関数とほぼ同じですが、`str_flatten`は`paste`関数に引数`collapse=""`を指定した場合と同じ結果を返します。

また、 `NA`の取り扱いが少しだけ異なり、`paste`関数が`NA`を文字列としてつないでしまうのに対して、`str_c`関数は文字列を繋がずに`NA`を返します。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_c(x[1], x[2]) # paste0と同じ
## [1] "A dog is runningA cat is running"

str_c(x[1], x[2], sep=" ") # pasteと同じ
## [1] "A dog is running A cat is running"

str_c(c("a", "dog", "is", "running")) # paste0と同じだが、ベクターの要素はつながない
## [1] "a"       "dog"     "is"      "running"

str_flatten(c("a", "dog", "is", "running")) # paste(collapse="")と同じ
## [1] "adogisrunning"

str_flatten(c("a", "dog", "is", "running"), collapse= " ") # paste(collapse=" ")と同じ
## [1] "a dog is running"

paste("A", NA)
## [1] "A NA"

str_c("A", NA)
## [1] NA
```

### 13.2.11 文字列を分割する：str_split、str_split_fixed、str_split_i

`str_split`関数はパターンで文字列を分割する関数で、`strsplit`関数とほぼ同じ機能を持ちます。

`str_split_fixed`関数はパターンで分割するときに、分割後の要素の数を指定することができる関数です。

`str_split_i`関数は、パターンで分割した後に、数値で指定したインデックスの要素のみを取り出す関数です。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_split(x, " ") # パターンで分割
## [[1]]
## [1] "A"       "dog"     "is"      "running"
## 
## [[2]]
## [1] "A"       "cat"     "is"      "running"

str_split_fixed(x, " ", 2) # 始めのパターンで2つに分割
##      [,1] [,2]            
## [1,] "A"  "dog is running"
## [2,] "A"  "cat is running"

str_split_i(x, " ", 2) # パターンで分割し、2つ目の要素を取り出す
## [1] "dog" "cat"
```

### 13.2.12 文字列を置き換える：str_replace、str_replace_all

`str_replace`関数は文字列のパターンを別の文字列に置き換える関数です。`sub`関数とほぼ同等の機能を持ちます。`str_replace_all`関数は`gsub`関数とほぼ同じで、`str_replace`関数が始めにマッチしたパターンのみを置き換えるのに対し、`str_replace_all`関数はマッチしたパターンをすべて置き換えます。

``` downlit
x
## [1] "A dog is running" "A cat is running"

str_replace(x, "running", "walking") # 前のパターンを後ろの文字列に置き換える
## [1] "A dog is walking" "A cat is walking"

str_replace_all(x, " ", ",") # 前のパターンをすべて、後ろの文字列に置き換える
## [1] "A,dog,is,running" "A,cat,is,running"
```

### 13.2.13 大文字・小文字の操作：str_to_lower、str_to_upper

`str_to_lower`関数は大文字を小文字に、`str_to_upper`関数は小文字を大文字に変換する関数です。どちらも`tolower`関数、`toupper`関数とほぼ同等の機能を持ちます。`str_to_lower`、`str_to_upper`関数は言語による小文字・大文字の違いによる変換にも対応していますが、日本人がこの機能を使うことはほぼ無いでしょう。

``` downlit
str_to_lower("A DOG IS RUNNING")
## [1] "a dog is running"

x
## [1] "A dog is running" "A cat is running"

str_to_upper(x)
## [1] "A DOG IS RUNNING" "A CAT IS RUNNING"
```

## 13.3 正規表現

文字列中に含まれる特定の文字や単語を取り出す・検出する際に、1つの文字や単語だけでなく、条件に適合した複数の文字列を対象としたい場合もあります。また、文字列の特定の並び（`"would"`, `"like"`, `"to"`が順番に並んでいるなど）のみを特定し、検出したいといった場合もあるでしょう。このような場合に文字列のマッチングに用いられるものが、**正規表現**です。正規表現では、文字列と記号を合わせて複雑な文字列のパターンを特定し、マッチングを行うことができます。

Rで用いることができる正規表現には、Rを含めて汎用されている規格（POSIX 1003.2 standard）のものと、Perl言語で用いられる正規表現の主に2つがあります。ここでは前者のみについて簡単に説明します。

Rで用いることができる正規表現の例を以下の表3に示します。

| 正規表現     | 意味                                   |
|:-------------|:---------------------------------------|
| \a           | ビープ音（BEL）                        |
| \e           | エスケープ（ESC）                      |
| \f           | フォームフィード（FF，書式送り）       |
| \n           | ラインフィード（LF，改行）             |
| \r           | キャリッジリターン（CR，改行）         |
| \t           | タブ（TAB）                            |
| \w           | すべての英数字（アルファベット＋数値） |
| \W           | すべての英数字を含まない               |
| \\，\\       | 文書の端の空欄（\<が始め，\>が終わり） |
| \b           | 文書の端の空欄                         |
| \B           | 文書中の空欄（端を除く）               |
| \[abc\]      | a，b，cを含む                          |
| \[^abc\]     | a，b，cを含まない                      |
| \[0-9\]      | 0～9の数字                             |
| \[:digit:\]⁠  | 数字                                   |
| \[:xdigit:\]⁠ | 16進数の数字（1_(9，A)F）              |
| \[A-Z\]      | A～Zの大文字アルファベット             |
| \[a-z\]      | a～zの小文字アルファベット             |
| \[:alnum:\]⁠  | すべての英数字（アルファベット＋数値） |
| ⁠\[:alpha:\]  | すべてのアルファベット                 |
| ⁠\[:lower:\]⁠  | すべての小文字アルファベット           |
| ⁠\[:upper:\]⁠  | すべての大文字アルファベット           |
| \[:blank:\]⁠  | スペースもしくはタブ                   |
| \[:space:\]  | スペース文字（FFやCRを含む）           |
| \[:graph:\]⁠  | 表示可能な文字（図形文字）             |
| ⁠\[:print:\]⁠  | 表示可能な文字（スペース含む）         |
| \[:punct:\]⁠  | 句読点など                             |
| \[:cntrl:\]⁠  | 制御文字                               |
| ?a           | aが0～1回マッチする                    |
| \*a          | aが0回以上マッチする                   |
| +a           | aが1回以上マッチする                   |
| {5}a         | aaaaaがマッチする                      |
| {5,}a        | aaaaaよりaが続く文字列がマッチする     |
| {2,4}a       | aa，aaa，aaaaのいずれかがマッチする    |
| (abc\|def)   | abcかdefのどちらかにマッチする         |
| \[あ-ん\]    | すべてのひらがな                       |
| \[ア-ン\]    | すべてのカタカナ                       |

表3：Rの正規表現の一覧 {.caption-top .table .table-sm .table-striped .small}

### 13.3.1 関数での正規表現の利用

正規表現はこの章で述べたR言語の文字列を対象とする関数や、`stringr`の関数でパターンとして指定し、用いることができます。以下は`grep`関数の`pattern`引数に正規表現を指定した場合の例です。正規表現を用いることで、例えばhtmlのアドレスやe-mailのアドレスとして正しい記載であるかなど、複雑な文字列のパターンでも検出し、評価することができます。

``` downlit
v <- c("dog", "cat", "pig", "rat", "egg")
grep("[abc]", v, value=TRUE) # abcのいずれかを含む
## [1] "cat" "rat"

grep("[^crat]", v, value=TRUE) # crat以外を含む
## [1] "dog" "pig" "egg"

grep("^c", v, value=TRUE) # cから始まる
## [1] "cat"

grep("[(o|g)][(p|g)]", v, value=TRUE) # op、og、gp、ggのいずれかを含む
## [1] "dog" "egg"

grep("g{2}", v, value=TRUE) # ggを含む
## [1] "egg"
```

### 13.3.2 rexパッケージ

とは言っても、正規表現をまるまる覚えるのは大変ですし、いちいち検索して正規表現でパターンを表現するのも場合によってはかなり大変です。[`rex`](https://rex.r-lib.org/index.html)パッケージ([Ushey et al. 2021](#ref-rex_bib))はこのような複雑な正規表現を人にも理解しやすい形で作成できるようにするためのパッケージです。よく用いられる正規表現は`shortcuts`というオブジェクト（リストと同じように取り扱えます）に含まれていますし、`rex`関数を用いてより複雑な正規表現を作成することもできます。

``` downlit
pacman::p_load(rex)

shortcuts$letter # アルファベット
## [:alpha:]

shortcuts$non_puncts # 句読点以外
## [^[:punct:]]+

rex(none_of("a", "e", "i", "o", "u")) # aeiou以外
## [^aeiou]
```

Gagolewski, Marek. 2022. “stringi: Fast and Portable Character String Processing in R.” *Journal of Statistical Software* 103 (2): 1–59. <https://doi.org/10.18637/jss.v103.i02>.

Ushey, Kevin, Jim Hester, and Robert Krzyzanowski. 2021. *Rex: Friendly Regular Expressions*. <https://CRAN.R-project.org/package=rex>.

Wickham, Hadley. 2023. *Stringr: Simple, Consistent Wrappers for Common String Operations*. <https://CRAN.R-project.org/package=stringr>.

Back to top
