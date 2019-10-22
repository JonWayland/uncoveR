# uncoveR
### Tools for exploring datasets

`install_github("JonWayland/uncoveR")`

This package is currently only supported by R, but has plans to be extended to Python. The goal of this project is to create functions that explore datasets by having the dataframe be the sole source of input. The current functions include the following:
* `assocMatrix()`
* `corrMatrix()`
* `getStats()`

Each of the functions take a dataframe as input, and provide back insightful information about the data within the dataframe. Additional arguments are optional for formatting with each of the plotting functions, but are not required.

### Help

#### `assocMatrix()`
##### Description
Using Cramer's V, the association matrix shows pair-wise relationships between categorical variables with up to a specified number of levels
##### Usage
`assocMatrix(dat, n.levels = 6, plotTitle = "default", val.label = FALSE)`
##### Arguments

* `dat` Dataframe with at least 2 categorical variables
* `n.levels`	Specifying the number of levels for all categorical variables to be considered (default is 6)
* `plotTitle` Optional string specifying the title of the plot
* `val.label` Boolean determining whether to add values of coefficients to the plot (default is FALSE)

#### `corrMatrix()`
#### `getStats()`


### Examples
Example of using the `assocMatrix` function:

`assocMatrix(mtcars)`

![Association Matrix](/images/Association%20Matrix%20mtcars.png)

Example of using the `corrMatrix` function:

`corrMatrix(iris, val.label = TRUE)`

![Correlation Matrix](/images/Correlation%20Matrix%20iris.png)

Example of using the `getStats` function:

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
