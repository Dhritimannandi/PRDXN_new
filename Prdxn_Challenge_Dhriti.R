
## Data fetching and EDA
getwd()
setwd("$HOME/ownloads/lending-club-loan-data")
list.files()
raw_data <- read.csv(file = "loan.csv", stringsAsFactors = F, header = T)
dim(raw_data)
getwd()
install.packages("tidyverse")
install.packages("ggthemes")
install.packages("corrplot")
install.packages("GGally")
install.packages("DT")
install.packages("caret")
install.packages("choroplethr")
install.packages("choroplethrMaps")
install.packages("DescTools")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("readr")
install.packages("validate")

ibrary(tidyverse)
library(ggthemes)
library(corrplot)
library(GGally)
library(DT)
library(caret)
library(choroplethr)
library(choroplethrMaps)
library(DescTools)
library(dplyr)
library(ggplot2)
library(readr)
library(pROC)

lapply(raw_data, class)


loan <- raw_data$loan_amnt

bins <- seq(0, 35000, by=5000)
hist_loan <- cut(loan, bins, dig.lab = 6L)
hist_loan <- transform(hist_loan)
ggplot(data = transform(hist_loan)) +
  aes(x = X_data) +
  geom_bar(fill = '#0c4c8a') +
  labs(title = 'Histogram for loan amount',
    x = 'Loan Amount ($)') +
  theme_linedraw()


loan_st <- raw_data$loan_status

transform(table(loan_st))
ggplot(data = transform(table(loan_st))) +
  aes(x = loan_st, weight = Freq) +
  geom_bar(fill = '#0c4c8a') +
  labs(title = 'Loan Status Distribution',
    x = 'Loan Status',
    y = 'Frequency') +
  theme_minimal()

orig_data <- raw_data 
raw_data$is_good <- "0"
raw_data$is_good[raw_data$loan_status == "Current"] <- "1"
raw_data$is_good[raw_data$loan_status == "Issued"] <- "1"
raw_data$is_good[raw_data$loan_status == "Fully Paid"] <- "1"

##Data validation

cf <- check_that(raw_data, loan_amnt >= funded_amnt, funded_amnt >= funded_amnt_inv, !is.null(raw_data$id), !is.null(raw_data$member_id), id > 0, member_id >0, 
      term %in% c('36 months', '60 months'), 
      addr_state %in% c("AZ","GA","IL","CA","OR","NC","TX","VA","MO","CT","UT","FL","NY","PA","MN","NJ","KY","OH","SC","RI",
      "LA","MA","WA","WI","AL","CO","KS","NV","AK","MD","WV","VT","MI","DC","SD","NH","AR","NM","MT","HI","WY","OK","DE","MS","TN","IA","NE","ID","IN","ME","ND"))

summary(cf)


## Plot for year and loan amount
##box plot 

sub_data <- raw_data[,c("loan_amnt", "issue_d", "is_good")]

ggplot(data = sub_data) +
  aes(x = issue_d, y = loan_amnt, color = is_good) +
  geom_boxplot(fill = '#0c4c8a') +
  theme_minimal()


## Bar plot 

ggplot(data = sub_data) +
  aes(x = issue_d, y = loan_amnt, color = is_good) +
  geom_boxplot(fill = '#0c4c8a') +
  theme_minimal()

## Plot for purpose and loan amount
## bar plot for purpose

  sub_data <- raw_data[,c("loan_amnt", "purpose", "is_good")]

  ggplot(data = sub_data) +
  aes(x = purpose, fill = is_good, weight = loan_amnt) +
  geom_bar() +
  theme_minimal()

 ##Box plot

 ggplot(data = sub_data) +
  aes(x = purpose, y = loan_amnt, fill = is_good) +
  geom_boxplot() +
  theme_minimal()


  ##Model Building

  cln_data <- raw_data[,c("loan_amnt" , "int_rate" , "grade" , "emp_length" , "home_ownership" , 
               "annual_inc" , "term", "is_good")]

  ## Removing NA and cleaning "home_ownership"

cln_data = cln_data %>%
        filter(!is.na(annual_inc) , 
               !(home_ownership %in% c('NONE' , 'ANY')) , 
               emp_length != 'n/a')


 ## Split data set 75:25
cln_data$is_good = as.numeric(cln_data$is_good)
idx = sample(dim(cln_data)[1] , 0.75*dim(cln_data)[1] , replace = F)
trainset = cln_data[idx , ]
testset = cln_data[-idx , ]

# Fit logistic regression
glm.model = glm(is_good ~ . , trainset , family = binomial(link = 'logit'))
summary(glm.model)

# Prediction on test set
preds = predict(glm.model , testset , type = 'response')

# Density of probabilities

ggplot(data.frame(preds) , aes(preds)) + 
geom_density(fill = 'lightblue' , alpha = 0.4) +
   labs(x = 'Estimated Probabilities on test set')



k = 0
accuracy = c()
sensitivity = c()
specificity = c()
for(i in seq(from = 0.01 , to = 0.5 , by = 0.01)){
        k = k + 1
        preds_binomial = ifelse(preds > i , 1 , 0)
        confmat = table(testset$is_good , preds_binomial)
        accuracy[k] = sum(diag(confmat)) / sum(confmat)
        sensitivity[k] = confmat[1 , 1] / sum(confmat[ , 1])
        specificity[k] = confmat[2 , 2] / sum(confmat[ , 2])
}

threshold = seq(from = 0.01 , to = 0.5 , by = 0.01)

data = data.frame(threshold , accuracy , sensitivity , specificity)
head(data)


# Plot
ggplot(gather(data , key = 'Metric' , value = 'Value' , 2:4) , 
       aes(x = threshold , y = Value , color = Metric)) + 
        geom_line(size = 1.5)

preds.for.30 = ifelse(preds > 0.3 , 1 , 0)
confusion_matrix_30 = table(Predicted = preds.for.30 , Actual = testset$loan_outcome)
confusion_matrix_30

# Plot ROC curve
plot.roc(testset$is_good , preds , main = "Confidence interval of a threshold" , percent = TRUE , 
         ci = TRUE , of = "thresholds" , thresholds = "best" , print.thres = "best" , col = 'blue')




