# German-Credit-Data-Analysis

Business Case:
Predicting customers with good and bad credit to issue credit cards:
  - Stratified sampling is done on the data with a SplitRatio of 0.8
  - Logistic Regression is run on the binomial good_bad (indicating 1 for good and 0 for bad) and it is checked with variables that show good p-values and lower median deviances.
  - A scatter plot is created to understand the correlation between age of customer and amount on account. It is observed that they are not homoschedastic and so to analyze further quantile regression is run. It is observed that older customers have positive relation with amount.
  - Decision Tree is created where it shows age as an insignificant variable differing from the results on the logistic regression.
  - Lift and Gains Chart is created to observe the difference in performance betweeen the Logistic Regression and the Decision Tree.
  

