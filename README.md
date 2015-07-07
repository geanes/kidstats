KidStats
========

Shiny application to make subadult age and sex estimations based on long-bone measurements using MARS and FDA models respectively.

KidStats works best with RStudio (http://www.rstudio.com) which works well with `shiny` and includes *pandoc*.

KidStats is based on the research of Kyra Stull PhD (http://kyrastull.weebly.com), an Associate Professor in the Department of Anthropology at Idaho State University.

Installation:
-------------

KidStats requires **R** version 3.1.2 or higher.

```r
install.packages("devtools")
devtools::install_github("geanes/kidstats")
```
Usage:
------

```r
library(kidstats)
kidstats()
```
