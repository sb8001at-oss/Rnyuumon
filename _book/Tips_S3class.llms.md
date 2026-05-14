# S3クラス

Code

オブジェクト指向とクラスについてはすでに[22章](chapter22.llms.md)で紹介しました。Rには、S3、S4、R6、S7などのオブジェクト指向プログラミングに関するクラスが備わっています。ここでは、**S3クラス**について簡単に説明します。

S3クラスはRの基になったS言語で初めに設定されたオブジェクト指向プログラミングに関するクラスで、S ver.3（1992年）で設定されたためにS3と呼ばれているものです。

S3は非常にシンプルです。オブジェクトのattributeに`class`が設定されるとS3クラスのオブジェクトとして認識されます。以下の例は、ベクターに`class`を設定しただけのものです。[`sloop::otype`](https://sloop.r-lib.org/reference/otype.html)([Wickham 2019b](#ref-sloop_bib))でクラスを調べると、S3となっています。

``` downlit
# ただのベクター
v <- 1:3

# クラスはbase
v |> sloop::otype()
## [1] "base"

# attributeにclassを設定する
attributes(v) <- list(class = "MyClass")

# classはMyClass
class(v)
## [1] "MyClass"

# S3と判定される
v |> sloop::otype()
## [1] "S3"
```

> **TIP:**
>
> この型判定に使っている[`sloop::otype`](https://sloop.r-lib.org/reference/otype.html)もとても単純な関数です。クラスが無ければ`"base"`、`"S4"`でなければ`"S3"`か`"R6"`、`"refClass"`でなければ`"S4"`、その他は`"RC"`と判定しているだけです。
>
> ``` downlit
> sloop::otype
> ## function (x) 
> ## {
> ##     if (!is.object(x)) {
> ##         "base"
> ##     }
> ##     else if (!isS4(x)) {
> ##         if (!inherits(x, "R6")) {
> ##             "S3"
> ##         }
> ##         else {
> ##             "R6"
> ##         }
> ##     }
> ##     else {
> ##         if (!is(x, "refClass")) {
> ##             "S4"
> ##         }
> ##         else {
> ##             "RC"
> ##         }
> ##     }
> ## }
> ## <bytecode: 0x0000023181778990>
> ## <environment: namespace:sloop>
> ```

Rの多くの関数ではこのS3クラスが返り値として用いられています。

`lm`関数の返り値である、`lm`クラスを以下の例では示しています。`lm`クラスのオブジェクトである`result_lm`はS3クラスです。この`result_lm`のクラスを取り除く（`unclass`）と、listになります。

つまり、`lm`クラスはattributeに`"lm"`という名前のclassが設定されているだけのリストです。

``` downlit
result_lm <- lm(cars$dist ~ cars$speed)

# lmクラスはS3
result_lm |> sloop::otype()
## [1] "S3"

# attributeからクラスを取り除くと、listになる
result_lm |> unclass() |> class()
## [1] "list"
```

リストなので、値をリストと同じように置き換えることができます。

``` downlit
# 傾きと切片を返すcoef関数
coef(result_lm)
## (Intercept)  cars$speed 
##  -17.579095    3.932409

# 係数（coefficients）をdogに置き換える
result_lm$coefficients <- "dog"

# クラスはlmのまま
result_lm |> class()
## [1] "lm"

# coefで呼び出せるものが傾きと切片ではなく、dogになる
coef(result_lm)
## [1] "dog"
```

…PythonやRubyのような真面目なオブジェクト指向プログラミング言語を使いこなしている方からすると、このS3クラスを設定する意味があるのか疑わしいと思われるでしょうし、型安全な言語から見ると狂気のような仕様ですが、Rで最も用いられているクラスはこのS3です。

S3はシンプルで、ジェネリック関数を設計する上では大きな問題が起こることはなく、クラスの設定も簡単です。`lm`関数のコードを読むと、`class(z) <- c(if (mlm) "mlm", "lm")`という一文だけでこの関数の返り値が`lm`クラスになっています。

クラスをS3である`lm`にすることで、`lm`オブジェクトを引数とするたくさんのジェネリック関数を用いることができています。

``` downlit
methods(class="lm")
##  [1] add1           alias          anova          case.names     coerce        
##  [6] confint        cooks.distance deviance       dfbeta         dfbetas       
## [11] dffits         drop1          dummy.coef     effects        extractAIC    
## [16] family         formula        fortify        hatvalues      influence     
## [21] initialize     kappa          labels         logLik         model.frame   
## [26] model.matrix   nobs           plot           predict        print         
## [31] proj           qr             residuals      rstandard      rstudent      
## [36] show           simulate       slotsFromS3    summary        variable.names
## [41] vcov          
## see '?methods' for accessing help and source code
```

とは言っても、`lm`クラスほどにシンプルだといろいろ心配になります。以下では、[Advanced RのS3クラスの章](https://adv-r.hadley.nz/s3.html)([Wickham 2016](#ref-Hadley_Wickham2016-02-10), [2019a](#ref-Wickham_Hadley2019-05-24))を参考に、もう少しまともなS3クラスの設定について説明していきます。

## S3クラスの設計：Constructor、Validator、Helper

Advanced Rには、S3クラスを設計する際には**Constructor**、**Validator**、**Helper**を設定すると良い、と記載されています。それぞれ以下のような意味を持つ関数です。

- Constructor：そのクラスのオブジェクトを作成する関数
- Validator：そのクラスの値が正しいことを検証するための関数
- Helper：そのクラスの取扱いを簡単にするための関数

以下では、この3つについてそれぞれ説明していきます。

### コンストラクタ（Constructor）

**Constructor**はクラスのオブジェクト（インスタンス）を作成するための関数です。Constructorの名前は`new_MyClass`のように、`new_`にクラス名をつなげたものとします。この関数はクラスに設定する値を引数に取り、関数内でリストなどのオブジェクトを作成し,このオブジェクトにクラスを設定して返します。

以下では、`MyDog`クラスのConstructorである`new_MyDog`関数を設計しています。`new_MyDog`クラスはイヌの名前（`name`）、芸（`trick`）、年齢（`age`）をリストの要素にしたクラスです。

イヌの名前（`name`）、芸（`trick`）、年齢（`age`）をリストの要素にするため、関数の引数はそれぞれ`name`、`trick`、`age`とします。何の芸もできないイヌもいるでしょうから、`trick`のデフォルト値は`NA`としておきます。

関数内ではこの3つの引数をリストにまとめ、クラスを`"MyDog"`に設定しています。

これでConstructorである`new_MyDog`関数が完成しました。この`new_MyDog`関数の返り値は`MyDog`クラスのオブジェクトとなります。

``` downlit
new_MyDog <- function(name, trick = NA, age){
  temp_list <- 
    list(
      # trimwsは前後のスペースを取り除く関数
      name = trimws(name), 
      trick = trick,
      age = age
    )
  
  # temp_listのクラスをMyDogに設定する
  class(temp_list) <- "MyDog"
  
  temp_list
}
```

Constructorを使うと`MyDog`クラスのオブジェクトを作成することができます。クラスを設定したため、`MyDog`クラスはS3になります。

``` downlit
pochi <- new_MyDog("pochi", "おすわり", 5)
sloop::otype(pochi)
## [1] "S3"
```

### バリデータ（Validator）

この`new_MyDog`関数は単に引数をリストにして、クラスを付与するだけの関数です。ですので、イヌとしては何か不自然な設定にしたとしても、エラーも何も出ません。`name`、`trick`、`age`には複数要素のベクターを設定できてしまいますので、どのイヌの芸なのか、どのイヌの年齢なのかわからない、あまり訳に立たないクラスになってしまいます。

``` downlit
fukuzawa_yukawa <- 
  new_MyDog(name = c("福沢諭吉", "湯川秀樹"), "学問が得意", c(5, 15, 30))

fukuzawa_yukawa
## $name
## [1] "福沢諭吉" "湯川秀樹"
## 
## $trick
## [1] "学問が得意"
## 
## $age
## [1]  5 15 30
## 
## attr(,"class")
## [1] "MyDog"
```

そもそもどの値もデータ型を固定していないため、`name`に数値、`trick`に論理型、`age`にデータフレームを設定できたりします。これでは訳に立つクラスにはなりそうにありません。

そこで、クラスの作成時には、各要素のデータ型を固定し、矛盾しない値のみを代入できるようにチェックする必要があります。このために用いられる関数が**Validator**です。Validatorは「validate」、つまり「正しい状態であるか検証する」ための関数です。

RのValidatorは、[11章](chapter11.llms.md#エラーメッセージエラーを表示させる)で説明した`stopifnot`関数を用いて、正しい構造のクラスオブジェクトが作成されない場合にはエラーが出るように作成します。Validatorの名前は、`validate_MyClass`という形で、`validate_`にクラス名をつなぎます。Validatorの引数にはそのクラスのオブジェクトを指定します。

`stopifnot`関数は引数が`FALSE`のときにエラーを返します。ですので、正しくオブジェクトを作成できた場合に`TRUE`が返ってくる評価を引数に指定して設定するとよいでしょう。

以下の`validate_MyDog`関数の例では、`MyDog`クラスの`name`が文字列で、長さ`1`の時には何も返さず、それ以外の場合にはエラーが返ってきます。

``` downlit
validate_MyDog <- function(MyDog){
  # FALSEの要素があるとエラーになる
  stopifnot(
    is.character(MyDog$name), # MyDog$nameは文字列でないとダメ
    length(MyDog$name) == 1 # MyDog$nameは要素が1つでないとダメ
  )
}
```

この`validate_MyDog`関数を用いて`MyDog`クラスのオブジェクトである`pochi`と`fukuzawa_yukawa`を評価すると、`pochi`は何も返ってこないのに対して、`fukuzawa_yukawa`ではエラーが返ってきます。`MyDog$name`の長さが2なので、`length(MyDog$name) == 1`が`FALSE`を返すためです。

``` downlit
validate_MyDog(pochi)
```

``` downlit
validate_MyDog(fukuzawa_yukawa)
## Error in `validate_MyDog()`:
## ! length(MyDog$name) == 1 is not TRUE
```

上記の`validate_MyDog`関数では`MyDog`クラスの`name`だけが検証できる形になっています。実際にクラスを設計する場合には、`MyDog`クラスの各要素、`name`、`trick`、`age`が矛盾なく登録できるよう、たくさんの設定を追加する必要があります。

また、エラーが出て停止した場合、どの要素に問題があってエラーが出たのか分からないと、うまくオブジェクトを作成するのが難しくなってしまいます。`stopifnot`関数は、`"文字列"=論理型`という形で引数を指定することで、論理型が`FALSE`の場合に文字列をエラーメッセージとして返してくれます。どのような問題でエラーが出ているのか分かるように、エラーメッセージを適切に設定するとよいでしょう。

Validatorに返り値は特にいらないのですが、`invisible(MyClass)`のように何も返さないものを最後に宣言しておくとよいとされている場合もあるようです。

``` downlit
validate_MyDog <- function(MyDog){
  stopifnot(
    inherits(MyDog, "MyDog"),
    length(MyDog) == 3,
    length(MyDog$name) == 1,
    length(MyDog$age) == 1,
    
    "名前は文字列で設定して下さい" = 
      is.character(MyDog$name),
    
    "名前が設定されていません" = 
      nchar(MyDog$name) > 0 ,
    
    "名前は20文字以内で設定して下さい" = 
      nchar(MyDog$name) < 20,
    
    "芸は以下より選択して下さい。
    \"sit\", \"down\", \"stay\", \"paw\", \"spin\", \"jump\", \"fetch\",\"ballcatch\", \"zigzag\""  = 
      MyDog$trick %in% 
        c("sit", "down", "stay", "paw", "spin", 
          "jump", "fetch","ballcatch", "zigzag") | is.na(MyDog$name),
    
    "年齢は数値で設定して下さい。" = 
      is.numeric(MyDog$age),
    
    "年齢は正の値で設定して下さい。" = 
      MyDog$age > 0,
    
    "年齢は30歳以下で設定して下さい。" =
      MyDog$age <= 30
  )
  
  invisible(MyDog)
}
```

### ヘルパー（Helper）

最後にHelperについて説明します。Helperはオブジェクトの作成を簡単に行うことができるようにするための関数です。Rではオブジェクトはそのクラス名と同じ名前の関数で作成できる場合が多いです。例えば、`data.frame`や`factor`、`lm`などは関数の名前であり、返り値のクラスの名前でもあります。

`MyDog`クラスに関しても、クラス名と同じ関数でオブジェクトを作成し、validateできるようにした関数である`MyDog`関数を設計してみます。`MyDog`関数は、Constructor（`new_MyDog`）とValidator（`validate_MyDog`）を呼び出し、validateされた`MyDog`クラスのオブジェクトを返すようになっています。

``` downlit
MyDog <- function(name, trick, age){
  temp <- new_MyDog(name, trick, age)
  validate_MyDog(temp)
  temp
}
```

この`MyDog`関数を用いることで、引数に問題がある場合にはオブジェクトが作成されないため、（ただのS3と比べると）安全なオブジェクトを作成できます。

``` downlit
MyDog("Pochi", "sit", 15)
## $name
## [1] "Pochi"
## 
## $trick
## [1] "sit"
## 
## $age
## [1] 15
## 
## attr(,"class")
## [1] "MyDog"
```

``` downlit
MyDog("", "sit", 15)
## Error in `validate_MyDog()`:
## ! 名前が設定されていません

MyDog("Wolfeschlegelsteinhausenbergerdorff", "sit", 15)
## Error in `validate_MyDog()`:
## ! 名前は20文字以内で設定して下さい

MyDog("Pochi", "お手", 15)
## Error in `validate_MyDog()`:
## ! 芸は以下より選択して下さい。
##     "sit", "down", "stay", "paw", "spin", "jump", "fetch","ballcatch", "zigzag"

MyDog("Pochi", "sit", 150)
## Error in `validate_MyDog()`:
## ! 年齢は30歳以下で設定して下さい。

MyDog(c(name = "Pochi", "Shiro"), "sit", 15)
## Error in `validate_MyDog()`:
## ! length(MyDog$name) == 1 is not TRUE
```

Helper関数として、オブジェクトの作成だけではなく、オブジェクトがその型を取るかどうかを評価する関数（`is_MyDog`）やオブジェクトの値を指定した形で取り出す関数（アクセサ、ゲッター）を準備してもよいでしょう。

``` downlit
is_MyDog <- function(MyDog){
  inherits(MyDog, "MyDog")
}

tricks <- function(MyDog){
  stopifnot(inherits(MyDog, "MyDog"))
  paste0(MyDog$name, "は", MyDog$trick, "が得意です。")
}
```

上記のようにConstructor・Validator・Helperを設定することで、自分で作成したクラスを適切に取り扱うことができるようになります。

``` downlit
pochi <- MyDog("Pochi", "sit", 15)

pochi$name
## [1] "Pochi"

is_MyDog(pochi)
## [1] TRUE
tricks(pochi)
## [1] "Pochiはsitが得意です。"
```

## ジェネリック関数（genelic functions）

[22章](chapter22.llms.md)などで紹介した通り、Rの主な関数（`print`、`summary`など）の多くは**ジェネリック関数**として設定されています。ジェネリック関数は指定した引数のクラスに応じて結果の返し方が異なる関数です。

ジェネリック関数は引数のクラスによって呼び出す関数を変えることで結果を適切に返すことができるようになっています。

例えば、`print`関数では、引数が`Date`クラスなら`print.Date`を、`dist`クラスなら`print.dist`を呼び出すことで、それぞれ`Date`クラスのオブジェクト、`dist`クラスのオブジェクトを適切に出力できるようになっています。

では、上記の`MyDog`クラスのオブジェクトを`print`関数の引数にしてみます。出力はリストを`print`関数の引数に取った時と同じです。

``` downlit
print(pochi)
## $name
## [1] "Pochi"
## 
## $trick
## [1] "sit"
## 
## $age
## [1] 15
## 
## attr(,"class")
## [1] "MyDog"
```

`print`関数として呼び出されているものを確認する場合、[`sloop::s3_dispatch`](https://sloop.r-lib.org/reference/s3_dispatch.html)関数を用います。`pochi`はリスト扱いで表示されており、呼び出されている関数は`print.default`であることがわかります。

``` downlit
# print.defaultが呼び出される
print(pochi) |> sloop::s3_dispatch()
##    print.MyDog
## => print.default
```

ここで`print`関数の中身を少し確認します。`print`関数の情報の2行目をみると`UseMethod("print")`という記載があります。後で詳しく説明するとおり、Rのジェネリック関数ではこの`UseMethod`関数が重要な要素となっています。

``` downlit
print
## function (x, ...) 
## UseMethod("print")
## <bytecode: 0x0000023174bb7d18>
## <environment: namespace:base>
```

関数に`UseMethod`が設定されている場合、簡単にジェネリック関数を作成することができます。ジェネリック関数の名前は`関数名.クラス名`とします。`MyDog`クラスに`print`関数のジェネリックを設定する場合、関数名を`print.MyDog`とします。

関数名を`print.MyDog`としたら、後は普通に関数の定義を`function`で書いていくだけです。引数には`MyDog`クラスのオブジェクトを取る関数として定義していきます。

``` downlit
print.MyDog <- function(MyDog){
  stopifnot(inherits(MyDog, "MyDog"))
  cat("name: ", MyDog$name, "\n")
  cat("trick: ", MyDog$trick, "\n")
  cat("age: ", MyDog$age, "\n")
}
```

この`print.MyDog`関数は、`print`関数として呼び出すことができます。`print`関数の引数に`MyDog`クラスのオブジェクトを取ると、`print.MyDog`関数が呼び出され、関数の定義に従いコンソールに表示が返ってきます。

``` downlit
print(pochi)
## name:  Pochi 
## trick:  sit 
## age:  15

# print.MyDogが呼び出されていることがわかる
print(pochi) |> sloop::s3_dispatch()
## => print.MyDog
##  * print.default
```

### 新規のジェネリック関数を作成する

新しい名前のジェネリック関数を作成したい場合には、まず`UseMethod`だけを実行する関数を作成します。以下の例では、`getagedays`関数を定義していますが、関数内では`UseMethod("getagedays")`だけを実行しています。

``` downlit
getagedays <- function(age){
  UseMethod("getagedays")
  }
```

この`UseMethod`関数は引数に設定したオブジェクトのクラスを評価し、適用するジェネリック関数を探す機能を持つものです。この時、クラスの評価は**クラスの継承（inheritance）**の順に従って行われます。

クラスの継承は、クラスを作成するときに、別のクラスの機能を「借りる」ような場合に用いる方法です。この時、「借りる」方のクラスを子クラス（サブクラス）、「貸す」方のクラスを親クラス（スーパークラス）と呼びます。

Rでは行列（matrix/array）が継承の典型的な例で、matrix/arrayの親クラスはinteger、integerの親クラスがnumericという形で、3段重ねの継承となっているクラスです。このスーパークラス・サブクラスの関係については`.class2`関数で調べることができます。インデックスの小さい（左側の）要素がサブクラス、インデックスの大きい（右側の）要素がスーパークラスに対応しています。

``` downlit
.class2(matrix(1:5))
## [1] "matrix"  "array"   "integer" "numeric"
```

`UseMethod`は、この継承のサブクラスからスーパークラスまで、ジェネリック関数の存在を評価していき、最もサブクラス寄りにあるジェネリック関数を選択するための関数です。ですので、上で定義した`getagedays`関数はそれ自体はジェネリック関数を探して実行するための`UseMethod`を実行していて、引数が与えられた時には`"getagedays"`から始まるジェネリック関数のうち、最もサブクラス寄りのクラスに対して定義された関数（例えば`getagedays.MyDog`など）を呼び出して実行しています。

> **TIP:**
>
> 上の説明でわかる方もいるかもしれませんが、やや分かりにくいです。`UseMethod`はその引数の文字列と`"."`、`.class2`関数の返り値を`paste0`関数で繋いで、その名前の中から実際に存在する関数を探していると考えてもらうとわかりやすいかもしれません。
>
> ``` downlit
> classes <- .class2(penguins |> tibble::tibble())
> paste0("print", ".", classes)
> ## [1] "print.tbl_df"     "print.tbl"        "print.data.frame"
> ```
>
> ジェネリック関数の一覧は`methods`関数で調べることができます。この中から上記の3つの名前の関数に一致する要素があるかどうか評価します。
>
> ``` downlit
> gen_functions <- paste0("print", ".", classes)
>
> gen_functions[gen_functions %in% methods("print")]
> ## [1] "print.tbl"        "print.data.frame"
> ```
>
> 2つ出てきて、最も左（サブクラス）である関数は`print.tbl`です。ですので、`tibble`を引数に取ったとき、`UseMethod`はこの`print.tbl`を実行します。どの名前も一致しない場合には`print.default`が選択されて、実行されます。

> **TIP:**
>
> matrixはS3ではなく、baseのオブジェクトです。
>
> ``` downlit
> matrix(1:5) |> sloop::otype()
> ## [1] "base"
> ```
>
> ですので、`.class2`関数の引数に取ったときに返ってくるのはS3のクラスではないのですが、承継に関してはクラスとほぼ同じ機能を持ちます（implicit class、「暗黙のクラス」と呼ばれます）。`UseMethod`自体がこの`.class2`の順番にクラスに適合する関数を探索する機能を持つため、ジェネリック関数を利用する場合にはS3とほぼ同様の処理が行われます。

この`UseMethod`関数だけを宣言して定義した関数名を用いると、上記の`.クラス名`を用いてジェネリック関数を作成することができます。以下では`getagedays`関数のデフォルトの方法を定義しています。

``` downlit
getagedays.default <- function(age){
  stopifnot(is.numeric(age))
  paste(365 * age, "days")
  }
```

`getagedays`は数値の引数に365をかけて文字列を返す関数です。数値を引数に取って実行すれは普通の関数として利用できます。

``` downlit
getagedays(15)
## [1] "5475 days"
```

次に、ジェネリック関数である`getagedays.MyDog`関数を設定します。`MyDog`クラスオブジェクトの`age`に365をかける関数です。

``` downlit
getagedays.MyDog <- function(MyDog){
  paste(365 * MyDog[[3]], "days")
}
```

`getagedays`関数の引数に`MyDog`クラスのオブジェクトを取ると、`getagedays.MyDog`が呼び出されます。`getagedays`関数の引数に数値を取ると`getagedays.default`が呼び出されているので、ジェネリック関数を一から作成することができています。

``` downlit
getagedays(pochi)
## [1] "5475 days"

# getagedays.MyDogが呼び出されている
getagedays(pochi) |> sloop::s3_dispatch()
## => getagedays.MyDog
##  * getagedays.default

# 数値が引数の時はgetagedays.defaultが呼び出されている
getagedays(15) |> sloop::s3_dispatch()
##    getagedays.double
##    getagedays.numeric
## => getagedays.default
```

## セッターを設定する

[16章](chapter16.llms.md)で紹介した通り、Rのリストでは以下のようないろいろな方法で値の変更ができます。

``` downlit
lst <- list(x = 1, y = 2, z = 3)

lst[[1]] <- 4

lst$y <- 5

lst[["z"]] <- 6

lst
## $x
## [1] 4
## 
## $y
## [1] 5
## 
## $z
## [1] 6
```

ここまで触ってきた`MyDog`クラスは`validate_MyDog`関数を用いて正しい構造になるよう確認していますが、中身はただのリストですので、値を自由に変更できてしまいます。

値を自由に変更できないようにして、`validate_MyDog`に従ってリストの構造を維持するには、[22章](chapter22.llms.md)で紹介した**セッター（setter）**を適切に設定する必要があります。セッターはオブジェクトの値を設定する方法に関する関数です。上に示したリストの値の変更の方法はすべてセッターであると言えます。

リストのセッターは、`[<-`、`[[<-`と`$<-`の3つです。いずれもC言語で作成・実装されている関数です。

``` downlit
`[<-`
## .Primitive("[<-")

`[[<-`
## .Primitive("[[<-")

`$<-`
## .Primitive("$<-")
```

この2つのセッターに`MyDog`クラスのオブジェクトでのデータの変更に関する設定をジェネリック関数として実装すれば、`MyDog`クラスのオブジェクトに正しい方法でアクセスする方法、セッター（アクセサ）を準備することができます。

``` downlit
# [<-と$<- は使えなくする
`[<-.MyDog` <- function(MyDog){
  stopifnot(FALSE)
  }

`$<-.MyDog` <- function(MyDog){
  stopifnot(FALSE)
  }

# [[<- はバリデートして確認するようにする
`[[<-.MyDog` <- function(MyDog, i, value){
  MyDog <- unclass(MyDog)
  MyDog[[i]] <- value
  MyDog <- new_MyDog(MyDog$name, MyDog$trick, MyDog$age)
  validate_MyDog(MyDog)
  }
```

上記のようにジェネリック関数を準備すると、`MyDog`クラスのオブジェクトには不自然な値を設定することはできなくなります。

``` downlit
# ゲッターには影響はない
pochi[[1]]
## [1] "Pochi"

# ジェネリック関数の[[<-を呼び出す
pochi[[1]] <- "shiro"
pochi
## name:  shiro 
## trick:  sit 
## age:  15

pochi[["name"]] <- "pochi"

# $オペレーターでは値を変更できない
pochi$name <- "name"
## Error in `$<-.MyDog`:
## ! unused arguments ("name", value = "name")

# [<-でも値を変更できない
pochi[1] <- "name"
## Error in `[<-.MyDog`:
## ! unused arguments (1, value = "name")

# $による値の取得は別関数なので問題ない
pochi$name
## [1] "pochi"

# リストは通常通り扱える
lst$x <- 1
```

もう少しフォーマルな形で値を変更したいのであれば、セッター専用の以下のような関数を利用してもよいでしょう。

``` downlit
setname <- 
  function(MyDog, x){
    MyDog[[1]] <- x
    MyDog
    }

setname(pochi, "kuro")
## name:  kuro 
## trick:  sit 
## age:  15
```

これでまともなクラスの設定ができているか、というと微妙なところではありますが、Validatorをより適切に記載したり、セッターの設定を見直すことでより良いS3クラスの設計ができるかもしれません。

> **TIP:**
>
> RできちんとしたS3クラスを設計することはあまりありません。
>
> Advanced Rに書いているように、
>
> > “R doesn’t stop you from shooting yourself in the foot, but as long as you don’t aim the gun at your toes and pull the trigger, you won’t have a problem.”
>
> `lm`関数の返り値の要素に代入したりしようとすることはまずないですし、誤って代入してしまった場合には計算をやり直せばよいだけです。シンプルなS3を用いても、Rでは十分役目を果たすことができるでしょう。
>
> どうしてもきちんとしたオブジェクト指向のクラスが使いたいのであれば、S4やR6を用いることを検討しましょう。

> **TIP:**
>
> 上記の方法でセッターを設定すれば、とりあえずはきちんとルールに沿って値を変更することはできます。しかし、余計なオブジェクトをたくさん作成し、オブジェクト自体を作り直すような形でセッターを設計しています。
>
> よりスマートな方法でのセッターの設定を行うための関数が`NextMethod`です。[Advanced RのS3クラスの章](https://adv-r.hadley.nz/s3.html)([Wickham 2016](#ref-Hadley_Wickham2016-02-10), [2019a](#ref-Wickham_Hadley2019-05-24))には、`NextMethod`を使ってジェネリック関数を作成する方法について説明があります。ただし、この`NextMethod`の使い方はかなり難しく（どうも一つ上のスーパークラスのジェネリック関数を呼んでいるようですが、Helpを読んでもよくわからない）、使いこなすのは大変です。

Wickham, Hadley. 2016. *R言語徹底解説*. 単行本. Translated by 石田基広, 市川太祐, 高柳慎一, and 福島真太朗. 共立出版.

Wickham, Hadley. 2019a. *Advanced r, Second Edition (Chapman & Hall/CRC the r Series) (English Edition)*. Kindle版. Chapman; Hall/CRC.

Wickham, Hadley. 2019b. *Sloop: Helpers for ’OOP’ in r*. <https://doi.org/10.32614/CRAN.package.sloop>.

Back to top
