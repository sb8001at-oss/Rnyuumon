# 27  plotly

Code

## 27.1 インタラクティブなグラフ

Rでインタラクティブなグラフを作成したい場合には、[rgl](https://dmurdoch.github.io/rgl/)パッケージ([Murdoch and Adler 2023](#ref-rgl_bib))や、Javascriptのインタラクティブグラフィックライブラリである[d3.js](https://d3js.org/)を使用したパッケージである[r2d3](https://rstudio.github.io/r2d3/) ([Strayer et al. 2022](#ref-r2d3_bib))を用いるなど、様々な方法があります。

このようなインタラクティブなグラフ作成パッケージの中では、[plotly](https://plotly.com/graphing-libraries/) ([Sievert 2020](#ref-plotly_bib))が機能が多彩で、記述の方法もシンプルな優れたパッケージです。

``` downlit
pacman::p_load(plotly)
```

> **TIP:**
>
> 以前はRでインタラクティブなグラフを作成しても、Rが実行されているPC上でのみ確認ができただけで、他の人とグラフを共有するすべがほとんどありませんでした。しかし、ここ10年で、Rを用いてHTMLの文書を作成するパッケージ（[RMarkdown](https://rmarkdown.rstudio.com/) ([Allaire et al. 2023](#ref-rmarkdown_bib1); [Xie et al. 2018](#ref-rmarkdown_bib2), [2020](#ref-rmarkdown_bib3))、[Quarto](https://quarto.org/)）や、Webアプリケーションを作成するためのパッケージ（[Shiny](https://shiny.posit.co/)）([Chang et al. 2024](#ref-shiny_bib))が公開され、インタラクティブなグラフを共有するしくみが構築されました。
>
> Web上でのインタラクティブなグラフの多くは[d3.js](https://d3js.org/)で構築されていると思います。しかし、d3.jsの記法はやや特殊で、Rユーザーが使いこなすのは難しいです。`plotly`は主にPythonのライブラリとして開発されていますが、Rやほかの言語での開発も行われています。記法も`ggplot2`やRのデフォルトのグラフィック関数に近く、Rユーザーにも使いやすいものとなっています。
>
> インタラクティブなグラフの使いどころは難しいですが、有効に用いれば、データを確認しやすく、見る人の興味を引くグラフを作成することができます。

## 27.2 散布図

`plotly`では、グラフは`plot_ly`関数で描画します。`plot_ly`関数の引数としてグラフのタイプ（`type`）を指定しない場合には、`x`や`y`軸に指定した値に対応したグラフを描画してくれます。`x`にも`y`にも数値を指定すれば、散布図が自動的に選択されて、描画されます。`x`や`y`などの、`ggplot2`での`aes`にあたる要素の指定では、データフレームの列名にチルダ（`~`）を付けます。チルダがないと、列名をうまく読み込むことはできません。

``` downlit
plot_ly(data = iris, x = ~Sepal.Length, y = ~Sepal.Width, color = ~Species)
```

`ggplot2`と同様に、`color`や`size`などの引数に数値を取ることで、バブルチャートなどのグラフを作成することもできます。

``` downlit
iris |> 
  plot_ly(x = ~Sepal.Length, y = ~Sepal.Width, color = ~Petal.Length, size = ~Petal.Width)
```

`ggplot2`での`scale_color_brewer`のような色の指定も行うことができます。配色の指定には`colors`という引数を用います。

``` downlit
diamonds[sample(1:nrow(diamonds), 500),] |> 
  plot_ly(data = _, x = ~carat, y = ~price, color = ~carat, colors = "RdYlGn")
```

## 27.3 棒グラフ

`x`に因子、`y`に数値を与えると、`plot_ly`関数は自動的に棒グラフを描画します。逆に`x`に数値、`y`に因子を与えると、棒グラフが横向きになります。

``` downlit
iris |> 
  group_by(Species) |>
  summarise(mSepal.Length = mean(Sepal.Length)) |> 
  plot_ly(x = ~Species, y = ~mSepal.Length, color = ~Species)
```

## 27.4 線グラフ

線グラフを描画する場合の`x`、`y`の指定は散布図と同じです。線を加える場合には、`mode="lines"`もしくは`mode="lines+markers"`と指定します。`"lines"`で指定した場合には線のみ、`"lines+markers"`は点と線を描画する形になります。

``` downlit
pacman::p_load(gapminder)
color_4 <- c("red", "blue", "green", "black") # 色をベクターで指定

gapminder |> 
  filter(country == "Japan" | country == "China" | country == "United States" | country == "Australia") |> 
  plot_ly(x = ~year, y = ~gdpPercap, type = "scatter", mode = "lines+markers", color = ~country, colors = color_4)
```

## 27.5 3次元グラフ

3次元のグラフは`rgl`で描画できますが、`plotly`でも簡単に3次元グラフを作成することができます。`plotly`で三次元グラフを作成する場合には、`x`、`y`に加えて、`z`軸に相当する値を指定します。ただし、`rgl`と同じように、3次元グラフはデータを認識しにくいため、3dグラフを用いるのではなく他のグラフ、例えばバブルチャートなどを選択する方がよいでしょう。

``` downlit
iris |> 
  plot_ly(x = ~Sepal.Length, y = ~Sepal.Width, z = ~Petal.Length, color = ~Species, size = 0.1)
```

## 27.6 時系列プロット

`x`軸に日時データを指定すれば、簡単に時系列グラフを描画することができます。時系列プロットや線グラフを作成する場合には、`plot_ly`関数の返り値を`add_trace`関数の引数にする形でも指定できます。

``` downlit
# time(Nile)は時系列から時間のみ取り出す関数、21章参照
data.frame(year = time(Nile), value = Nile) |> 
  plot_ly(type = "scatter", mode = "lines") |> 
  add_trace(x = ~year, y = ~value)
```

## 27.7 ウォーターフォールプロット

企業の財務状態などを表記する場合には、**ウォーターフォールプロット**が便利です。ウォーターフォールプロットでは、収益と支出の色を変え、収益はプラス方向、支出はマイナス方向の方向性を持った形で棒グラフで表現します。ウォーターフォールプロットを作図する場合には、`type="waterfall"`と指定します。

`plotly`では、ウォーターフォールプロットのほかにも、[ろうそくチャート](https://ja.wikipedia.org/wiki/%E3%83%AD%E3%83%BC%E3%82%BD%E3%82%AF%E8%B6%B3%E3%83%81%E3%83%A3%E3%83%BC%E3%83%88)や[オープン-ハイ-ロー-クローズチャート](https://datavizcatalogue.com/methods/OHLC_chart.html)など、ビジネスや株価に関連したグラフを簡単に作成することができます。

``` downlit
# https://plotly.com/r/waterfall-charts/ に記載の例
x= c("Sales", "Consulting", "Net revenue", "Purchases", "Other expenses", "Profit before tax")
measure= c("relative", "relative", "total", "relative", "relative", "total")
text= c("+60", "+80", "", "-40", "-20", "Total")
y= c(60, 80, 0, -40, -20, 0)

data = data.frame(x = factor(x, levels = x), measure, text, y)

fig <- plot_ly(
  data, name = "20", type = "waterfall", measure = ~measure,
  x = ~x, textposition = "outside", y= ~y, text = ~text,
  connector = list(line = list(color = "rgb(63, 63, 63)"))) 

fig <- fig %>%
  layout(title = "Profit and loss statement 2018",
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        autosize = TRUE,
        showlegend = TRUE)

fig
```

## 27.8 ggplotly

`plotly`では、`ggplot2`で準備したグラフをインタラクティブなグラフに簡単に変換することができます。`ggplot2`のグラフオブジェクトを変数に保存し、その変数を`ggplotly`関数の引数にするだけで、`ggplot2`のグラフがインタラクティブなplotlyのグラフに変換されます。

``` downlit
p <- iris |> 
  ggplot(aes(x = Sepal.Length, y = Sepal.Width, size = Petal.Length, color = Species))+
  geom_point() 

ggplotly(p)
```

Allaire, JJ, Yihui Xie, Christophe Dervieux, et al. 2023. *Rmarkdown: Dynamic Documents for r*. <https://github.com/rstudio/rmarkdown>.

Chang, Winston, Joe Cheng, JJ Allaire, et al. 2024. *Shiny: Web Application Framework for r*. <https://CRAN.R-project.org/package=shiny>.

Murdoch, Duncan, and Daniel Adler. 2023. *Rgl: 3D Visualization Using OpenGL*. <https://CRAN.R-project.org/package=rgl>.

Sievert, Carson. 2020. *Interactive Web-Based Data Visualization with r, Plotly, and Shiny*. Chapman; Hall/CRC. <https://plotly-r.com>.

Strayer, Nick, Javier Luraschi, and JJ Allaire. 2022. *R2d3: Interface to ’D3’ Visualizations*. <https://CRAN.R-project.org/package=r2d3>.

Xie, Yihui, J. J. Allaire, and Garrett Grolemund. 2018. *R Markdown: The Definitive Guide*. Chapman; Hall/CRC. <https://bookdown.org/yihui/rmarkdown>.

Xie, Yihui, Christophe Dervieux, and Emily Riederer. 2020. *R Markdown Cookbook*. Chapman; Hall/CRC. <https://bookdown.org/yihui/rmarkdown-cookbook>.

Back to top
