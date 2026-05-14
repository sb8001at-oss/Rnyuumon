# 14  因子（factor）

Code

**因子**はほぼRにのみ存在する特徴的なクラスです。因子は**カテゴリカル変数**（男性と女性、病気の有無など）を表現するためのもので、統計解析において重要な役割を果たします。ただし、因子の挙動はやや複雑で、文字列のつもりが因子だった、因子だと思っていたら文字列だった、などという場合が多々発生します。

因子を作るときには、`factor`関数を用います。引数には文字列や数値のベクターを取ります。また、`gl`関数を用いても因子を作成することができます。

``` downlit
x <- c("dog", "cat", "pig", "horse")
factor(x)
## [1] dog   cat   pig   horse
## Levels: cat dog horse pig

gl(2, 8, labels=c("A", "B")) # AとBを８回ずつ繰り返す因子
##  [1] A A A A A A A A B B B B B B B B
## Levels: A B

# 4つのラベルを1回ずつ16個まで繰り返す因子
gl(4, 1, 16, labels=c("cat", "dog", "pig", "rat")) 
##  [1] cat dog pig rat cat dog pig rat cat dog pig rat cat dog pig rat
## Levels: cat dog pig rat
```

因子と文字列を表示したときの違いは、

- 表示したときにダブルクオーテーションがあるかどうか（あれば文字列、なければ因子）
- 表示したときにLevelsが表示されるか（表示されなければ文字列、表示されれば因子）

の2点です。文字列なのか因子なのかわからないときには、コンソールに表示してみるとよいでしょう。

``` downlit
x <- rep(x, c(5, 4, 3, 2))
x # これは文字列のベクター（ダブルクオーテーション付き）
##  [1] "dog"   "dog"   "dog"   "dog"   "dog"   "cat"   "cat"   "cat"   "cat"  
## [10] "pig"   "pig"   "pig"   "horse" "horse"

fx <- factor(x)
fx # こちらは因子のベクター（Levelsを表示）
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: cat dog horse pig
```

## 14.1 因子のレベル（Levels）

因子には**レベル（Levels）**というアトリビュートが存在します。レベルは、因子の種類と順番を指すアトリビュートです。文字列を因子に変えた場合には、アルファベット順にレベルが付与され、数値を因子に変えた場合には、数値の小さいものからレベルが付与されます。レベルの順序は、**グラフや統計結果の表示の順番**に影響を与えます。

因子のレベルを確認する関数には、`nlevels`関数と`levels`関数の2つが存在します。`nlevels`関数は因子のレベルの数を返す関数です。`levels`関数は因子のレベルをそのレベルの順番にそって返します。

``` downlit
nlevels(fx)
## [1] 4

levels(fx) # levelsはアルファベット順になる
## [1] "cat"   "dog"   "horse" "pig"

x2 <- c(4, 3, 2, 1)
fx2 <- factor(x2)
levels(fx2) # levelsは数値順になる
## [1] "1" "2" "3" "4"
```

## 14.2 因子のクラスと型

因子の**クラスはfactor、型はnumeric（integer）**です。つまり、**因子は整数にレベルがラベル付けされているクラス**となります。

``` downlit
class(fx)
## [1] "factor"
mode(fx)
## [1] "numeric"
typeof(fx)
## [1] "integer"

# 文字列から作った因子もnumericとなる
fch <- c("dog", "cat")
fch <- factor(fch)
mode(fch)
## [1] "numeric"
```

因子はそもそも型が数値ですので、`as.numeric`関数で数値に変換できます。このときの数値はレベルの順番に1、2、3…となります。また、因子を`as.character`関数を用いて文字列に変換することもできます。文字列に変換した場合には、レベルの名前がそのまま出力されます。

また、ベクターには、名前（names）というアトリビュートがあるのですが、因子のレベルはこの名前とは異なります。因子のベクターにも名前は別途つけることができますが、過剰に複雑になるので避けた方が良いでしょう。

``` downlit
fx
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: cat dog horse pig

as.numeric(fx) # levelsの順に番号が付く
##  [1] 2 2 2 2 2 1 1 1 1 4 4 4 3 3

as.character(fx) # 文字列には直接変換できる
##  [1] "dog"   "dog"   "dog"   "dog"   "dog"   "cat"   "cat"   "cat"   "cat"  
## [10] "pig"   "pig"   "pig"   "horse" "horse"

# factorの文字はnamesとしては設定されていない（levelsはnamesではない）
names(fx) 
## NULL

fx1 <- fx
names(fx1) <- rep(c("rat", "mouse", "sheep", "monkey"), c(2, 3, 4, 5))
fx1 # 名前付きベクターの因子
##    rat    rat  mouse  mouse  mouse  sheep  sheep  sheep  sheep monkey monkey 
##    dog    dog    dog    dog    dog    cat    cat    cat    cat    pig    pig 
## monkey monkey monkey 
##    pig  horse  horse 
## Levels: cat dog horse pig
```

