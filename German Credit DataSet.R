library(readxl)
mydf <- read_excel("german credit card.xls")

# Data Cleaning 
mydf$purpose_num <- as.numeric(gsub("X","", mydf$purpose))
mydf$good_bad <- gsub("good","1", mydf$good_bad)
mydf$good_bad <- gsub("bad","0", mydf$good_bad)  
mydf$good_bad <- as.numeric(mydf$good_bad)

# Stratified Sampling with SplitRatio of 0.8
library(caTools) 
german_credit <- mydf
train_index <- sample.split(german_credit$good_bad, SplitRatio = 0.8)
train <- german_credit[train_index,]
test <- german_credit[!train_index,]

# Logistic Regression
ger_logit <- glm(good_bad ~ age+savings+duration+checking, data = mydf, family = "binomial")
summary(ger_logit)

predict(ger_logit, test, type="response")

# Check best model by looking if it has smaller median deviance
my_logit <- glm(good_bad ~ checking+history+savings, data=mydf, family="binomial")
summary(my_logit)

# Scatter Plot
plot(amount~age, data = mydf)
my_linear <- lm(amount~age, data = mydf)
summary(my_linear)

# Since the scatter plot doesn't show linear patterns for linear regression, 
# we can explore more using Quantile Regression

# Quantile Regression
library(quantreg)
rq_model <- rq(amount~age, data = mydf, tau = 0.25)
summary(rq_model)

rq_model <- rq(amount~age, data = mydf, tau = 0.5)
summary(rq_model)

rq_model <- rq(amount~age, data = mydf, tau = 0.75)
summary(rq_model)

# Decision Tree
library(rpart)
library(rpart.plot)

ger_tree <- rpart(good_bad~age+amount+duration+checking, data=mydf, method ="class",cp=0.013)
rpart.plot(ger_tree,extra=1,type=1)

# Performance
predict_tree <- predict(ger_tree, mydf, type = "prob")
predict_logit <- predict(ger_logit, mydf, type = "response")

library(ROCR)
pred_val_tree <- prediction(predict_tree[,2], mydf$good_bad)
pred_val_logit <- prediction(predict_logit, mydf$good_bad)

# Lift and Gains Chart
perf_tree <- performance(pred_val_tree, "tpr", "fpr") 
perf_logit <- performance(pred_val_logit, "tpr", "fpr")

plot(perf_logit, col="blue")
plot(perf_tree, col="black", add=T)

# Visualizations with Plotly
library(plotly)
t <- plot_ly(data=mydf, x =~age, y=~good_bad)
t

p <- ggplot(mydf, aes(x=age, y=good_bad))+
  geom_jitter(aes(color=checking))
ggplotly(p)

z <- plot_ly(data=mydf, x=~duration, y=~age, z=~amount,color=~good_bad)
z

