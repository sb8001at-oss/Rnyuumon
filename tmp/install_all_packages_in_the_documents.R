pkgs_rnyu <- 
  c(
    "xml2",
    "downlit",
    "devtools",
    "pak",
    "knitr",
    "tidyverse",
    "pacman",
    "lubridate",
    "plotly",
    "readxl",
    "rex", 
    "rmarkdown", # 16章まで
    "data.table", # 17章
    "mlbench",
    "palmerpenguins", 
    "gapminder", # 18章
    "tictoc", # 21章
    "reticulate",
    "sloop",
    "lme4", # 22章
    "lattice",
    "rgl",
    "gplots",
    "DescTools", # 24章
    "DT", # 25章
    "maps",
    "sf",
    "patchwork",
    "gganimate",
    "gifski",
    "GGally", # 26章
    "effectsize",
    "broom",
    "outliers", # 29章
    "lmerTest",
    "brms",
    "kernlab",
    "glmnet",
    "pls",
    "neuralnet",
    "KernSmooth",
    "mgcv",
    "gratia", # 30章
    "gridExtra",
    "e1071",
    "tidymodels",
    "tm",
    "SnowballC",
    "randomForest",
    "xgboost", # 31章
    "factoextra",
    "MASS", # 32章
    "zoo",
    "CADFtest",
    "TSstudio",
    "forecast",
    "tseries",
    "rstan",
    "prophet",
    "dlm", # 33章
    "ggsurvfit",
    "survival",
    "muhaz",
    "shiny",
    "survminer", # 34章
    "postcards", # 42章
    "spData",
    "stars",
    "viridis",
    "cubelyr",
    "tmap",
    "leaflet", # 45章
    "igraph",
    "tidygraph",
    "ggraph",
    "networkD3",
    "oaqc",
    "deldir",
    "visNetwork", # 46章
    "FrF2",
    "skpr",
#    "mixexp", # removed
    "AlgDesign", # 48章
    "causaldata",
    "dagitty",
    "cobalt",
    "MatchIt",
    "WeightIt",
    "AIPW",
    "optmatch",
    "rgenoud",
    "Matching",
    "quickmatch",
    "highs",
    "SuperLearner", # 49章
    "DRDID",
    "CausalImpact",
    "rdrobust", # 50章
    "bnlearn",
    "gRain",
    "lavaan",
    "lavaanPlot", # 51章
    "parallelly",
    "parallel",
    "foreach",
    "doParallel",
    "future",
    "future.apply",
    "furrr",
    "doFuture",
    "progressr",
    "futurize", # 並列演算
    "BH", # システム関数
    "methods" # S4
  )

pkgs_rnyu |> unique() |> install.packages()

pak::pak("cran/mixexp")
#pak::pak("kasperdanielhansen/Rgraphviz")

# 22章：cmdstanrのインストール
install.packages("cmdstanr", repos = c('https://stan-dev.r-universe.dev', getOption("repos")))
cmdstanr::install_cmdstan(cores = 2)

# 51章でBioconductorを使っているのでインストールする
install.packages("BiocManager")
BiocManager::install(c("graph", "Rgraphviz"))
