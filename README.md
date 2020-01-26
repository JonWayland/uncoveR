# uncoveRing Insights in Data
## Overview

The goal of this package is to create functions that explore datasets by having the dataframe be the sole source of input. The current functions include the following:
* `assocMatrix()`
* `corrMatrix()`
* `getStats()`
* `noVarCols()`

Each of the functions take a dataframe as input, and provide back insightful information about the data within the dataframe. Additional arguments are optional for formatting with each of the plotting functions, but are not required.

## Installation
`devtools::install_github("JonWayland/uncoveR")`

## Help

### `assocMatrix()`
#### Description
Using Cramer's V, the association matrix shows pair-wise relationships between categorical variables with up to a specified number of levels (default is 6)
#### Usage
`assocMatrix(dat, n.levels = 6, plotTitle = "default", val.label = FALSE)`
#### Arguments

* `dat` Dataframe with at least 2 categorical variables
* `n.levels` Specifying the number of levels for all categorical variables to be considered (default is 6)
* `plotTitle` Optional string specifying the title of the plot
* `val.label` Boolean determining whether to add values of coefficients to the plot (default is FALSE)

#### Examples
`assocMatrix(mtcars)`

![Association Matrix](/images/Association%20Matrix%20mtcars.png)

### `corrMatrix()`
#### Description
Using Pearson's correlation coefficient, the correlation matrix shows pair-wise relationships between continuous variables

#### Usage
`corrMatrix(dat, plotTitle = "default", val.label = FALSE)`

#### Arguments

* `dat` Dataframe with at least 2 continuous variables
* `plotTitle` Optional string specifying the title of the plot
* `val.label` Boolean determining whether to add values of coefficients to the plot (default is FALSE)

#### Examples
`corrMatrix(iris, val.label = TRUE)`
![Correlation Matrix](/images/Correlation%20Matrix%20iris.png)

### `getStats()`
Retrieves standard statistics from a dataframe

#### Usage
`getStats(dat)`
#### Arguments

* `dat` Dataframe

#### Examples
`getStats(sleep)`
```
High-level statistics for the sleep dataset:
   Total Rows: 20
   Total Columns: 3
     - 1 column is a numeric variable
     - 2 columns are factor variables
     - 0 columns are date variables
   Estimated Size: 2,984 bytes
   Total Potential Outlying Observations: 0
```

### `noVarCols()`
Identifying all columns with no variance

#### Usage
`noVarCols(dat)`
#### Arguments

* `dat` Dataframe

#### Examples
```
sub_iris  <- iris[1:50,]
noVarCols(sub_iris)
```

```
Species 
      5
```
```
sub_iris <- sub_iris[,-noVarCols(sub_iris)]
head(sub_iris)
  Sepal.Length Sepal.Width Petal.Length Petal.Width
1          5.1         3.5          1.4         0.2
2          4.9         3.0          1.4         0.2
3          4.7         3.2          1.3         0.2
4          4.6         3.1          1.5         0.2
5          5.0         3.6          1.4         0.2
6          5.4         3.9          1.7         0.4
```
