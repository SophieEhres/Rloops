#!/bin/R
#Merge Consensus peaks (RNH+NT)
setwd("/Users/ehresms/computational/rloop/merged_bed")

library(rtracklayer)
library(GenomicRanges)

files<-list.files(".")
names<-sapply(strsplit(files, split = "_"), `[`, 1)

rnase_files<-unique(c(grep(names, pattern = "RNH", value = TRUE), grep(names, pattern = "RNase", value = TRUE)))

for (name in unique(names)) {
  files<-grep(list.files("."), pattern = name, value = TRUE)
  
  peak_files <-grep(files, pattern = "forward", value = TRUE)
  peak_granges <- lapply(peak_files, import)
  peak_grangeslist <- GRangesList(peak_granges)
  peak_coverage <- coverage(peak_grangeslist)
  covered_ranges <- slice(peak_coverage, lower=2, rangesOnly=T)
  covered_granges <- GRanges(covered_ranges)
  #covered_final<-reduce(covered_granges, min.gapwidth=31)
  
  export(covered_granges, paste0("~/computational/rloop/merged_bed/consensus_peaks_", name, "_forward.bed"))
  
  peak_files<-grep(files, pattern = "reverse", value = TRUE)
  peak_granges<-lapply(peak_files, import)
  peak_grangeslist<-GRangesList(peak_granges)
  peak_coverage <- coverage(peak_grangeslist)
  covered_ranges <- slice(peak_coverage, lower=2, rangesOnly=T)
  covered_granges <- GRanges(covered_ranges)
  #covered_final<-reduce(covered_granges, min.gapwidth=31)
  
  export(covered_granges, paste0("~/computational/rloop/merged_bed/consensus_peaks_", name, "_reverse.bed")) }