因子の各レベルの要素の個数を数える場合には、`table`関数を用います。`table`関数を用いると、各レベルと、そのレベルの要素の数が返ってきます。`table`関数は複数の因子や、因子のリスト、データフレームなどを引数に取ることもできます。同様に、`summary`関数でも要素の数を数えることができます。

``` downlit
table(fx)
## fx
##   cat   dog horse   pig 
##     4     5     2     3

factor1 <- factor(rep(c("cat", "dog"), 10))
factor2 <- factor(rep(c("male", "female"), c(7, 13)))

# table関数は因子のベクターを2つ取ることもできる
table(factor1, factor2)
##        factor2
## factor1 female male
##     cat      6    4
##     dog      7    3

# summary関数でもレベルの要素の数を得ることができる
summary(fx)
##   cat   dog horse   pig 
##     4     5     2     3
```

## 14.3 レベルの順序を変更する

レベルの順序は、因子を作成するときに`factor`関数の引数に`levels`を指定することで変更できます。`levels`には因子の要素のベクターで指定します。この`levels`に指定した順番に、レベルの順序が決まります。

``` downlit
fx
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: cat dog horse pig
fx2 <- factor(fx, levels = c("cat", "horse", "pig", "dog"))

levels(fx) # レベル順はcat, dog, horse, pig
## [1] "cat"   "dog"   "horse" "pig"

levels(fx2) # レベルの順序が上のlevelsの順に変更されている
## [1] "cat"   "horse" "pig"   "dog"

as.numeric(fx) # 元の順序
##  [1] 2 2 2 2 2 1 1 1 1 4 4 4 3 3

as.numeric(fx2) # 変更後の順序
##  [1] 4 4 4 4 4 1 1 1 1 3 3 3 2 2
```

| 関数名            | 因子xに適用される演算                |
|:------------------|:-------------------------------------|
| factor(x, levels) | 因子を作成する・レベルの順序を変える |
| levels(x)         | レベルを表示する                     |
| nlevels(x)        | レベルの数を表示する                 |
| table(x)          | 各レベルの要素数を表示する           |

表1：因子に関連する関数 {.caption-top .table .table-sm .table-striped .small}

## 14.4 forcats

Rでは因子のレベル順を変更し、グラフや統計結果の表示順を定める場合があります。特に統計学的検定の計算では、対照群（Control）と処理群（Treatment）が因子の順番によって決まる場合があり、因子の順序が計算上重要となります。

