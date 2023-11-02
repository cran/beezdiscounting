
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/beezdiscounting)](https://cran.r-project.org/package=beezdiscounting)
[![downloads](https://cranlogs.r-pkg.org/badges/beezdiscounting)](https://cranlogs.r-pkg.org/)
[![total](https://cranlogs.r-pkg.org/badges/grand-total/beezdiscounting)](https://cranlogs.r-pkg.org/)

# Behavioral Economic (be) Easy (ez) Discounting

An R package containing commonly used functions for analyzing behavioral
economic discounting data.

The package supports scoring of the 27-Item Monetary Choice
Questionnaire (see [Kaplan et al.,
2016](https://doi.org/10.1007/s40614-016-0070-9)) and scoring of the
minute discounting task (see [Koffarnus & Bickel,
2014](https://doi.org/10.1037/a0035973)) using the Qualtrics 5-trial
discounting template (see the [Qualtrics Minute Discounting User
Guide](https://doi.org/10.13140/RG.2.2.26495.79527)), which is also
available as a .qsf file in this package.

## Note About Use

Currently, this version (0.1.1) appears stable. I encourage you to use
it but be aware that, as with any software release, there might be
(unknown) bugs present. I’ve tried hard to make this version usable
while including the core functionality (described more below). However,
if you find issues or would like to contribute, please open an issue on
my [GitHub page](https://github.com/brentkaplan/beezdiscounting) or
[email me](mailto:bkaplan.ku@gmail.com).

## Installing beezdiscounting

### CRAN Release (recommended method)

The latest stable version of `beezdiscounting` (currently v.0.1.1) can
be found on [CRAN](https://CRAN.R-project.org/package=beezdiscounting)
and installed using the following command. The first time you install
the package, you may be asked to select a CRAN mirror. Simply select the
mirror geographically closest to you.

``` r
install.packages("beezdiscounting")

library(beezdiscounting)
```

### GitHub Release

To install a stable release directly from
[GitHub](https://github.com/brentkaplan/beezdiscounting), first install
and load the `devtools` package. Then, use `install_github` to install
the package and associated vignette. You *don’t* need to download
anything directly from
[GitHub](https://github.com/brentkaplan/beezdiscounting), as you should
use the following instructions:

``` r
install.packages("devtools")

devtools::install_github("brentkaplan/beezdiscounting")

library(beezdiscounting)
```

# Using the Package

## 27-item Monetary Choice Questionnaire Scoring Overview

### Example Dataset

An example dataset of responses on the 27-Item Monetary Choice
Questionnaire is provided. This object is called `mcq27` and is located
within the `beezdiscounting` package. These data are the example data
used in the paper by [Kaplan et al,
2016](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6701266/). Note the
format of the data, which is called “long format”. Long format data are
data structured such that repeated observations are stacked in multiple
rows, rather than across columns.

|     | subjectid | questionid | response |
|:----|----------:|-----------:|---------:|
| 1   |         1 |          1 |        0 |
| 2   |         1 |          2 |        0 |
| 3   |         1 |          3 |        0 |
| 4   |         1 |          4 |        1 |
| 5   |         1 |          5 |        1 |
| 6   |         1 |          6 |        0 |
| 7   |         1 |          7 |        1 |
| 28  |         2 |          1 |        0 |
| 29  |         2 |          2 |        1 |
| 30  |         2 |          3 |        1 |
| 31  |         2 |          4 |        1 |
| 32  |         2 |          5 |        1 |
| 33  |         2 |          6 |        0 |
| 34  |         2 |          7 |        1 |

The first column contains the subject id. The second column contains the
question id. The third column contains the response (0 for smaller
sooner, 1 for larger later)

### Converting from Wide to Long and Vice Versa

`beezdiscounting` includes several helper functions to reshape data.

##### `long_to_wide_mcq()`

Long format data are widened such that subject id is the first column
and each subsequent column contains the response associated with the
question (specified as column names).

``` r
wide <- long_to_wide_mcq(generate_data_mcq(2))

knitr::kable(wide[, c(1:5, 24:28)], caption = "Wide Format Data")
```

| subjectid |   1 |   2 |   3 |   4 |  23 |  24 |  25 |  26 |  27 |
|----------:|----:|----:|----:|----:|----:|----:|----:|----:|----:|
|         1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   0 |
|         2 |   1 |   1 |   1 |   0 |   1 |   1 |   1 |   1 |   1 |

Wide Format Data

##### `wide_to_long_mcq()`

Wide data (see example of wide data above) are made long such that
subject id is in the first column, question id (inferred from the column
names from the wide format dataframe) is the second column, and the
response is the third column.

``` r
long <- wide_to_long_mcq(wide, items = 27)

knitr::kable(long[c(1:5, 28:32), ], caption = "Long Format Data")
```

| subjectid | questionid | response |
|----------:|-----------:|---------:|
|         1 |          1 |        1 |
|         1 |          2 |        1 |
|         1 |          3 |        1 |
|         1 |          4 |        1 |
|         1 |          5 |        0 |
|         2 |          1 |        1 |
|         2 |          2 |        1 |
|         2 |          3 |        1 |
|         2 |          4 |        0 |
|         2 |          5 |        1 |

Long Format Data

##### `wide_to_long_mcq_excel()`

A different ‘type’ of wide data is that used in the 27-Item Monetary
Choice Questionnaire Automated Excel Scorer ([Kaplan et al,
2016](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6701266/)). In this
format, the first column is the question id and each subsequent column
represents a subject (as the column name) and the response in rows (see
the example below). This function takes the data from that format and
converts it to the format needed for `beezdiscounting` functions.

``` r
knitr::kable(wide_excel[c(1:5, 22:27), ], 
             caption = "Format Expected in the 27-Item MCQ Excel Scorer")
```

| questionid |   1 |   2 |
|-----------:|----:|----:|
|          1 |   1 |   1 |
|          2 |   1 |   1 |
|          3 |   1 |   1 |
|          4 |   1 |   0 |
|          5 |   0 |   1 |
|         22 |   1 |   0 |
|         23 |   1 |   1 |
|         24 |   1 |   1 |
|         25 |   1 |   1 |
|         26 |   1 |   1 |
|         27 |   0 |   1 |

Format Expected in the 27-Item MCQ Excel Scorer

``` r
long_excel <- wide_to_long_mcq_excel(wide_excel)

knitr::kable(long_excel[c(1:5, 28:32), ], caption = "Long Format")
```

| subjectid | questionid | response |
|:----------|-----------:|---------:|
| 1         |          1 |        1 |
| 1         |          2 |        1 |
| 1         |          3 |        1 |
| 1         |          4 |        1 |
| 1         |          5 |        0 |
| 2         |          1 |        1 |
| 2         |          2 |        1 |
| 2         |          3 |        1 |
| 2         |          4 |        0 |
| 2         |          5 |        1 |

Long Format

##### `long_to_wide_mcq_excel()`

Data can be manipulated from long form into a form used by the 27-Item
Monetary Choice Questionnaire Automated Excel Scorer.

``` r
wide_excel <- long_to_wide_mcq_excel(long_excel)

knitr::kable(wide_excel[c(1:5, 22:27), ], 
             caption = "Format Expected in the 27-Item MCQ Excel Scorer")
```

| questionid |   1 |   2 |
|-----------:|----:|----:|
|          1 |   1 |   1 |
|          2 |   1 |   1 |
|          3 |   1 |   1 |
|          4 |   1 |   0 |
|          5 |   0 |   1 |
|         22 |   1 |   0 |
|         23 |   1 |   1 |
|         24 |   1 |   1 |
|         25 |   1 |   1 |
|         26 |   1 |   1 |
|         27 |   0 |   1 |

Format Expected in the 27-Item MCQ Excel Scorer

### Generate Fake MCQ Data

Generate data specifying reproducibility and proportion of `NA`
responses.

``` r
## fake data with no missing values
fake_data_no_missing <- generate_data_mcq(n_ids = 2, n_items = 27, 
                                          seed = 1234, prop_na = 0)
knitr::kable(fake_data_no_missing, caption = "Fake Data - No Missings")
```

| subjectid | questionid | response |
|----------:|-----------:|---------:|
|         1 |          1 |        1 |
|         1 |          2 |        1 |
|         1 |          3 |        1 |
|         1 |          4 |        1 |
|         1 |          5 |        0 |
|         1 |          6 |        1 |
|         1 |          7 |        0 |
|         1 |          8 |        0 |
|         1 |          9 |        0 |
|         1 |         10 |        1 |
|         1 |         11 |        1 |
|         1 |         12 |        1 |
|         1 |         13 |        1 |
|         1 |         14 |        0 |
|         1 |         15 |        1 |
|         1 |         16 |        1 |
|         1 |         17 |        1 |
|         1 |         18 |        0 |
|         1 |         19 |        1 |
|         1 |         20 |        1 |
|         1 |         21 |        1 |
|         1 |         22 |        1 |
|         1 |         23 |        1 |
|         1 |         24 |        1 |
|         1 |         25 |        1 |
|         1 |         26 |        1 |
|         1 |         27 |        0 |
|         2 |          1 |        1 |
|         2 |          2 |        1 |
|         2 |          3 |        1 |
|         2 |          4 |        0 |
|         2 |          5 |        1 |
|         2 |          6 |        0 |
|         2 |          7 |        0 |
|         2 |          8 |        0 |
|         2 |          9 |        1 |
|         2 |         10 |        0 |
|         2 |         11 |        1 |
|         2 |         12 |        1 |
|         2 |         13 |        0 |
|         2 |         14 |        1 |
|         2 |         15 |        0 |
|         2 |         16 |        1 |
|         2 |         17 |        1 |
|         2 |         18 |        1 |
|         2 |         19 |        0 |
|         2 |         20 |        0 |
|         2 |         21 |        0 |
|         2 |         22 |        0 |
|         2 |         23 |        1 |
|         2 |         24 |        1 |
|         2 |         25 |        1 |
|         2 |         26 |        1 |
|         2 |         27 |        1 |

Fake Data - No Missings

``` r
## fake data with missing values
fake_data_missing <- generate_data_mcq(n_ids = 2, n_items = 27, 
                                          seed = 1234, prop_na = .1)
knitr::kable(fake_data_missing, caption = "Fake Data - Missings")
```

| subjectid | questionid | response |
|----------:|-----------:|---------:|
|         1 |          1 |        1 |
|         1 |          2 |       NA |
|         1 |          3 |        1 |
|         1 |          4 |        1 |
|         1 |          5 |        0 |
|         1 |          6 |        1 |
|         1 |          7 |        0 |
|         1 |          8 |        0 |
|         1 |          9 |        0 |
|         1 |         10 |        1 |
|         1 |         11 |        1 |
|         1 |         12 |        1 |
|         1 |         13 |        1 |
|         1 |         14 |        0 |
|         1 |         15 |       NA |
|         1 |         16 |        1 |
|         1 |         17 |        1 |
|         1 |         18 |        0 |
|         1 |         19 |        1 |
|         1 |         20 |        1 |
|         1 |         21 |        1 |
|         1 |         22 |        1 |
|         1 |         23 |        1 |
|         1 |         24 |        1 |
|         1 |         25 |        1 |
|         1 |         26 |        1 |
|         1 |         27 |        0 |
|         2 |          1 |        1 |
|         2 |          2 |        1 |
|         2 |          3 |        1 |
|         2 |          4 |        0 |
|         2 |          5 |        1 |
|         2 |          6 |        0 |
|         2 |          7 |        0 |
|         2 |          8 |        0 |
|         2 |          9 |        1 |
|         2 |         10 |        0 |
|         2 |         11 |       NA |
|         2 |         12 |        1 |
|         2 |         13 |        0 |
|         2 |         14 |        1 |
|         2 |         15 |        0 |
|         2 |         16 |       NA |
|         2 |         17 |        1 |
|         2 |         18 |        1 |
|         2 |         19 |        0 |
|         2 |         20 |        0 |
|         2 |         21 |        0 |
|         2 |         22 |       NA |
|         2 |         23 |        1 |
|         2 |         24 |        1 |
|         2 |         25 |        1 |
|         2 |         26 |        1 |
|         2 |         27 |        1 |

Fake Data - Missings

### Score 27-item MCQ

MCQ data can be scored regularly and can also impute using various
methods specified by [Yeh et al,
2023](https://doi.org/10.1371/journal.pone.0292258)

#### Normal (no imputation)

##### No missing data

``` r
## normal scoring of data with no missing values
tbl1 <- score_mcq27(fake_data_no_missing)
```

| subjectid | overall_k |  small_k | medium_k |  large_k | geomean_k |
|----------:|----------:|---------:|---------:|---------:|----------:|
|         1 |  0.000158 | 0.000158 | 0.000158 | 0.000251 |  0.000185 |
|         2 |  0.000251 | 0.001562 | 0.004469 | 0.000158 |  0.001034 |

k Values

| subjectid | overall_consistency | small_consistency | medium_consistency | large_consistency | composite_consistency |
|----------:|--------------------:|------------------:|-------------------:|------------------:|----------------------:|
|         1 |            0.740741 |          0.666667 |           0.666667 |          1.000000 |              0.777778 |
|         2 |            0.629630 |          0.777778 |           0.555556 |          0.666667 |              0.666667 |

Consistency Scores

| subjectid | overall_proportion | small_proportion | medium_proportion | large_proportion | impute_method |
|----------:|-------------------:|-----------------:|------------------:|-----------------:|:--------------|
|         1 |           0.740741 |         0.666667 |          0.666667 |         0.888889 | none          |
|         2 |           0.592593 |         0.555556 |          0.555556 |         0.666667 | none          |

Proportions

##### Missing data

``` r
## normal scoring of data with missings with no imputation
tbl2 <- score_mcq27(fake_data_missing)
```

| subjectid | overall_k |  small_k | medium_k |  large_k | geomean_k |
|----------:|----------:|---------:|---------:|---------:|----------:|
|         1 |        NA | 0.000158 | 0.000158 |       NA |        NA |
|         2 |        NA |       NA |       NA | 0.000158 |        NA |

k Values

| subjectid | overall_consistency | small_consistency | medium_consistency | large_consistency | composite_consistency |
|----------:|--------------------:|------------------:|-------------------:|------------------:|----------------------:|
|         1 |                  NA |          0.666667 |           0.666667 |                NA |                    NA |
|         2 |                  NA |                NA |                 NA |          0.666667 |                    NA |

Consistency Scores

| subjectid | overall_proportion | small_proportion | medium_proportion | large_proportion | impute_method |
|----------:|-------------------:|-----------------:|------------------:|-----------------:|:--------------|
|         1 |                 NA |         0.666667 |          0.666667 |               NA | none          |
|         2 |                 NA |               NA |                NA |         0.666667 | none          |

Proportions

#### GGM imputation

This approach (Group Geometric Mean) “…calculates the composite k when
at least one of the three amount set ks is fully available” ([Yeh et al,
2023](https://doi.org/10.1371/journal.pone.0292258))

``` r
tbl3 <- score_mcq27(fake_data_missing, impute_method = "GGM")
```

| subjectid | overall_k |  small_k | medium_k |  large_k | geomean_k |
|----------:|----------:|---------:|---------:|---------:|----------:|
|         1 |        NA | 0.000158 | 0.000158 |       NA |  0.000158 |
|         2 |        NA |       NA |       NA | 0.000158 |  0.000158 |

k Values

| subjectid | overall_consistency | small_consistency | medium_consistency | large_consistency | composite_consistency |
|----------:|--------------------:|------------------:|-------------------:|------------------:|----------------------:|
|         1 |                  NA |          0.666667 |           0.666667 |                NA |                    NA |
|         2 |                  NA |                NA |                 NA |          0.666667 |                    NA |

Consistency Scores

| subjectid | overall_proportion | small_proportion | medium_proportion | large_proportion | impute_method |
|----------:|-------------------:|-----------------:|------------------:|-----------------:|:--------------|
|         1 |                 NA |         0.666667 |          0.666667 |               NA | GGM           |
|         2 |                 NA |               NA |                NA |         0.666667 | GGM           |

Proportions

#### INN imputation (no random component)

This approach (Item Nearest Neighbor) “…replaces the missing value with
the congruent non-missing responses to the items corresponding to the
same k value” ([Yeh et al,
2023](https://doi.org/10.1371/journal.pone.0292258))

``` r
tbl4 <- score_mcq27(fake_data_missing, impute_method = "INN")
```

| subjectid | overall_k |  small_k | medium_k |  large_k | geomean_k |
|----------:|----------:|---------:|---------:|---------:|----------:|
|         1 |  0.000158 | 0.000158 | 0.000158 | 0.000251 |  0.000185 |
|         2 |        NA |       NA | 0.063154 | 0.000158 |        NA |

k Values

| subjectid | overall_consistency | small_consistency | medium_consistency | large_consistency | composite_consistency |
|----------:|--------------------:|------------------:|-------------------:|------------------:|----------------------:|
|         1 |            0.740741 |          0.666667 |           0.666667 |          1.000000 |              0.777778 |
|         2 |                  NA |                NA |           0.666667 |          0.666667 |                    NA |

Consistency Scores

| subjectid | overall_proportion | small_proportion | medium_proportion | large_proportion | impute_method |
|----------:|-------------------:|-----------------:|------------------:|-----------------:|:--------------|
|         1 |           0.740741 |         0.666667 |          0.666667 |         0.888889 | INN           |
|         2 |                 NA |               NA |          0.444444 |         0.666667 | INN           |

Proportions

#### INN imputation (with random component)

This approach (Item Nearest Neighbor with Random) “… is identical to
\[INN no random component\], except that when a missing response cannot
be resolved, this datum will be randomly replaced with 0 or 1,
corresponding to choosing immediate or delayed rewards, respectively”
([Yeh et al, 2023](https://doi.org/10.1371/journal.pone.0292258))

``` r
tbl5 <- score_mcq27(fake_data_missing, impute_method = "INN",
                    random = TRUE)
```

| subjectid | overall_k |  small_k | medium_k |  large_k | geomean_k |
|----------:|----------:|---------:|---------:|---------:|----------:|
|         1 |  0.000158 | 0.000158 | 0.000158 | 0.000251 |  0.000185 |
|         2 |  0.000251 | 0.001562 | 0.063154 | 0.000158 |  0.002500 |

k Values

| subjectid | overall_consistency | small_consistency | medium_consistency | large_consistency | composite_consistency |
|----------:|--------------------:|------------------:|-------------------:|------------------:|----------------------:|
|         1 |            0.740741 |          0.666667 |           0.666667 |          1.000000 |              0.777778 |
|         2 |            0.592593 |          0.777778 |           0.666667 |          0.666667 |              0.703704 |

Consistency Scores

| subjectid | overall_proportion | small_proportion | medium_proportion | large_proportion | impute_method   |
|----------:|-------------------:|-----------------:|------------------:|-----------------:|:----------------|
|         1 |           0.740741 |         0.666667 |          0.666667 |         0.888889 | INN with random |
|         2 |           0.555556 |         0.555556 |          0.444444 |         0.666667 | INN with random |

Proportions

##### Return a list

You can also return a list when INN imputation with random is specified.
This is helpful to see what values replaced the missings (`NA`s) in the
original dataset.

``` r
lst <- score_mcq27(fake_data_missing, impute_method = "INN",
                    random = TRUE, return_data = TRUE)
```

The scoring summary metric dataframe as before (access via
`...$results`):

| subjectid | overall_k |  small_k | medium_k |  large_k | geomean_k |
|----------:|----------:|---------:|---------:|---------:|----------:|
|         1 |  0.000158 | 0.000158 | 0.000158 | 0.000251 |  0.000185 |
|         2 |  0.000251 | 0.001562 | 0.063154 | 0.000158 |  0.002500 |

k Values

| subjectid | overall_consistency | small_consistency | medium_consistency | large_consistency | composite_consistency |
|----------:|--------------------:|------------------:|-------------------:|------------------:|----------------------:|
|         1 |            0.740741 |          0.666667 |           0.666667 |          1.000000 |              0.777778 |
|         2 |            0.555556 |          0.666667 |           0.666667 |          0.666667 |              0.666667 |

Consistency Scores

| subjectid | overall_proportion | small_proportion | medium_proportion | large_proportion | impute_method   |
|----------:|-------------------:|-----------------:|------------------:|-----------------:|:----------------|
|         1 |           0.740741 |         0.666667 |          0.666667 |         0.888889 | INN with random |
|         2 |           0.518519 |         0.444444 |          0.444444 |         0.666667 | INN with random |

Proportions

The original data and the new responses imputed (access via `...$data`):

| subjectid | questionid | response | newresponse |
|----------:|-----------:|---------:|------------:|
|         1 |          1 |        1 |           1 |
|         1 |          2 |       NA |           1 |
|         1 |          3 |        1 |           1 |
|         1 |          4 |        1 |           1 |
|         1 |          5 |        0 |           0 |
|         1 |          6 |        1 |           1 |
|         1 |          7 |        0 |           0 |
|         1 |          8 |        0 |           0 |
|         1 |          9 |        0 |           0 |
|         1 |         10 |        1 |           1 |
|         1 |         11 |        1 |           1 |
|         1 |         12 |        1 |           1 |
|         1 |         13 |        1 |           1 |
|         1 |         14 |        0 |           0 |
|         1 |         15 |       NA |           1 |
|         1 |         16 |        1 |           1 |
|         1 |         17 |        1 |           1 |
|         1 |         18 |        0 |           0 |
|         1 |         19 |        1 |           1 |
|         1 |         20 |        1 |           1 |
|         1 |         21 |        1 |           1 |
|         1 |         22 |        1 |           1 |
|         1 |         23 |        1 |           1 |
|         1 |         24 |        1 |           1 |
|         1 |         25 |        1 |           1 |
|         1 |         26 |        1 |           1 |
|         1 |         27 |        0 |           0 |
|         2 |          1 |        1 |           1 |
|         2 |          2 |        1 |           1 |
|         2 |          3 |        1 |           1 |
|         2 |          4 |        0 |           0 |
|         2 |          5 |        1 |           1 |
|         2 |          6 |        0 |           0 |
|         2 |          7 |        0 |           0 |
|         2 |          8 |        0 |           0 |
|         2 |          9 |        1 |           1 |
|         2 |         10 |        0 |           0 |
|         2 |         11 |       NA |           0 |
|         2 |         12 |        1 |           1 |
|         2 |         13 |        0 |           0 |
|         2 |         14 |        1 |           1 |
|         2 |         15 |        0 |           0 |
|         2 |         16 |       NA |           0 |
|         2 |         17 |        1 |           1 |
|         2 |         18 |        1 |           1 |
|         2 |         19 |        0 |           0 |
|         2 |         20 |        0 |           0 |
|         2 |         21 |        0 |           0 |
|         2 |         22 |       NA |           0 |
|         2 |         23 |        1 |           1 |
|         2 |         24 |        1 |           1 |
|         2 |         25 |        1 |           1 |
|         2 |         26 |        1 |           1 |
|         2 |         27 |        1 |           1 |

Original Data and Imputed Data

## Learn More About Functions

To learn more about a function and what arguments it takes, type “?” in
front of the function name.

``` r
?score_mcq27
```

# Recommended Readings

- Kaplan, B. A., Amlung, M., Reed, D. D., Jarmolowicz, D. P.,
  McKerchar, T. L., & Lemley, S. M. (2016). Automating scoring of delay
  discounting for the 21-and 27-item monetary choice questionnaires.
  *The Behavior Analyst, 39*, 293-304.
  <https://doi.org/10.1007/s40614-016-0070-9>

- Reed, D. D., Niileksela, C. R., & Kaplan, B. A. (2013). Behavioral
  economics: A tutorial for behavior analysts in practice. *Behavior
  Analysis in Practice, 6* (1), 34–54.
  <https://doi.org/10.1007/BF03391790>

- Kirby, K. N., Petry, N. M., & Bickel, W. K. (1999). Heroin addicts
  have higher discount rates for delayed rewards than non-drug-using
  controls. *Journal of Experimental Psychology: General, 128* (1),
  78-87. <https://doi.org/10.1037//0096-3445.128.1.78>

- Yeh, Y. H., Tegge, A. N., Freitas-Lemos, R., Myerson, J., Green, L., &
  Bickel, W. K. (2023). Discounting of delayed rewards: Missing data
  imputation for the 21-and 27-item monetary choice questionnaires.
  *PLOS ONE, 18* (10), e0292258.
  <https://doi.org/10.1371/journal.pone.0292258>

- Koffarnus, M. N., & Bickel, W. K. (2014). A 5-trial adjusting delay
  discounting task: accurate discount rates in less than one minute.
  *Experimental and Clinical Psychopharmacology, 22*(3), 222-228.
  <https://doi.org/10.1037/a0035973>
