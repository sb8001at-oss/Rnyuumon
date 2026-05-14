# System関連の関数

Code

Rにはシステムの情報に関する関数が数多く備わっています。多くの関数は`system`や`Sys.`から始まる名前で設定されています。

システム関連の関数の多くは`base`パッケージでサポートされています。このページでは、以下に示したシステム関連の関数について簡単に説明していきます。

| 関数名 | 引数 | 返り値 |
|:---|:---|:---|
| .Last.value | 無し | 最後の返り値を返す |
| .libPaths | 無し | ライブラリのパスを表示する |
| environment | fun | 実行された場所のenvironmentを返す |
| find.package | パッケージ名 | パッケージの保存場所のパスを表示する |
| get | 関数名 | 関数の情報を表示する |
| getNamespace | パッケージ名 | パッケージの名前空間を表示する |
| getRversion | 無し | Rのバージョンを返す |
| licence | 無し | Rのライセンスを表示する |
| loadNameSpaces | 無し | 名前空間を表示する |
| object.size | オブジェクト名 | オブジェクトのファイルサイズを表示する |
| parent.frame | n（数値） | 親environmentを表示する |
| path.package | パッケージ名 | パッケージの保存場所のパスを表示する |
| R.home | component | Rのインストール先のディレクトリを返す |
| R.version | 無し | Rのバージョンの詳細情報を返す |
| search | 無し | ロードしたパッケージとオブジェクトを返す |
| Sys.Date | 無し | システムの日付を返す |
| Sys.getenv | x, unset | 現在のRの環境変数を返す |
| Sys.getlocate | 無し | localeの情報を表示する |
| Sys.glob | パス名 | ワイルドカードでファイル名を指定して返す |
| Sys.info | 無し | システムの情報を返す |
| Sys.localeconv | 無し | 数値や通貨の設定を返す |
| Sys.setenv | 無し | sys.calls、sys.parents、sys.framesの各結果を返す |
| Sys.setFileTime | ファイル名、日時 | ファイルの更新時間を変更 |
| Sys.sleep | 数値 | 数値の秒数演算を一時停止する |
| sys.status | 無し | sys.calls、sys.parents、sys.framesの各結果を返す |
| Sys.time | 無し | システムの日時を返す |
| Sys.timezone | 無し | システムのタイムゾーンを返す |
| Sys.which | 文字列 | システムのアプリケーションのパスを返す |
| system.file | パッケージ名 | パッケージのパスを返す |
| system.time | 演算（expr） | 演算にかかる時間を返す |
| tempfile | 文字列 | 一時ファイルのパスを返す |
| tempdir | 無し | 一時ファイルを保存するディレクトリのパスを返す |
| topenv | envir | 現在のenvironmentのトップレベルの親 |

System関連の関数の一覧 {.caption-top .table .table-sm .table-striped .small}

## ファイルのパスを返す関数

まずはファイルやプログラム、パッケージのパスを返す関数から説明します。`R.home`関数はRのプログラムが保存されているパスを返す関数です。

``` downlit
# Rのプログラムの保存場所を返す
R.home()
```

    [1] "C:/PROGRA~1/R/R-46~1.0"

ライブラリ、つまりパッケージの保管場所のパスを返すのが`.libPaths`関数です。

``` downlit
.libPaths()
```

    [1] "C:/Program Files/R/R-4.6.0/library"

パッケージのパスを返す関数が`find.package`です。`find.package`はパッケージの名前の文字列を引数に取り、そのパッケージのパスを返します。

``` downlit
find.package("base")
```

    [1] "C:/PROGRA~1/R/R-46~1.0/library/base"

`path.package`関数も`find.package`と同じくパッケージのパスを返す関数です。

``` downlit
path.package("base")
```

    [1] "C:/PROGRA~1/R/R-46~1.0/library/base"

似たような関数として、`system.file`関数があります。引数なしで指定すると`base`パッケージのパス、`package`引数を指定すると指定したパッケージのパスを返します。

``` downlit
system.file()
```

    [1] "C:/PROGRA~1/R/R-46~1.0/library/base"

``` downlit
system.file(package = "BH")
```

    [1] "C:/Program Files/R/R-4.6.0/library/BH"

システムのツールに関するパスを表示するための関数が`Sys.which`関数です。以下の例ではping（ネットワークの通信確認に関するツール）の保存場所が表示されます。Rからコマンドプロンプトに文字列としてコマンドを指定し、実行する関数である`system`や`system2`に渡すとpingの使いかたが表示されます。`system`関数の引数に`args`を設定すれば`args`に指定したオプションに従い実行することもできます。

``` downlit
Sys.which("ping")
```

                                 ping 
    "C:\\WINDOWS\\SYSTEM32\\ping.exe" 

``` downlit
# Sys.which("ping") |> system2(args = "-c") # argsにオプションを指定する
```

