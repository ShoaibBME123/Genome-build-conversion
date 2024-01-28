library(stringr)
library(rutils)
library(data.table)
hg38_path <- system.file("testdata", "hg38ToHg19.over.chain", package = "rutils", mustWork = TRUE)
infiles <- dir(pattern='\\.snplist$')
change.files <- function(file){
  data <- read.table(file)
  data <- as.data.frame(str_split_fixed(data$V1,":",4)) 
  colnames(data)[1] <- 'CHR'
  colnames(data)[2] <- 'BP_hg38'
  colnames(data)[3] <- 'A1'
  colnames(data)[4] <- 'A2'
  data$hg38.Pos <- data$BP_hg38
  converted <-
    liftover_coord(
      df = data %>%
        dplyr::select(BP = BP_hg38,hg38.Pos, CHR, A1, A2),
      path_to_chain = hg38_path)
  colnames(converted)[2] <- 'hg19.Pos'
  write.table(converted, quote=FALSE, sep='\t', row.names=FALSE,col.names=TRUE, sub("\\.snplist$","-converted.txt", file))
}
lapply(infiles , change.files)
