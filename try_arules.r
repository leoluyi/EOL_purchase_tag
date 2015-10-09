library(readxl)
library(dplyr)
library(arules)
library(arulesViz)

# read data -----------------------------------------------------------------

data_all <- readxl::read_excel("data/all_data.xlsx",
                               col_types = rep("text", 18))
data <- data_all %>%
  mutate(date = gsub("/", "_", date)) %>%
  mutate(tid = paste(invoice, date), sep="_") %>%
  select(tid, item_name)

data <- data %>%
  filter(!grepl("扣抵|抽獎|兌領|贈|塑膠袋", item_name))

# arules ------------------------------------------------------------------

## prepare data
trans_list <- split(data[,"item_name"][[1]], data[,"tid"][[1]]) # split to list
trans_list <- lapply(trans_list, unique)  # unique items
trans <- as(trans_list, "transactions")
# summary(trans)

## arules
rules <- apriori(trans,
                 parameter = list(supp = 0.0002, conf = 0.5))
summary(rules)
inspect(head(sort(rules, by ="lift"), 10))

## plot
library(Cairo)
par(family='STHeiti')
CairoPNG("result/arules_result/rules_result.png", 1000, 1000)
plot(rules, method="graph")
dev.off()

## plot 2
subrules2 <- head(sort(rules, by="lift"), 30)
CairoPNG("result/arules_result/rules_result_top30.png", 1000, 1000)
plot(subrules2, method="graph", control=list(type="itemsets"))
