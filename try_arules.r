library(readxl)
library(dplyr)
library(arules)
library(arulesViz)

# read data -----------------------------------------------------------------

# data_pxmart_all <- readxl::read_excel("data/all_data.xlsx",
#                                sheet = 1,
#                                col_types = rep("text", 18))
# data_pxmart <- data_pxmart__all %>%
#   mutate(date = gsub("/", "_", date)) %>%
#   mutate(tid = paste0(invoice, date, collaplse="_")) %>%
#   select(tid, item_name)
#
# data_pxmart <- data_pxmart %>%
#   filter(!grepl("扣抵|抽獎|兌領|贈|塑膠袋|折價", item_name))


# save data ---------------------------------------------------------------

# save(data_pxmart, file = "data_pxmart.Rdata")
load("data_pxmart.Rdata")


# arules ------------------------------------------------------------------

## prepare data
trans_list <- split(data_pxmart[,"item_name"], data_pxmart[,"tid"]) # split to list
trans_list <- lapply(trans_list, unique)  # unique items
# sample(trans_list, 20)
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
CairoPNG("result/arules_result/rules_result.png", 1600, 1600)
plot(rules, method="graph")
dev.off()

## plot 2
subrules2 <- head(sort(rules, by="lift"), 30)
CairoFonts(regular = "STHeiti",
           bold = "STHeiti")
CairoPNG("result/arules_result/rules_result_top30.png", 1000, 1000)
plot(subrules2, method="graph", control=list(type="itemsets"))
dev.off()