デフォルトのRの関数群でも因子の順序などを編集することはできますが、因子の演算を行う専門のパッケージである`forcats` ([Wickham 2023](#ref-forcats_bib))を用いると、より簡潔に、統一感のある因子の演算を行うことができます。`forcats`も`tidyverse` ([Wickham et al. 2019](#ref-tidyverse_bib))に含まれるパッケージの一つです。

| 関数名 | 因子xに適用される演算 |
|:---|:---|
| fct_count(x) | 各レベルの要素の数を返す |
| fct_match(x, pattern) | patternのレベルであればTRUEを返す |
| fct_unique(x) | 各レベルから要素を1つずつ返す |
| fct_c(x, y) | 因子を結合する |
| fct_unify(list(x, y)) | リスト内の因子間でレベルを追加する |
| fct_relevel(x, levels) | レベルを付け直す |
| fct_infreq(x) | レベルの要素の数順にレベルをつけ直す |
| fct_inorder(x) | 前にある要素ほど前のレベルにする |
| fct_rev(x) | レベルを逆順にする |
| fct_shift(x) | レベルの順を1つずらす |
| fct_shuffle(x) | レベルをランダムに並べ替える |
| fct_recode(x, newlevel=“oldlevel”) | oldlevelのラベルをnewlevelにつけ直す |
| fct_anon(x) | レベル名を匿名化する |
| fct_collapse(x, newlevel=c(levels)) | 2つ以上のレベルを1つにまとめる |
| fct_lump_min(x, min) | minで指定した数以上のレベルをotherにする |
| fct_other(x, keep) | keepで指定したレベル以外の因子をotherにする |

表2：forcatsの関数 {.caption-top .table .table-sm .table-striped .small}

### 14.4.1 因子の確認

`fct_count`関数は`table`関数とほぼ同じ関数で、因子の要素数を返しますが、結果をデータフレーム（正確にはtibbleというもの）で返す点が`table`関数とは異なります。

`fct_match`関数は、パターンとしてレベル名を設定し、そのレベルと一致する要素では`TRUE`、一致しない要素には`FALSE`を返します。

`fct_unique`関数は`levels`関数とほぼ同じですが、`levels`関数の返り値が文字列なのに対して、`fct_unique`関数は因子を返す点が異なります。

``` downlit
# tidyverseをロードすると、forcatもロードされる
pacman::p_load(tidyverse)

fx
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: cat dog horse pig

# table関数と同じ変換をデータフレーム（正確にはtibble）を出力として行う
fct_count(fx) 
## # A tibble: 4 × 2
##   f         n
##   <fct> <int>
## 1 cat       4
## 2 dog       5
## 3 horse     2
## 4 pig       3

fct_match(fx, "dog") # 因子dogを探す関数
##  [1]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [13] FALSE FALSE

fct_unique(fx) # levelsとほとんど同じ関数(因子を返す、levelsは文字列を返す)
## [1] cat   dog   horse pig  
## Levels: cat dog horse pig
```

### 14.4.2 因子を結合する

因子をつなぐときに用いるのが、`fct_c`関数と`fct_unity`関数です。`fct_c`関数は`c`関数と同じですが、因子のリストを引数に取れるという特徴があります。`fact_unify`関数は引数にリストを取り、お互いにレベルを追加できるところが異なります。

``` downlit
fx3 <- factor(rep(c("rat", "mouse", "sheep"), c(3, 4, 5)))

c(fx, fx3)
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse rat   rat   rat   mouse mouse mouse mouse sheep sheep sheep
## [25] sheep sheep
## Levels: cat dog horse pig mouse rat sheep

fct_c(fx, fx3) # レベルが追加される(c関数でつないでもほぼ同じ)
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse rat   rat   rat   mouse mouse mouse mouse sheep sheep sheep
## [25] sheep sheep
## Levels: cat dog horse pig mouse rat sheep

fct_unify(list(fx, fx3)) # 因子のリストにそれぞれレベルを追加する
## [[1]]
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: cat dog horse pig mouse rat sheep
## 
## [[2]]
##  [1] rat   rat   rat   mouse mouse mouse mouse sheep sheep sheep sheep sheep
## Levels: cat dog horse pig mouse rat sheep
```

### 14.4.3 レベルの操作

因子のレベルを付け直すのが`fct_relevel`関数です。`factor`関数に`levels`引数を取るのとほぼ同じことができます。

`fct_infreq`関数は因子のレベルを因子の個数順（多いものが前、少ないものが後）に、`fct_inorder`関数は因子のベクターで前に出てきたものをより前にする形でレベルを変更するものです。

`fct_rev`関数はレベルを逆順に、`fct_shift`関数は一番前のレベルを一番最後にシフトし、`fct_shuffle`関数はレベルの順序をランダムに入れ替える関数です。

``` downlit
fct_relevel(fx, c("dog", "cat", "pig", "horse")) # factor(fx, levels=c("dog", "cat", "pig", "horse"))と同じ
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: dog cat pig horse

fct_infreq(fx) # 要素が多いものから順番に並べ替える
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: dog cat pig horse

fct_inorder(fx) # 要素が前にあるものをレベルの前に変更する
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: dog cat pig horse

fct_rev(fx) # レベルを逆順にする
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: pig horse dog cat

fct_shift(fx) # レベルを1つずらす
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: dog horse pig cat

fct_shuffle(fx) # レベルをランダムに並べ替える
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   pig   pig   pig  
## [13] horse horse
## Levels: pig cat dog horse
```

### 14.4.4 レベル名の変更

`fct_recode`関数は因子名を別名に付け替え、`fct_anon`関数は因子名を匿名化（anonymize）するものです。`fct_collapse`関数は因子の複数のレベルを1つにまとめ、`fct_lump_min`関数は`min`引数で指定した数より個数が少ない因子をすべてotherに変えます。`fct_other`関数は`keep`引数で指定したレベル以外をotherに変えます。

いずれも、データをRに取り込んだ後に、余分な因子を処理したり、匿名化することで個人情報等に対応したり、要素が少ない因子を集約するために用いるものです。

``` downlit
fct_recode(fx, mouse="dog", rat="cat", monkey="pig", cow="horse") # ラベルを付け替える
##  [1] mouse  mouse  mouse  mouse  mouse  rat    rat    rat    rat    monkey
## [11] monkey monkey cow    cow   
## Levels: rat mouse cow monkey

fct_anon(fx) # 因子を匿名化（anonymize）する
##  [1] 1 1 1 1 1 2 2 2 2 3 3 3 4 4
## Levels: 1 2 3 4

fct_collapse(fx, dogcat = c("dog", "cat")) # レベルを結合する
##  [1] dogcat dogcat dogcat dogcat dogcat dogcat dogcat dogcat dogcat pig   
## [11] pig    pig    horse  horse 
## Levels: dogcat horse pig

fct_lump_min(fx, min=4) # 2つより少ない個数しかない因子をotherに変える
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   Other Other Other
## [13] Other Other
## Levels: cat dog Other

fct_other(fx, keep=c("dog", "cat")) # keep以外のレベルをotherに変える
##  [1] dog   dog   dog   dog   dog   cat   cat   cat   cat   Other Other Other
## [13] Other Other
## Levels: cat dog Other
```

Wickham, Hadley. 2023. *Forcats: Tools for Working with Categorical Variables (Factors)*. <https://CRAN.R-project.org/package=forcats>.

Wickham, Hadley, Mara Averick, Jennifer Bryan, et al. 2019. “Welcome to the tidyverse.” *Journal of Open Source Software* 4 (43): 1686. <https://doi.org/10.21105/joss.01686>.

Back to top
