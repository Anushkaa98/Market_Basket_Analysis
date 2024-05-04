# Ensure required packages are installed and loaded
if (!require("arules")) install.packages("arules")
if (!require("arulesViz")) install.packages("arulesViz")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("readxl")) install.packages("readxl")
if (!require("knitr")) install.packages("knitr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("lubridate")) install.packages("lubridate")
if (!require("dplyr")) install.packages("dplyr")

library(arules)
library(arulesViz)
library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(dplyr)

# Read the dataset from an Excel file
retail_data <- read_excel("Online Retail.xlsx")

# Remove rows with incomplete data
cleaned_retail_data <- retail_data[complete.cases(retail_data), ]

# Convert the 'Description' and 'Country' columns to factor types
factorized_retail_data <- cleaned_retail_data %>%
  mutate(Description = as.factor(Description),
         Country = as.factor(Country))

# Add date and time columns derived from 'InvoiceDate'
date_time_enhanced_data <- factorized_retail_data %>%
  mutate(TransactionDate = as.Date(InvoiceDate),
         TransactionTime = format(InvoiceDate, "%H:%M:%S"))

# Convert 'InvoiceNo' to numeric after checking for non-numeric entries
date_time_enhanced_data$InvoiceNoNumeric <- as.numeric(as.character(date_time_enhanced_data$InvoiceNo))

# Provide an overview of the cleaned and enhanced data
glimpse(date_time_enhanced_data)

# Aggregate transaction data by 'InvoiceNo' and 'TransactionDate'
transaction_aggregate <- ddply(date_time_enhanced_data, c("InvoiceNoNumeric", "TransactionDate"), function(df) {
  paste(df$Description, collapse = ",")
})

# Rename columns for clarity
colnames(transaction_aggregate) <- c("CompiledItems")

# Output the processed transaction data to a CSV file
write.csv(transaction_aggregate, "market_basket_transactions.csv", quote = FALSE, row.names = FALSE)

# Read the transaction data for analysis
basket_transactions <- read.transactions('market_basket_transactions.csv', format = 'basket', sep=',')

# Visualize item frequency for the top 20 items
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer")
  library(RColorBrewer)
}
itemFrequencyPlot(basket_transactions, topN = 20, type = "absolute", col = brewer.pal(8, 'Pastel2'), main = "Top Item Frequency: Absolute")
itemFrequencyPlot(basket_transactions, topN = 20, type = "relative", col = brewer.pal(8, 'Pastel2'), main = "Top Item Frequency: Relative")

# Execute Apriori Algorithm to discover association rules
initial_rules <- apriori(basket_transactions, parameter = list(supp = 0.001, conf = 0.8, maxlen = 10))
inspect(initial_rules[1:10])

# Generate concise rules and remove redundant ones
concise_rules <- apriori(basket_transactions, parameter = list(supp = 0.001, conf = 0.8, maxlen = 3))
redundant_rule_indices <- which(colSums(is.subset(initial_rules, concise_rules)) > 1)
filtered_rules <- initial_rules[-redundant_rule_indices]

# Analyze and visualize rules involving the item 'METAL'
metal_related_rules <- apriori(basket_transactions, parameter = list(supp = 0.001, conf = 0.8), appearance = list(default = "lhs", rhs = "METAL"))
plot(metal_related_rules)

# Filter and visualize rules with high confidence
high_confidence_rules <- filtered_rules[quality(filtered_rules)$confidence > 0.4]
plot(high_confidence_rules, method = "graph", engine = "htmlwidget")

# Focus on the top 20 rules by lift
top_lift_rules <- head(high_confidence_rules, n = 20, by = "lift")
plot(top_lift_rules, method = "paracoord")
