# 22  オブジェクト指向とクラス

Code

Rは**オブジェクト指向プログラミング言語**であるとされています。オブジェクト指向とは、プログラミングで取り扱う「**もの（Objects）**」を**オブジェクト**として扱い、オブジェクトには**クラス**とメソッドが設定されるような形でプログラミング言語を設計する考え方を指す言葉です。

オブジェクト指向に関わる言葉はたくさんあります（カプセル化・継承・ポリモルフィズム・クラス・インスタンス・メソッド・アクセサ等々、[Wikipedia](https://ja.wikipedia.org/wiki/%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E6%8C%87%E5%90%91%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0)を参照）。他のオブジェクト指向言語、例えばPythonやRubyではこのあたりの理解がプログラミングにおいてとても重要になるのですが、Rでははっきりと理解していなくても、（少なくとも小規模データの解析やグラフ描画程度であれば）大きな問題にはなりません。オブジェクト指向の概念が重要となるのは、恒久的にメンテナンスを続けて使用され続けるプログラム（例えばパッケージなど）や、オンラインで大規模に開発し、常にメンテナンスが必要となるプログラム（Webアプリケーションなど）を作成する時になります。以下にオブジェクト指向の言葉の意味を説明しますが、なんとなくわかる、という程度で通常のデータ解析で困ることはないでしょう。

この章では、やや抽象的なプログラミングに関する内容について説明します。Rでグラフ作成やデータ処理、統計解析を行うのにすぐに必要となる事項ではありませんので、飛ばして[次の章](chapter23.llms.md)に進んで頂いても問題はありません。

## 22.1 クラス

オブジェクトには**クラス**という特性があります。Rでは、数値（numeric）、文字列（character）、論理型（logical）、リスト（list）、行列（matrix、array）、因子（factor）、データフレーム（data.frame）、時系列（ts）などがクラスとして設定されています。クラスは`class`関数を用いて確認することができます。

``` downlit
1 |> class()
## [1] "numeric"
"a" |> class()
## [1] "character"
T |> class()
## [1] "logical"

c(1, 1, 1) |> class() # ベクター自体には特別なクラスはない
## [1] "numeric"
list(1, 1, 1) |> class()
## [1] "list"
matrix(1:4, nrow = 2) |> class()
## [1] "matrix" "array"

factor(1) |> class()
## [1] "factor"
iris |> class()
## [1] "data.frame"
Nile |> class()
## [1] "ts"
```

クラスの役割は、**「オブジェクトの型と取扱いの方法」**を定めるところにあります。例えばデータフレームであれば、「同じ長さのベクトルのリストで、行と列を持つ表の形をしていて、行と列に名前を登録できるもの」という「型」を持っています。また、`plot.data.frame`関数のように、データフレームを「取り扱う方法」が準備されています。このように、クラスは「型」と「取り扱い方」をセットにし、データの取り扱いを簡単にする役割を持ちます。

データフレームをクラスとするオブジェクトは、この「型」を元にした構造を持ち、値や行・列の数・名前が異なるものになっています。つまり、データフレームという「型」は同じですが、中身が違うものがオブジェクトとして作り出されていることになります。プログラミング言語では、この「型」から作り出されたオブジェクトのことを、**インスタンス**と呼びます。

つまり、data.frameはクラスであり、data.frameクラスのオブジェクトである`iris`や`cars`はインスタンスである、ということになります。

## 22.2 Pythonでのクラスの例

クラスとインスタンスに関しては、他の言語での例を見た方がわかりやすいかと思います。以下はPythonの[Documentation](https://docs.python.org/ja/3/tutorial/classes.html)に記載されている`Dog`クラスの定義とインスタンス作成の例です。

Rを含めて、多くのプログラミング言語では**クラスを定義**することができます。クラスにはクラス名が必要です（下の例では`Dog`がクラス名）。クラスを定義するときには、インスタンスの要素（`name`（名前）と`tricks`（芸）という2つ）、インスタンスを演算に用いる**メソッド**、**アクセサ**（アクセス・メソッド）と呼ばれる、インスタンスの要素を変更する方法（下の例では`add_trick`メソッド、**セッター（setter）**と呼ばれる）と要素を呼び出す方法（**ゲッター（getter）**）を準備するのが一般的です。

インスタンスを作成する場合には、クラス名にカッコをつけ、`__init__`に示した引数（`self`はそのオブジェクト自身を指すので、`name`が引数）を指定して実行します。下の例では`dog_Fido`と`dog_Buddy`という2つのインスタンスを作成し、それぞれ`name`に`"Fido"`、`"Buddy`“を設定しています。

``` python
# クラスの定義
class Dog:
    # メソッド（アクセサ）の定義
    def __init__(self, name):
        self.name = name
        self.tricks = []
    def add_trick(self, trick):
        self.tricks.append(trick)

# インスタンス（クラスオブジェクト）の作成
dog_Fido = Dog('Fido')
dog_Buddy = Dog('Buddy')
```

### 22.2.1 RとPythonでのクラスの比較

これだけではよく分からないと思いますので、もう少し説明を加えます。

クラスの設定の目的の一つは、データを**カプセル化**することです。カプセル化というのは、バラバラのデータや取り扱い方法をひとまとめにして、取り扱いやすくすることです。上の例では、犬の名前（`name`）、芸（`trick`）と取り扱い方法（メソッド）をひとまとめにしています。こうすることで、その犬の名前と芸をひとまとめ、つまりカプセル化しているわけです。

Rでは、このようなカプセル化を行うのに、リストが用いられています。ですので、非常に単純化すると、カプセル化とはリストみたいなものだと思ってもらうと良いかと思います。

また、犬の名前や芸がころころ変わってしまうと、犬の名前とその犬ができる芸の関係を維持するのが難しくなってしまいます。ですので、**アクセサ**を準備して、関数を用いないと名前や芸などの要素を追加・変更できないようにしています。

Rでは、listの要素を変える方法、例えば、リストの要素への代入（セッター）や、リストの要素を呼び出す方法（ゲッター）が、アクセサに当たります。

オブジェクトを作成すると、そのクラスのオブジェクトとして変数ができます。この変数は、「型」から作られた「もの」、つまりインスタンスになります。下のRの例では、`lst_Fibo`がリスト（クラス）のオブジェクト（インスタンス）である、ということになります。

``` downlit
# これが__init__に当たる、オブジェクト作成時の方法
lst_Fibo <- list(name = "Fibo", tricks = c("ballcatch", "zigzag"))

lst_Fibo$name <- "Pochi" # これがアクセサ（セッター）みたいなもの

lst_Fibo$name # これもアクセサ（ゲッター）みたいなもの
## [1] "Pochi"

lst_Fibo # オブジェクトの名前の要素が変わる
## $name
## [1] "Pochi"
## 
## $tricks
## [1] "ballcatch" "zigzag"
```

このように見ると、リストは大体クラスの要件を満たしているように見えます。ただし、リストでは要素の数を自由自在に増やしたり減らしたりすることができます。例えば、登録されている犬の名前（`name`）を変えたり、`tricks`を削って`birthday`を追加する、といったことがリストでは簡単にできてしまいます。このような変換を行うと、Pythonの型（クラス）で定義したものとは違う要素を持つオブジェクトを簡単に作れてしまうことになります。

他言語のクラスでは、インスタンスごとに取り扱いが変わることがないように、要素の追加や削除は原則できないようになっています。また、クラスの定義を行うときに、要素のデータ型や要素に対する取り扱いの方法（メソッド）を定義しておき、要素の型、取り扱いの方法を厳密に定めておくのが一般的です。このようにクラスの「要素」・「型」・「取り扱い方」を厳密に定めておくことで、そのクラスのインスタンスをいつ用いても同じ方法で取り扱えることを担保しています。

このような性質は、「誰が、いつ、どのような形でそのクラスのインスタンスを用いても、同じ方法で取り扱うことができる」ために重要となります。ですので、複数人が関わる大規模な開発や大きなアプリケーション、メンテナンスを常時必要とする長期プロジェクトなどではクラスの厳密な定義が非常に重要となります。

一方で、Rはその場限りの解析に用いることが多い言語です。もちろん、パッケージの構築時や、恒常的に組織でメンテナンスし、使い続けるRのプログラムを開発する場合には、クラスの定義と取り扱いは重要となります。ですが、その場限りの解析では、データのカプセル化の役割をリストが十分に果たすことができます。このような理由から、Rでクラスを定義し、用いる方法は（少なくとも簡単な統計解析においては）、あまり重要視されていません。

## 22.3 Rのクラスとアトリビュート（attributes）

Rではクラスはアトリビュート（attributes）として設定されています。ただし、クラスは必ずしもアトリビュートとして設定されているわけではありません。クラスにはアトリビュートとして設定されるものと、されていないものがあります。

数値や文字列、リスト、行列などはアトリビュートとしてクラス名を持たないのに対し、因子やデータフレーム、時系列はアトリビュートとしてクラスが登録されています。

``` downlit
1 |>  attributes()
## NULL
"a" |> attributes()
## NULL
T |> attributes()
## NULL

c(1, 1, 1) |> attributes()
## NULL
list(1, 1, 1) |> attributes()
## NULL
matrix(1:4, nrow = 2) |> attributes()
## $dim
## [1] 2 2

factor(1) |> attributes()
## $levels
## [1] "1"
## 
## $class
## [1] "factor"
iris |> attributes() |> lapply(head)
## $names
## [1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"     
## 
## $class
## [1] "data.frame"
## 
## $row.names
## [1] 1 2 3 4 5 6
Nile |> attributes()
## $tsp
## [1] 1871 1970    1
## 
## $class
## [1] "ts"
```

このようなアトリビュートの差は、**親クラス**（superclass、スーパークラス）と呼ばれるものの違いによります。Rを含め、オブジェクト指向の言語では、クラスを定義するときに、他のクラスの定義を流用し、機能や要素等を追加した上で新しいクラスとすることができます。このように、他のクラスの定義を流用することを、**継承**（inheritance）と呼びます。つまり、数値や文字列、リストなどと、データフレーム、因子、時系列では親クラスが異なるクラスである、ということになります。

Rで親クラスを把握するときに用いる関数として、[`sloop::otype`](https://sloop.r-lib.org/reference/otype.html)があります([Wickham 2019b](#ref-sloop_bib))。[`sloop::otype`](https://sloop.r-lib.org/reference/otype.html)の引数にオブジェクトを取ると、そのオブジェクトの親クラスを調べることができます。

``` downlit
# 数値、文字列はbaseクラスを親とする
1 |> sloop::otype()
## [1] "base"
"a" |> sloop::otype()
## [1] "base"
T |> sloop::otype()
## [1] "base"

# リスト・行列はbaseクラスを親とする
c(1, 1, 1) |> sloop::otype()
## [1] "base"
list(1, 1, 1) |> sloop::otype()
## [1] "base"
matrix(1:4, nrow = 2) |> sloop::otype()
## [1] "base"

# 因子・データフレーム・時系列はS3クラスを親とする
factor(1) |> sloop::otype()
## [1] "S3"
iris |> sloop::otype()
## [1] "S3"
Nile |> sloop::otype()
## [1] "S3"
```

上のように、数値や文字列、リストなどのアトリビュートにクラスを持たないオブジェクトの親クラスはbase、因子やデータフレーム、時系列などのアトリビュートを持つオブジェクトの親クラスはS3となっています。

Rには、これらの親クラスの他に、S4、[R6](https://r6.r-lib.org/articles/Introduction.html) ([Chang 2021](#ref-R6_bib))等の親クラスが存在します。

``` downlit
lm_obj <- lm(iris$Sepal.Length~iris$Sepal.Width)
lm_obj |> sloop::otype()
## [1] "S3"
```

``` downlit
pacman::p_load(lme4)
lme4_obj <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
lme4_obj |> sloop::otype()
## [1] "S4"
```

``` downlit
pacman::p_load(cmdstanr)
file <- file.path(cmdstan_path(), "examples", "bernoulli", "bernoulli.stan")
mod <- cmdstan_model(file)
mod |> sloop::otype() # otypeではS3扱い
## [1] "R6"
mod |> class() # 中身はR6
## [1] "CmdStanModel" "R6"
```

Rにはこの他にも、[`reference class`](http://adv-r.had.co.nz/R5.html)（昔はR5として開発されていたものだと思います）、[`aoos`](https://wahani.github.io/aoos/) ([Warnholz 2017](#ref-aoos_bib))、[`S7`](https://rconsortium.github.io/S7/) ([Vaughan et al. 2023](#ref-S7_bib))などのオブジェクト指向プログラミングに関するクラスがあります。色々あって混乱しているのは、「S3とS4がイマイチ」と思う人が多かったためでしょう。

`S7`を開発しているのが`ggplot2`を開発したHadley Wickhamなので（2023年現在）、いずれは`S7`が主流になるのかもしれませんが、現状では簡単にRにオブジェクト指向のクラスを持ち込む場合にはS3を、少し複雑なプロジェクトにはS4を用いるのが一般的であるように見えます。特に[Bioconductor](https://www.bioconductor.org/)のパッケージではS4のオブジェクトが用いられています。

> **TIP:**
>
> `S3`と`S4`は、R言語の基となったS言語から来たクラスです。それぞれS言語のver.3（S3）とver.4（S4）から来ています。

## 22.4 RでのS3、S4クラスオブジェクトの取り扱い

上に述べたように、Rではパッケージを作成する等の特殊な場合を除いて、クラスを定義することはありません。クラスの定義は入門で学ぶには少し高度な内容となるので、他の文献([Wickham 2019a](#ref-Wickham_Hadley2019-05-24), [2016](#ref-Hadley_Wickham2016-02-10))に説明を譲ります。

しかし、統計の関数の返り値はS3やS4を親クラスとしたオブジェクトとなっている場合が多いため、オブジェクトの取り扱い方を理解しておくことは統計解析において重要となります。

典型的なS3の例として線形回帰の結果（lmオブジェクト）、S4の例として線形混合モデルの結果（lmerModオブジェクト、[lme4パッケージ](https://cran.r-project.org/web/packages/lme4/index.html) ([Bates et al. 2015](#ref-lme4_bib))より）を用いて、オブジェクトの取り扱い方を説明します。

S3オブジェクトでもS4オブジェクトでも、オブジェクトの内容を確認する場合には、まず`str`関数でオブジェクトの構造を理解するところから始めます。

``` downlit
lm_obj |> str(list.len=3) # S3オブジェクト（一部表示）
## List of 12
##  $ coefficients : Named num [1:2] 6.526 -0.223
##   ..- attr(*, "names")= chr [1:2] "(Intercept)" "iris$Sepal.Width"
##  $ residuals    : Named num [1:150] -0.644 -0.956 -1.111 -1.234 -0.722 ...
##   ..- attr(*, "names")= chr [1:150] "1" "2" "3" "4" ...
##  $ effects      : Named num [1:150] -71.566 -1.188 -1.081 -1.187 -0.759 ...
##   ..- attr(*, "names")= chr [1:150] "(Intercept)" "iris$Sepal.Width" "" "" ...
##   [list output truncated]
##  - attr(*, "class")= chr "lm"
```

``` downlit
lme4_obj |> str(list.len=3) # S4オブジェクト（一部表示）
## Formal class 'lmerMod' [package "lme4"] with 13 slots
##   ..@ resp   :Reference class 'lmerResp' [package "lme4"] with 9 fields
##   .. ..$ Ptr    :<pointer: 0x0000013f3e5cf670> 
##   .. ..$ mu     : num [1:180] 254 273 293 313 332 ...
##   .. ..$ offset : num [1:180] 0 0 0 0 0 0 0 0 0 0 ...
##   .. .. [list output truncated]
##   .. ..and 28 methods, of which 14 are  possibly relevant:
##   .. ..  allInfo, copy#envRefClass, initialize, initialize#lmResp,
##   .. ..  initializePtr, initializePtr#lmResp, objective, ptr, ptr#lmResp,
##   .. ..  setOffset, setResp, setWeights, updateMu, wrss
##   ..@ Gp     : int [1:2] 0 36
##   ..@ call   : language lmer(formula = Reaction ~ Days + (Days | Subject), data = sleepstudy)
##   .. [list output truncated]
##   ..$ upper : num [1:3] Inf Inf Inf
##   ..$ reCovs:List of 1
##   .. ..$ :Formal class 'Covariance.us' [package "lme4"] with 2 slots
##   .. .. .. ..@ nc : int 2
##   .. .. .. ..@ par: num [1:3] 0.9667 0.0152 0.2309
```

どちらも`str`関数の引数を指定しない場合にはとても沢山の出力が示されるのですが、特徴としては、

- \$または@から始まる行がたくさん記載されている
- \$・@の後ろに「単語 : データ型」といった表記がある
- S3には\$のみ、S4には\$と@が記載されている
- ところどころにattrという記載がある
- `str`関数の引数がS3の時は、1行目に「List of 〇〇」の表記がある

ということが分かるかと思います。

\$や@は要素の呼び出しに用いるものです。これらはリストやデータフレームで、名前を用いて要素を呼び出す際の`$`と同じものです。\$・@の後に続く単語はリストやデータフレームの名前に当たるもので、`$`・`@`に続けて記載することで要素を呼び出すことができます。S3・S4クラスにはゲッター（getter）の関数が備わっている場合もあり、関数を用いて要素を呼び出せる場合もあります。

`@`はS4クラスに特有の呼び出しの記号で、S3クラスでは用いることがありません。attrはattributesの意味で、その要素に付属するattributesを示しています。要素を`attributes`関数の引数にすることで、そのattributesの内容を取り出すことができます。

最後に、S3オブジェクトの「List of 〇〇」についてですが、RではS3オブジェクトはデータの登録や関数の適用に特徴のあるリストとして実装されています。データの登録に関しては、S3クラスの定義に従い、型チェック等が組み込まれます。また、アトリビュートにクラスが追加されます。

関数の適用に関しては、ジェネリック関数を用いて、そのクラスのオブジェクトを引数にした場合の演算が定義されます。このように、関数名は同じだけどオブジェクトのクラスによって出力が異なる性質のことを**ポリモルフィズム**と呼びます。

以下にS3とS4クラスの値の呼び出しや、関数の適用例を挙げます。

``` downlit
# S3クラス
lm_obj |> class()
## [1] "lm"

# S3クラス：要素の取り出し
lm_obj$coefficients
##      (Intercept) iris$Sepal.Width 
##        6.5262226       -0.2233611

# S3クラス：アトリビュートを読み出す
lm_obj$coefficients |> attributes()
## $names
## [1] "(Intercept)"      "iris$Sepal.Width"

# S3クラス：関数の引数にする（summary.lmが呼び出される）
lm_obj |> summary()
## 
## Call:
## lm(formula = iris$Sepal.Length ~ iris$Sepal.Width)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.5561 -0.6333 -0.1120  0.5579  2.2226 
## 
## Coefficients:
##                  Estimate Std. Error t value Pr(>|t|)    
## (Intercept)        6.5262     0.4789   13.63   <2e-16 ***
## iris$Sepal.Width  -0.2234     0.1551   -1.44    0.152    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.8251 on 148 degrees of freedom
## Multiple R-squared:  0.01382,    Adjusted R-squared:  0.007159 
## F-statistic: 2.074 on 1 and 148 DF,  p-value: 0.1519
```

``` downlit
# S4クラス
lme4_obj |> class()
## [1] "lmerMod"
## attr(,"package")
## [1] "lme4"

# S4クラス：要素の取り出し
lme4_obj@pp$beta0
## [1] 0 0

# S4クラス：アトリビュートを読み出す
lme4_obj@pp$X |> attributes() |> _$dim
## [1] 180   2

# S4クラス：関数の引数にする（summary.lmerModが呼び出されている）
summary(lme4_obj)
## Linear mixed model fit by REML ['lmerMod']
## Formula: Reaction ~ Days + (Days | Subject)
##    Data: sleepstudy
## 
## REML criterion at convergence: 1743.6
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -3.9536 -0.4634  0.0231  0.4634  5.1793 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr 
##  Subject  (Intercept) 612.10   24.741        
##           Days         35.07    5.922   0.07 
##  Residual             654.94   25.592        
## Number of obs: 180, groups:  Subject, 18
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  251.405      6.825  36.838
## Days          10.467      1.546   6.771
## 
## Correlation of Fixed Effects:
##      (Intr)
## Days -0.138

# S4クラス：アクセサ（値を取り出す関数）
coef(lme4_obj)
## $Subject
##     (Intercept)       Days
## 308    253.6637 19.6662617
## 309    211.0064  1.8476053
## 310    212.4447  5.0184295
## 330    275.0957  5.6529356
## 331    273.6654  7.3973743
## 332    260.4447 10.1951090
## 333    268.2456 10.2436499
## 334    244.1725 11.5418676
## 335    251.0714 -0.2848792
## 337    286.2956 19.0955511
## 349    226.1949 11.6407181
## 350    238.3351 17.0815038
## 351    255.9830  7.4520239
## 352    272.2688 14.0032871
## 369    254.6806 11.3395008
## 370    225.7921 15.2897709
## 371    252.2122  9.4791297
## 372    263.7197 11.7513080
## 
## attr(,"class")
## [1] "coef.mer"
```

> **TIP:**
>
> S4では`@`で呼び出せる要素のことをSlotと呼びます。Slotを`@`で呼び出すことは推奨されておらず、適切なアクセサ（ゲッター）で値を取得することが推奨されています。とはいえ、`str`関数を用いてS4オブジェクトの構造を知ることは、S4オブジェクトに何が保存されていて、どのような構造をしているのか理解するために有用だと思います。

Bates, Douglas, Martin Mächler, Ben Bolker, and Steve Walker. 2015. “Fitting Linear Mixed-Effects Models Using lme4.” *Journal of Statistical Software* 67 (1): 1–48. <https://doi.org/10.18637/jss.v067.i01>.

Chang, Winston. 2021. *R6: Encapsulated Classes with Reference Semantics*. <https://CRAN.R-project.org/package=R6>.

Vaughan, Davis, Jim Hester, Tomasz Kalinowski, et al. 2023. *S7: An Object Oriented System Meant to Become a Successor to S3 and S4*. <https://CRAN.R-project.org/package=S7>.

Warnholz, Sebastian. 2017. *Aoos: Another Object Orientation System*. <https://CRAN.R-project.org/package=aoos>.

Wickham, Hadley. 2016. *R言語徹底解説*. 単行本. Translated by 石田基広, 市川太祐, 高柳慎一, and 福島真太朗. 共立出版.

Wickham, Hadley. 2019a. *Advanced r, Second Edition (Chapman & Hall/CRC the r Series) (English Edition)*. Kindle版. Chapman; Hall/CRC.

Wickham, Hadley. 2019b. *Sloop: Helpers for ’OOP’ in r*. <https://doi.org/10.32614/CRAN.package.sloop>.

Back to top
