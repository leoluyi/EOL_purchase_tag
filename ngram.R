
# ngram -------------------------------------------------------------------

library(RWeka)
gram <- NGramTokenizer(paste0(item_unique_wo_unit, collapse = " "), Weka_control(min = 2, max = 5, delimiters = ""))
tbl_df(as.data.frame(table(gram))) %>% arrange(-Freq) %>% filter(Freq > 3 & Freq < 15)
