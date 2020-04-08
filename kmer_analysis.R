setwd("~/computational/rloop/kmers")
library(stringr, stringi)

kmer=7

files<-list.files(".", pattern = ".table")
files<-sort(files, decreasing = FALSE)

kmer_table<-matrix(nrow=4^kmer, ncol = 1)
kmer_table<-as.data.frame(kmer_table)

n=1

for (i in 1:length(files)) {
  
  
  table<-read.table(files[i], row.names = 1)
 
  name<- as.vector(str_split(files[i], pattern = "_")[[1]][2])
  name<-as.vector(str_split(name, pattern = "[.]")[[1]][6])
  colnames(table)<-paste0("kmercount_", name)
  
  if (nrow(table)==nrow(kmer_table) && n == 1) {
    row.names(kmer_table)<-row.names(table)
    kmer_table[nrow(kmer_table)+1,]<-"000"
    n=2
  }
  
  
  assign(paste0(name, "_table"), table)
  
  
  if (nrow(table)==nrow(kmer_table)) {
    kmer_table<-merge.data.frame(kmer_table, table, by = "row.names", all.x = TRUE )
    row.names(kmer_table)<-kmer_table$Row.names
    kmer_table[,"Row.names"]<-NULL
  } else {
    kmer_table<-merge.data.frame(kmer_table, table, by = "row.names", all.x = TRUE )
    row.names(kmer_table)<-kmer_table$Row.names
    kmer_table[,"Row.names"]<-NULL
  }

  
  
}
kmer_table$V1<-NULL
kmer_table[is.na(kmer_table)]<-0

fisher_table<-fisher.test(kmer_table, simulate.p.value = TRUE)
