# Code Clinic (February 2024)

Here is fake data to aid discussion on tidying data. It is a dataframe with the following columns: ID, steroid, dosage, start.date, end.date.

Questionnaire form: [https://forms.office.com/e/nhzqxQp1Mz](https://forms.office.com/e/nhzqxQp1Mz)

Some observations:

* [Linters](https://cran.r-project.org/web/packages/lintr/):

```R
Rscript -e 'lintr::lint("orig_Data_clean.R")' > orig_lint
Rscript -e 'lintr::lint("Data_clean.R")' > new_lint
```

* Don't be parsing dates with regexes, [lubridate](https://lubridate.tidyverse.org/) is your friend.

* [Fuzzy matching](https://cran.r-project.org/web/packages/stringdist/index.html)
 

