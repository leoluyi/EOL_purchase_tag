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
  filter(!grepl("扣抵|抽獎|兌領|贈|塑膠袋|折價", item_name))
# save(data, file = "data_all.Rdata")
# load("data_all.Rdata")
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
par(family="STHeiti")
library(Cairo)
CairoFonts(regular = "STHeiti", bold = "STHeiti")
CairoPNG("result/arules_result/rules_result.png", 1000, 1000)
plot(rules, method="graph")
dev.off()

## plot 2
subrules2 <- head(sort(rules, by="lift"), 30)
CairoFonts(regular = "STHeiti",
           bold = "STHeiti")
CairoPNG("result/arules_result/rules_result_top30.png", 800, 800)
plot(subrules2, method="graph", control=list(type="itemsets"))
dev.off()

