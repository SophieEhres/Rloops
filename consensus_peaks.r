#!/bin/R
#Merge Consensus peaks (RNH+NT)
wd<-getwd()

setwd("/Users/ehresms/computational/rloop/merged_bed")
con_dir<-"/Users/ehresms/computational/rloop/consensus_bed"
dir.create(con_dir)

library(rtracklayer)
library(GenomicRanges)

files<-list.files(".")
names<-unique(sapply(strsplit(files, split = "-"), `[`, 1))

for (name in names) {
  files<-grep(list.files("."), pattern = name, value = TRUE)
  
  peak_files<-grep(files, pattern = "forward", value = TRUE)
  peak_granges<-lapply(peak_files, import)
  peak_grangeslist<-GRangesList(peak_granges)
  peak_coverage <- coverage(peak_grangeslist)
  covered_ranges <- slice(peak_coverage, lower=2, rangesOnly=T)
  covered_granges <- GRanges(covered_ranges)
  #covered_final<-reduce(covered_granges, min.gapwidth=31)
  
  export(covered_granges, paste0(con_dir,"/consensuspeaks_", name, "_forward.bed"))
  
  peak_files<-grep(files, pattern = "reverse", value = TRUE)
  peak_granges<-lapply(peak_files, import)
  peak_grangeslist<-GRangesList(peak_granges)
  peak_coverage <- coverage(peak_grangeslist)
  covered_ranges <- slice(peak_coverage, lower=2, rangesOnly=T)
  covered_granges <- GRanges(covered_ranges)
  #covered_final<-reduce(covered_granges, min.gapwidth=31)
  
  export(covered_granges, paste0(con_dir,"/consensuspeaks_", name, "_reverse.bed")) }



files<-list.files(".")

peak_files<-grep(files, pattern = "forward", value = TRUE)
peak_granges<-lapply(peak_files, import)
peak_grangeslist<-GRangesList(peak_granges)
peak_coverage <- coverage(peak_grangeslist)
covered_ranges <- slice(peak_coverage, lower=2, rangesOnly=T)
covered_granges <- GRanges(covered_ranges)
#covered_final<-reduce(covered_granges, min.gapwidth=31)

export(covered_granges, paste0(con_dir,"/consensuspeaks_all", "_forward.bed"))

peak_files<-grep(files, pattern = "reverse", value = TRUE)
peak_granges<-lapply(peak_files, import)
peak_grangeslist<-GRangesList(peak_granges)
peak_coverage <- coverage(peak_grangeslist)
covered_ranges <- slice(peak_coverage, lower=2, rangesOnly=T)
covered_granges <- GRanges(covered_ranges)
#covered_final<-reduce(covered_granges, min.gapwidth=31)

export(covered_granges, paste0(con_dir,"/consensuspeaks_", "all_reverse.bed")) 

setwd(wd)