一時ファイルのパスや、一時ファイルを保存するディレクトリのパスを返す関数が`tempfile`・`tempdir`です。パッケージなどで一時ファイルを作成したい場合にこのディレクトリを用いてファイルを取り扱うのだと思います。

``` downlit
tempfile("plot", fileext = c(".ps", ".pdf"))

tempdir() 
```

### glob：ワイルドカードを用いてファイルのパスを調べる。

glob（グロブ）とは、ワイルドカード（正規表現のように、文字列のマッチングに用いる表現、[Wikipedia](https://ja.wikipedia.org/wiki/%E3%82%B0%E3%83%AD%E3%83%96)参照）を用いてファイルの場所や名前を指定するための手法です。`Sys.glob`関数はこのワイルドカードを利用したファイルのパスを準備し、そのパターンに一致するファイルのパスを返す関数です。

以下の例では、`"library"`と`"R"`の文字の間に任意の文字（`*`で指定）を含めた`".rdx"`ファイルを検索しています。

``` downlit
Sys.glob(file.path(R.home(), "library", "*", "R", "*.rdx")) |> head(2)
```

    [1] "C:/PROGRA~1/R/R-46~1.0/library/AIPW/R/AIPW.rdx"          
    [2] "C:/PROGRA~1/R/R-46~1.0/library/AlgDesign/R/AlgDesign.rdx"

## Rの情報を表示する関数

System関連の関数には、現在利用しているRの環境などを表示するための関数が多数備わっています。まずはRのバージョンを返す関数、`getRversion`から紹介します。`getRversion`はRのバージョンを文字列として返してくれます。

``` downlit
getRversion()
```

    [1] '4.6.0'

`R.version`も同じような関数ですが、Rのバージョンに関するもっと詳細な情報を返してくれます。

``` downlit
R.Version() |> _[c(1, 7, 8, 14)]
```

    $platform
    [1] "x86_64-w64-mingw32"

    $major
    [1] "4"

    $minor
    [1] "6.0"

    $version.string
    [1] "R version 4.6.0 (2026-04-24 ucrt)"

言語や時間などのロケール（locale）情報を返す関数が`Sys.getlocale`関数です。`Sys.getlocale`関数はロケール情報をセミコロン`";"`で繋いで返すため、`stringr::str_split(";")`で分割すると見やすく表示することができます。localeを設定する`Sys.setlocale`という関数もありますが、あまり使うことはないでしょう。

``` downlit
Sys.getlocale() |> stringr::str_split(";")
```

    [[1]]
    [1] "LC_COLLATE=Japanese_Japan.utf8"  "LC_CTYPE=Japanese_Japan.utf8"   
    [3] "LC_MONETARY=Japanese_Japan.utf8" "LC_NUMERIC=C"                   
    [5] "LC_TIME=Japanese_Japan.utf8"    

``` downlit
# localeを設定する
# Sys.setlocale(category = "LC_ALL", locale = "de")
```

`Sys.timezone`関数はシステムのタイムゾーンを返す関数です。日本のPCだとGMT-9、グリニッジ標準時間＋9時間を示す文字列（`"Etc/GMT-9"`）が返ってきます。タイムゾーンの一覧は`OlsonNames`関数で取得することができます。

``` downlit
Sys.timezone()
```

    [1] "Etc/GMT-9"

``` downlit
# タイムゾーンの一覧を返す
OlsonNames()[1:3]
```

    [1] "Africa/Abidjan"     "Africa/Accra"       "Africa/Addis_Ababa"

システムの環境変数を返す関数が`Sys.getenv`です。**環境変数**はOSで共有されている情報の一つで、システムに関わる情報をソフトウェアなどから読み出せるようにしています。環境変数には環境名と値があり、環境名（以下の例では`__COMPAT_LAYER`や`RunAsAdmin`）と値（`"C:\\WINDOWS"`や`C:\ProgramData`）が紐づけされています。

`Sys.getenv`に環境名を引数として指定すると、特定の環境変数の値を取得することができます。

``` downlit
Sys.getenv() |> head(2)
```

    __COMPAT_LAYER          RunAsAdmin
    ALLUSERSPROFILE         C:\ProgramData

``` downlit
# 環境変数名を指定して値を得る
Sys.getenv("windir")
```

    [1] "C:\\WINDOWS"

セッションの情報を表示する関数が`sessionInfo`です。セッションの情報、つまりRの実行環境を表示する時に用います。Rでコードの実行例を示す場合や、このテキストのようなQuartoを実行し、公開する場合には、どのような環境で実行したのか分かるように`sessionInfo`を実行した結果を示すことが多いです。

``` downlit
sessionInfo()
```

    R version 4.6.0 (2026-04-24 ucrt)
    Platform: x86_64-w64-mingw32/x64
    Running under: Windows 11 x64 (build 22631)

    Matrix products: default
      LAPACK version 3.12.1

    locale:
    [1] LC_COLLATE=Japanese_Japan.utf8  LC_CTYPE=Japanese_Japan.utf8   
    [3] LC_MONETARY=Japanese_Japan.utf8 LC_NUMERIC=C                   
    [5] LC_TIME=Japanese_Japan.utf8    

    time zone: Etc/GMT-9
    tzcode source: internal

    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base     

    other attached packages:
     [1] readxl_1.4.5    lubridate_1.9.5 forcats_1.0.1   stringr_1.6.0  
     [5] dplyr_1.2.1     purrr_1.2.2     readr_2.2.0     tidyr_1.3.2    
     [9] tibble_3.3.1    ggplot2_4.0.3   tidyverse_2.0.0

    loaded via a namespace (and not attached):
     [1] gtable_0.3.6       jsonlite_2.0.0     compiler_4.6.0     tidyselect_1.2.1  
     [5] scales_1.4.0       fastmap_1.2.0      R6_2.6.1           generics_0.1.4    
     [9] knitr_1.51         htmlwidgets_1.6.4  pillar_1.11.1      RColorBrewer_1.1-3
    [13] tzdb_0.5.0         rlang_1.2.0        stringi_1.8.7      xfun_0.57         
    [17] S7_0.2.2           otel_0.2.0         timechange_0.4.0   cli_3.6.6         
    [21] withr_3.0.2        magrittr_2.0.5     digest_0.6.39      grid_4.6.0        
    [25] rstudioapi_0.18.0  hms_1.1.4          lifecycle_1.0.5    vctrs_0.7.3       
    [29] evaluate_1.0.5     glue_1.8.1         cellranger_1.1.0   farver_2.1.2      
    [33] rmarkdown_2.31     tools_4.6.0        pkgconfig_2.0.3    htmltools_0.5.9   

実行環境のシステム（PCやOS）の情報を表示する関数が`Sys.info`です。OSに依存した関数の実行を担保する場合などに利用するのだと思いますが、あまり使われているのを見たことはありません。

``` downlit
Sys.info() |> _[1:2]
```

      sysname   release 
    "Windows"  "10 x64" 

システムの文字、数値の表示法、貨幣単位などを表示する関数が`Sys.localeconv`です。国によって小数点がピリオドやコンマで異なっていたり、貨幣単位や貨幣を意味するシンボル（\$や¥）が異なるため、システムで表示方法が指定されています。返り値の詳細については[WindowsのC++のヘルプ](https://learn.microsoft.com/ja-jp/cpp/c-runtime-library/reference/localeconv?view=msvc-170)に詳しく記載されています。

``` downlit
Sys.localeconv()
```

        decimal_point     thousands_sep          grouping   int_curr_symbol 
                  "."                ""                ""             "JPY" 
      currency_symbol mon_decimal_point mon_thousands_sep      mon_grouping 
                  "¥"               "."               ","            "\003" 
        positive_sign     negative_sign   int_frac_digits       frac_digits 
                   ""               "-"               "0"               "0" 
        p_cs_precedes    p_sep_by_space     n_cs_precedes    n_sep_by_space 
                  "1"               "0"               "1"               "0" 
          p_sign_posn       n_sign_posn 
                  "3"               "3" 

現在ロードされているパッケージとオブジェクトの一覧を表示するのが`search`関数です。`searchpaths`という似た名前の関数はロードされているパッケージと変数のパスを返します。

``` downlit
search() |> head(5)
```

    [1] ".GlobalEnv"        "package:readxl"    "package:lubridate"
    [4] "package:forcats"   "package:stringr"  

``` downlit
searchpaths() |> head(2)
```

    [1] ".GlobalEnv"                               
    [2] "C:/Program Files/R/R-4.6.0/library/readxl"

最後に宣言した値を返すのが`.Last.value`です。`.Last.value`は関数ではなく変数のように取り扱います。

``` downlit
.Last.value
```

    NULL

Rのライセンスを表示するための関数が`license`です。`licence`というスペル違いの関数もあります。Rを起動するときに表示される文には`license`に加えて、`contributors`、`citation`などの関数の記載があります。

``` downlit
license()
```

## environmentに関する関数

Rには**environment**というものが設定されています。このenvironmentというのは、スコープと名前空間などを合わせたようなもので、通常は[44章](chapter44.llms.md)で紹介したスコープとして理解するのがよいかと思います。environmentの詳細についてはR言語徹底解説([Wickham 2016](#ref-Hadley_Wickham2016-02-10))や[Advanced R](https://adv-r.hadley.nz/environments.html)([Wickham 2019](#ref-Wickham_Hadley2019-05-24))に詳細に説明されているので、一読されるとよいでしょう。

現在のenvironmentを返す関数が`environment`です。Rで`environment`関数を実行すると、`R_GlobalEnv`、グローバルスコープが返ってきます。関数の中で`environment`関数を実行すると、environmentのIDに当たる数値が返ってきます。これは、関数の中はグローバルスコープではなく、ローカルスコープであることを意味しています。

また、`.GlobalEnv`はグローバルスコープに関する環境を返す関数です。

``` downlit
# 普通に実行するとグローバルスコープ（R_Grobalenv）が返ってくる
environment()
```

    <environment: R_GlobalEnv>

``` downlit
# 関数の中はローカルスコープなので、R_GlobalEnvとは異なる値が返ってくる
f <- function(x){environment()}
f()
```

    <environment: 0x000001d65b958318>

``` downlit
# これはグローバルスコープに関するenvironmentを返す変数
.GlobalEnv
```

    <environment: R_GlobalEnv>

`topenv`関数はそのenvironmentの最も親に当たるenvironment、要はGrobalEnvを返す関数です。environmentには親・子の関係があり、GrobalEnvが最も親の、関数内のローカルスコープが子の関係にあります。

``` downlit
topenv(.GlobalEnv) 
```

    <environment: R_GlobalEnv>

`parent.frame`関数は現在のenvironmentの親を表示する関数です。`n`引数で何段階の親environmentを表示するかを指定することができます。以下の例では、function内はローカルスコープで、その一つ親のenvironment、つまりGrobalEnvが返ってきています。

``` downlit
f <- function(x){
  parent.frame(n = 1)
}
f(1)
```

    <environment: R_GlobalEnv>

`get`関数は関数に関するenvironmentと名前空間を表示する関数です。`mean`関数は`base`パッケージの関数ですので、environmentとしてnamespace:baseが示されます。また、返り値には関数の設定も含まれます。`mean`関数はほぼ`UseMethod`だけの関数で、[`stringr::str_c`](https://stringr.tidyverse.org/reference/str_c.html)関数では関数の内容が返ってきていることがわかります。

``` downlit
get("mean")
```

    function (x, ...) 
    UseMethod("mean")
    <bytecode: 0x000001d650b795a8>
    <environment: namespace:base>

``` downlit
library(stringr); get("str_c")
```

    function (..., sep = "", collapse = NULL) 
    {
        check_string(sep)
        check_string(collapse, allow_null = TRUE)
        dots <- list(...)
        dots <- dots[!map_lgl(dots, is.null)]
        vctrs::vec_size_common(!!!dots)
        inject(stri_c(!!!dots, sep = sep, collapse = collapse))
    }
    <bytecode: 0x000001d65c6ad6f0>
    <environment: namespace:stringr>

`sys.call`、`sys.frame`、`sys.parents`は何をやっているのかいまいちわからない関数です。

`sys.call`は関数の呼び出し（call）を返す関数です。`sys.frame`は呼び出された場所のenvironentを返す関数、`sys.parents`は親environmentを返す関数です。

``` downlit
sys.call()
```

    eval(expr, envir)

``` downlit
sys.frame()
```

    <environment: R_GlobalEnv>

``` downlit
sys.parents()
```

     [1]  0  1  2  3  4  5  5  5  5  9 10 11 12 13 12 15 16 17 18 19 18 21 22 16 24
    [26] 25 24 16 16 29

2重にネストした関数で`sys.call`、`sys.frame`、`sys.parents`を呼び出してみます。`sys.call`は呼び出した関数の定義と関数内のenvironmentを返しています。

``` downlit
f <- function(x){
  function(x){
    sys.call() |> print()
  }
}
f(1)
```

    function (x) 
    {
        print(sys.call())
    }
    <environment: 0x000001d65cf96378>

`sys.frame`は呼び出した関数の定義と関数内のenvironmentを返しています。

``` downlit
f <- function(x){
  function(x){
    sys.frame() |> print()
  }
}

f(1)
```

    function (x) 
    {
        print(sys.frame())
    }
    <environment: 0x000001d654d0f318>

`sys.parents`では関数の定義と親environment（1つ目の`function`のenvironment）が返ってきます。

``` downlit
f <- function(x){
  function(x){
    sys.parents()
  }
}

f(1)
```

    function (x) 
    {
        sys.parents()
    }
    <environment: 0x000001d6548a0710>

上記の`sys.call`、`sys.frame`、`sys.parents`を一度に呼び出す関数が`sys.status`関数です。

``` downlit
# Quartoの実行時に利用するとsys.callの返り値が長くなるため、実行していません
sys.status()
```

## 名前空間（name space）に関する関数

名前空間は、そのenvironmentで用いられる変数や関数の名前の一覧をまとめたものです。変数や関数の名前が重複すると演算がうまくいかないのは理解しやすいかと思います。この名前の重複などをなくすために、Rでの名前空間はenvironmentごとに設定されています。Rでの名前空間のenvironmentとして、グローバルのenvronment（GrobalEnv）、ローカルスコープのenvironmentに加えて、パッケージのenvironmentが準備されています。

`loadedNamespaces`はロードしたパッケージの名前空間を文字列で返す関数です。グローバルやローカルスコープに関する名前空間は表示されません。

``` downlit
loadedNamespaces()
```

     [1] "gtable"       "jsonlite"     "dplyr"        "compiler"     "stats"       
     [6] "tidyselect"   "tidyverse"    "stringr"      "tidyr"        "scales"      
    [11] "readxl"       "fastmap"      "base"         "ggplot2"      "readr"       
    [16] "R6"           "generics"     "knitr"        "forcats"      "htmlwidgets" 
    [21] "datasets"     "methods"      "tibble"       "lubridate"    "pillar"      
    [26] "RColorBrewer" "tzdb"         "rlang"        "stringi"      "xfun"        
    [31] "utils"        "S7"           "otel"         "timechange"   "cli"         
    [36] "withr"        "magrittr"     "digest"       "grid"         "rstudioapi"  
    [41] "graphics"     "hms"          "lifecycle"    "vctrs"        "evaluate"    
    [46] "glue"         "cellranger"   "farver"       "rmarkdown"    "purrr"       
    [51] "grDevices"    "tools"        "pkgconfig"    "htmltools"   

`getNamespace`関数は個別のロードしたパッケージの名前空間を返す関数です。ロードしたパッケージの名前空間はenvironmentとして設定されています。

``` downlit
getNamespace("base")
```

    <environment: namespace:base>

## 日時に関する関数

日時に関するsystem関連の関数には、`Sys.sleep`、`Sys.Date`、`Sys.time`、`system.time`などがあります。いずれも[21章](chapter21.llms.md)ですでに紹介したものですが、このTipsでも紹介します。

`Sys.sleep`は指定した数値の秒数だけ演算を止める（スリープする）ための関数です。以下の例では、1秒間演算がスリープすることになります。

``` downlit
Sys.sleep(1) # 1秒 演算をスリープする
```

`Sys.Date`と`Sys.time`はシステムの時間を返す関数です。`Sys.Date`は日付、`Sys.time`は日時を返します。

``` downlit
Sys.Date()
```

    [1] "2026-05-15"

``` downlit
Sys.time() 
```

    [1] "2026-05-15 05:13:46 +09"

`system.time`は演算（`expr`）を引数に取り、演算にかかる時間を計算してくれる関数です。

``` downlit
system.time(for(i in 1:100) mean(runif(1000)))
```

       user  system elapsed 
          0       0       0 

## ディレクトリ・ファイルに関する関数

| 関数名 | 引数 | 返り値 |
|:---|:---|:---|
| dir.create | ディレクトリ名 | 新しいディレクトリ（フォルダ）を作成する |
| dir.exists | ディレクトリ名 | ディレクトリが存在すればTRUE |
| file.append | 元のファイル、追加するファイル | ファイルの中身を追加する |
| file.copy | コピー元、コピー先のファイル名 | ファイルをコピーする |
| file.create | ファイル名 | ファイルを作成する |
| file.exists | ファイル名 | ファイルがあるかどうかを論理型で返す |
| file.info | ファイル名 | ファイルの情報を返す |
| file.link | ファイル1、ファイル2 | ファイルのハードリンク |
| file.remove | ファイル名 | ファイルを削除する |
| file.rename | ファイル名、新しいファイル名 | ファイル名を変更する |
| file.show | ファイルのパス、ファイル名 | ファイルを開いて表示する |
| find.package | パッケージ名 | パッケージの保存場所のパスを表示する |

ファイル関連の関数の一覧 {.caption-top .table .table-sm .table-striped .small}

### ファイルの操作

`file.exists`は現在のワーキングディレクトリに特定のファイルが存在するかどうかを論理型で返す関数です。`dir`関数などでもファイルがあるかどうかを確認できますが、特定のファイルが存在しているかどうかチェックする必要があればこちらを用いた方がよいでしょう。

``` downlit
file.exists("Tips_systems.qmd")
```

    [1] TRUE

`file.info`はファイルの情報を返す関数です。UNIXベースのOS（Linux、MacOS）とWindowsでは少し表示される項目が異なります。

``` downlit
file.info("Tips_systems.qmd") |> _[, 1:6]
```

                      size isdir mode               mtime               ctime
    Tips_systems.qmd 29648 FALSE  666 2026-05-14 22:33:00 2026-03-29 13:17:35
                                   atime
    Tips_systems.qmd 2026-05-15 05:13:43

`Sys.setFileTime`はファイルの更新日時を変更するための関数です。`mtime`（更新日時）と`atime`（最終アクセス日時）の両方が更新され、`ctime`（最後にステータスが変更された日時）は変更されない仕様になっています。

``` downlit
file.info("favicon.ico") |> _[, 1:5]
```

                 size isdir mode               mtime               ctime
    favicon.ico 20296 FALSE  666 2026-05-14 22:31:53 2025-05-31 09:15:19

``` downlit
Sys.sleep(5)

# text1.txtのファイル更新時間を設定
Sys.setFileTime("favicon.ico", Sys.time())

file.info("favicon.ico") |> _[, 1:5]
```

                 size isdir mode               mtime               ctime
    favicon.ico 20296 FALSE  666 2026-05-15 05:13:52 2025-05-31 09:15:19

空のファイルを作成する場合には`file.create`、ファイル名の変更には`file.rename`、ファイルを削除するときには`file.remove`関数をそれぞれ用います。

``` downlit
# 引数に取った文字列の名前が付いたファイルを作成
file.create("./tmp/temp.txt")
```

    [1] TRUE

``` downlit
# 第一引数で指定したファイル名を第二引数の文字列に変更
file.rename("./tmp/temp.txt", "./tmp/test.txt") 
```

    [1] TRUE

``` downlit
# 文字列で指定したファイルを削除する
file.remove("./tmp/test.txt")
```

    [1] TRUE

[17章](chapter17.llms.md#writecat関数)で少し紹介した通り、`cat`関数を用いると文字列をテキストファイルとして保存することができます。以下では、text1.txtとtext2.txtという2つのファイルを作成しています。

`file.append`はあるファイルから別のファイルに中身を追加することができる関数です。text1.txtには「text1」、text2.txtには「text2」が記録されています。以下の例では、text1.txtにtext2.txtの内容が追加され、text1に「text1text2」が記録されます。`file.append`自体はRでは追加が成功したら`TRUE`を返します。

``` downlit
# 「text1」を記録したtext1.txtを作成する
cat("text1", file="./tmp/text1.txt")

# 「text2」を記録したtext2.txtを作成する
cat("text2", file="./tmp/text2.txt")

# text1.txtにtext2.txtの内容を追記する
file.append("./tmp/text1.txt", "./tmp/text2.txt")
```

    [1] TRUE

`file.show`はファイルを開く関数、`file.copy`はファイルをコピーする関数です。`file.copy`では第一引数で指定したファイルを第二引数で指定した名前のファイルとしてコピーします。

``` downlit
# text1.txtが開く
file.show("./tmp/text1.txt")

# text1.txtのコピーとしてtext3.txtを作成する
file.copy("./tmp/text1.txt", "./tmp/text3.txt")
```

    [1] TRUE

### ディレクトリの操作

[17章](chapter17.llms.md#フォルダとファイルの作成)でも紹介していますが、ディレクトリ（フォルダ）を作成する場合には、`dir.create`関数を用います。また、現在のワーキングディレクトリに特定のディレクトリが存在しているかどうかは`dir.exist`関数で評価できます。

``` downlit
# testディレクトリを作成
dir.create("./tmp/test")

# testディレクトリが存在していたらTRUEが返ってくる
dir.exists("./tmp/test")
```

    [1] TRUE

### ファイルへのアクセスに関する関数

ファイルの読み込み・書き出しについては[17章](chapter17.llms.md)ですでに説明していますが、Rではファイルを開く・閉じる等の操作をしなくてもファイルを取り扱うことができる多数の関数を備えています。

ココではもう少しプリミティブな、C言語でのファイル読み込み、書き込みに近いような関数について簡単に説明します。17章で紹介した関数群と比べると使い勝手がよいとは言えませんが、他のプログラミング言語でのファイルの取り扱いに似ているため、他のプログラミング言語を学ぶ時や、パッケージを作成する際には役に立つこともあるでしょう。

まずはファイルへのアクセス（connections）に関連する関数の一覧を以下の表に示します。

| 関数名 | 引数 | 返り値 |
|:---|:---|:---|
| file | description、open | ファイルを開く |
| url | description、open | URLで指定されたファイルを開く |
| gzfile | description、open | 圧縮ファイルを作成する（gzip） |
| bzfile | description、open | 圧縮ファイルを作成する（bzip2） |
| xzfile | description、open | 圧縮ファイルを作成する（xz/lzma） |
| zstfile | description、open | 圧縮ファイルを作成する（xz/zstd） |
| unz | description、filename | zipファイルをバイナリで開く（read only） |
| pipe | description、open | 読み出しと書き込みを繋ぐ（Cのpipe） |
| fifo | description、open | 先入れ先出し（FIFO）のconnectionを作成する |
| socketConnection | host、port | 一時的な（temporary）ソケット通信を作成する |
| serverSocket | port | 待機（listening）ソケット通信を作成する |
| socketAccept | socket | listening server socketを受け入れる |
| open | con | connectionを開く |
| close | con | connectionを閉じる |
| flush | con | 書き込みを実際に行う |
| isOpen | con | connectionが開いているかどうかを返す |
| isIncomplete | con | 書き込みが完了したかどうかを返す |
| socketTimeout | socket | socket connectionのタイムアウトの値を返す |
| Sys.chmod | ファイルのパス、mode | ファイルのpermissionを変更する |
| file.syslink | ファイル1、ファイル2 | ファイルのハードリンク |
| stdin | 無し | 標準入力を表示する |
| stdout | 無し | 標準出力を表示する |
| stderr | 無し | エラー出力を表示する |
| showConnections | all | 標準入出力・開いているコネクションをすべて表示する |

ファイルへのアクセスに関する関数の一覧 {.caption-top .table .table-sm .table-striped .small}

まずは`file`関数から紹介します。`file`関数は作成済みのファイルを指定し、そのファイルへの`connection`クラスのオブジェクトを作成するための関数です。`file`関数はそれだけではファイルを操作することはできませんが、`cat`などの関数でその`connection`を指定することでそのファイルへ書き込み・読み込みができます。

``` downlit
temp1 <- file.create("./tmp/temp.txt")
con_temp1 <- file("./tmp/temp.txt", "w")
```

`file`関数はファイルへのパスの他に`open`という引数を取ります。この`open`は、ファイルを読み込むか（read）、ファイルに書き込むか（write）、ファイルに追記するか（append）のうちの3つから選択し、ファイルを開く方法を指定するためのものです。また、特にWindowsでは、ファイルの読み込み・書き込みをテキストで行うか（text）、バイナリで行うか（binary）を指定することも重要となります。

`open`引数は文字列でファイルの開き方を指定します。`open`引数に取れる文字列は以下の表の通りです。

| モードの名前 | 意味                                           |
|:-------------|:-----------------------------------------------|
| r / rt       | 読み込み（テキスト）                           |
| w / wt       | 書き込み（テキスト）                           |
| a / at       | 追記（テキスト）                               |
| rb           | 読み込み（バイナリ）                           |
| wb           | 書き込み（バイナリ）                           |
| ab           | 追記（バイナリ）                               |
| r+ / r+b     | 読み込み＋書き込み                             |
| w+ / w+b     | 読み込み＋書き込み（始めにファイルを空にする） |
| a+ / a+b     | 読み込み＋追記                                 |

open引数に指定する文字列の一覧 {.caption-top .table .table-sm .table-striped .small}

`file`関数の返り値は`connection`クラスのオブジェクトです。返り値を入力すると開いているファイルの情報が返ってきます。

``` downlit
# 変数をそのまま宣言すると、connectionの情報が返ってくる
con_temp1
```

    A connection with                            
    description "./tmp/temp.txt"
    class       "file"          
    mode        "w"             
    text        "text"          
    opened      "opened"        
    can read    "no"            
    can write   "yes"           

``` downlit
# クラスはconnection
class(con_temp1)
```

    [1] "file"       "connection"

この`connection`オブジェクトを`cat`関数や`write`関数の`file`引数、`writeLines`関数の`con`引数に指定することで、文字列をそのファイルに書き込むことができます。

``` downlit
cat("connectionの使い方", file = con_temp1)
writeLines("file引数やcon引数に指定する", con = con_temp1)
```

> **TIP:**
>
> [17章](chapter17.llms.md#writecat関数)で説明した通り、`cat`関数や`write`関数はファイル名を指定して実行すればconnectionを利用しなくてもファイルに書き込めます。
>
> `writeLines`はconnectionを指定しないとファイルへの書き込みができません。`con`引数を指定しない場合、コンソールに第一引数に指定した文字列が表示されます。

書き込みが終わったら、`connection`を閉じる必要があります。`connection`を閉じる時には、`close`関数を用います。

``` downlit
close(con_temp1)

# connectionオブジェクトは残っているが、閉じている
con_temp1
```

    A connection, specifically, 'file', but invalid.

開いている`connection`を表示する関数が`showConnections`関数です。`showConnections`関数を実行すると、stdin（標準入力）、strout（標準出力）、stderr（標準エラー出力）の3つに加えて、開いているconnectionが表示されます。

標準入力・標準出力・標準エラー出力の3つはRでの通常の入力、出力、エラーの出力を表すもので、標準入力はキーボード入力、標準出力・標準エラー出力はConsoleを意味しています。

``` downlit
con_temp1 <- file("./tmp/temp.txt", "w")
showConnections(all = TRUE)
```

      description      class      mode  text     isopen   can read can write
    0 "stdin"          "terminal" "r"   "text"   "opened" "yes"    "no"     
    1 "stdout"         "terminal" "w"   "text"   "opened" "no"     "yes"    
    2 "stderr"         "terminal" "w"   "text"   "opened" "no"     "yes"    
    3 ""               "file"     "w+b" "binary" "opened" "yes"    "yes"    
    4 "./tmp/temp.txt" "file"     "w"   "text"   "opened" "no"     "yes"    

ファイルを閉じてから`showConnections`関数を実行すると、標準入力・標準出力・標準エラー出力のみが表示されます。

``` downlit
close(con_temp1)
showConnections(all = TRUE)
```

      description class      mode  text     isopen   can read can write
    0 "stdin"     "terminal" "r"   "text"   "opened" "yes"    "no"     
    1 "stdout"    "terminal" "w"   "text"   "opened" "no"     "yes"    
    2 "stderr"    "terminal" "w"   "text"   "opened" "no"     "yes"    
    3 ""          "file"     "w+b" "binary" "opened" "yes"    "yes"    

上記の標準入力、標準出力、標準エラー出力はそれぞれ`stdin`、`stdout`、`stderr`の3つの関数で表示することができます。

``` downlit
stdin()
```

    A connection with                      
    description "stdin"   
    class       "terminal"
    mode        "r"       
    text        "text"    
    opened      "opened"  
    can read    "yes"     
    can write   "no"      

``` downlit
stdout()
```

    A connection with                    
    description ""      
    class       "file"  
    mode        "w+b"   
    text        "binary"
    opened      "opened"
    can read    "yes"   
    can write   "yes"   

``` downlit
stderr()
```

    A connection with                      
    description "stderr"  
    class       "terminal"
    mode        "w"       
    text        "text"    
    opened      "opened"  
    can read    "no"      
    can write   "yes"     

`Sys.chmod`はファイルのpermission、上で説明したファイルの開き方や変更できるユーザーなどを指定するための関数です。`Sys.chmod`はファイルへのパス（`paths`）と`mode`の2つの引数を取ります。modeは数字の文字列で指定するのですが、この文字列の指定は[UNIXでのfile permission](https://docs.nersc.gov/filesystems/unix-file-permissions/)に従います。同様にumaskというものを指定する`Sys.umask`という関数もあります。

``` downlit
# ファイルのpermissionを変更する関数
Sys.chmod(paths = "./test1.txt", mode = "777")
```

### シンボリックリンクとハードリンク

シンボリックリンク・ハードリンクはファイルに別の名前を付けることを指す言葉です。すでに存在するファイルに、別名をつけることで、別名でも取り扱うことができるようにします。

シンボリックリンクとハードリンクの違いは、元のファイル名を参照しているのか、元のファイルを参照しているのかの違いです。ですので、元のファイル名がなくなった場合には、シンボリックリンクではファイルを参照できないのに対して、ハードリンクではファイルを参照することができます。詳しくは[このZennの記事（ハードリンクとシンボリックリンクを説明できるようになる）](https://zenn.dev/levtech/articles/hard-symbolic-link)をご参照下さい。

Rでは、`file.symlink`がシンボリックリンク、`file.link`がハードリンクを行うための関数です。いずれも第二引数のファイルを第一引数の文字列で参照できるようにします。

``` downlit
# シンボリックリンクのための関数
file.symlink("text1.txt", "text2.txt")

# ハードリンクのための関数
file.link("text1.txt", "text2.txt")
```

### ファイルのダウンロード

Webからデータをダウンロードする場合には、`download.file`関数を用います。`download.file`は第一引数にアドレス（`url`）、第二引数にダウンロードしたファイルの名前を指定します。

`download.file`では、UnixベースのOSでは特に指定がなくてもファイルをダウンロードし、開くことができるのですが、Windowsでは`mode`引数をバイナリ（`mode = "wb"`）に指定しないとうまくファイルを開くことができません。

これは、Unixではダウンロードしたファイルがテキストなのかバイナリなのかを自動的に判別してくれるのに対し、Windowsでは何も指定しないとテキストとして保存してしまうためです。Windowsでは、テキストファイルをダウンロードする場合以外には、バイナリをダウンロードする指定である`mode = "wb"`を指定する必要があります。

``` downlit
link <- "https://catalog.lib.kyushu-u.ac.jp/opac_download_md/4843901/0102_p041.pdf"

# modeの指定がない場合、Windowsではテキストとして読み込むので開けなくなる
# download.file(link, destfile = "./tmp/0102_p041.pdf")

# binaryとして読み込むと開くことができる
download.file(link, destfile = "./tmp/0102_p041.pdf", mode = "wb")
```

### オブジェクトのファイルサイズを調べる

オブジェクトのファイルサイズを調べる場合、`object.size`関数を用います。あまり使うことはないかもしれませんが、巨大な解析後のデータを取り扱う際にメモリを越えないようモニタリングする際などには使えるかもしれません。

``` downlit
object.size(f)
```

    1120 bytes

    [1]  TRUE  TRUE  TRUE FALSE

Wickham, Hadley. 2016. *R言語徹底解説*. 単行本. Translated by 石田基広, 市川太祐, 高柳慎一, and 福島真太朗. 共立出版.

Wickham, Hadley. 2019. *Advanced r, Second Edition (Chapman & Hall/CRC the r Series) (English Edition)*. Kindle版. Chapman; Hall/CRC.

Back to top
