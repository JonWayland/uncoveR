# uncoveRing Insights in Data
## Overview

The goal of this package is to create functions that explore datasets by having the dataframe be the sole source of input. The current functions include the following:
* [`assocMatrix()`](#association-matrix)
* [`corrMatrix()`](#correlation-matrix)
* [`corrFinder()`](#correlation-finder)
* [`getStats()`](#getting-dataframe-statisics)
* [`noVarCols()`](#determining-columns-with-no-variance)
* [`scale_form()`](#fitting-the-scales-of-numeric-data)
* [`scale_make()`]()

Each of the functions take a dataframe as input, and provide back insightful information about the data within the dataframe. Additional arguments are optional for formatting with each of the plotting functions, but are not required.

## Installation
`devtools::install_github("JonWayland/uncoveR")`

# Association Matrix
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

# Correlation Matrix
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

# Correlation Finder
### `corrMatrix()`
#### Description
Using Pearson's correlation coefficient, the correlation finder stores pair-wise relationships between continuous variables as well as the average correlation with all other variables

#### Usage
`corrFinder(dat, strongest = TRUE, weakest = FALSE)`

#### Arguments

* `dat` Dataframe with at least 2 continuous variables
* `strongest` Boolean indicating whether to order the output by the strongest absolute correlations (default is TRUE)
* `weakest` Boolean indicating whether to order the output by the weakest absolute correlations (default is FALSE)

#### Examples
```
corrFinder(iris)
          Var1         Var2 correlation      p_value var1_avg_cor var2_avg_cor
6  Petal.Width Petal.Length   0.9628654 4.675004e-86    0.4715602    0.4687264
2 Petal.Length Sepal.Length   0.8717538 1.038667e-47    0.4687264    0.5240417
4  Petal.Width Sepal.Length   0.8179411 2.325498e-37    0.4715602    0.5240417
3 Petal.Length  Sepal.Width  -0.4284401 4.513314e-08    0.4687264   -0.3040453
5  Petal.Width  Sepal.Width  -0.3661259 4.073229e-06    0.4715602   -0.3040453
1  Sepal.Width Sepal.Length  -0.1175698 1.518983e-01   -0.3040453    0.5240417
```

# Getting Dataframe Statisics
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
# Determining Columns with No Variance
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

# Fitting the Scales of Numeric Data
### `scale_form()`
#### Description
Fitting the summary statistics from training data needed to scale new data
#### Usage
`scale_form(dat, remove.me = c(), exclude.binary = TRUE)`
#### Arguments

* `dat` Dataframe with at least 1 numeric variable
* `remove.me` List of columns that are to be manually removed from the scaling
* `exclude.binary` Boolean determining whether to exclude binary columns from scaling

#### Examples
`std.fit <- scale_form(iris, remove.me = c("Sepal.Width"))`
```std.fit

      COL_NAME COL_MEAN    COL_SD COL_MIN COL_MAX
1 Sepal.Length 5.843333 0.8280661     4.3     7.9
2 Petal.Length 3.758000 1.7652982     1.0     6.9
3  Petal.Width 1.199333 0.7622377     0.1     2.5
```

# Scaling Data with Fitted Scales
### `scale_make()`
#### Description
Scaling new data with fitted scales
#### Usage
`scale_make(dat, scale_data, scaler = c('standard', 'minmax'))`
#### Arguments

* `dat` Dataframe with columns that are to be scaled
* `scale_data` Fitted scales using the `scale_form` function
* `scaler` Type of scales to be applied. Default is standardization.

#### Examples
`std.fit <- scale_form(iris, remove.me = c("Sepal.Width"))`
`scaled_iris <- scale_make(iris, std.fit, scaler = "standard")`
```summary(scaled_iris)

  Sepal.Length       Sepal.Width     Petal.Length      Petal.Width            Species  
 Min.   :-1.86378   Min.   :2.000   Min.   :-1.5623   Min.   :-1.4422   setosa    :50  
 1st Qu.:-0.89767   1st Qu.:2.800   1st Qu.:-1.2225   1st Qu.:-1.1799   versicolor:50  
 Median :-0.05233   Median :3.000   Median : 0.3354   Median : 0.1321   virginica :50  
 Mean   : 0.00000   Mean   :3.057   Mean   : 0.0000   Mean   : 0.0000                  
 3rd Qu.: 0.67225   3rd Qu.:3.300   3rd Qu.: 0.7602   3rd Qu.: 0.7880                  
 Max.   : 2.48370   Max.   :4.400   Max.   : 1.7799   Max.   : 1.7064                
```
