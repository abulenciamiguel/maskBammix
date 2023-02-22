#!/usr/bin/env Rscript


suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(stringr))


option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="csv file containing flagged positions", metavar="character"),
  make_option(c("-b", "--bed"), type="character", default="out.txt", 
              help="bed file containing primer pairs]", metavar="character")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);


if (is.null(opt$file) | is.null(opt$bed)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

getwd() |> print()


flag <- read.table(opt$file,
                   sep = ",", header = T)



flag$positions <- flag$positions |>
  str_replace_all("\\[",
                  "") |>
  str_replace_all("\\]",
                  "")


row_num <- 1:nrow(flag)

list_flag <- c()

for (i in row_num) {
  a <- read.table(text = as.character(flag$positions[i]),
                  sep = ",", header = F, fill = F)
  
  b <- as.numeric(a[1,]) |>
    c()
  
  
  list_flag <- append(list_flag, b)

}

list_flag_sorted <- list_flag |>
  sort()



primers <- read.table(opt$bed)

primers_sorted <- primers[order(primers$V2),]



primerPairs <- matrix(nrow = 0, ncol = 3) |>
  data.frame()

colnames(primerPairs) <- c("V1", "V2", "V3")

for (i in list_flag_sorted) {
  c <- primers[primers$V2 < i & i < primers$V3, ]

  primerPairs <- rbind(primerPairs, c)
}



primerPairs_uniq <- unique(primerPairs)

write.table(primerPairs_uniq, sep = "\t",
            file = "flag_primerPair.bed",
            row.names = F, col.names = F)



