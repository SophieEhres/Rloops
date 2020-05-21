setwd("/Users/ehresms/computational")
dir0 = "/Users/ehresms/computational"
bamdir = paste0(dir0, "/rloop/align")
countdir = paste0(dir0, "/rloop/counts")
gtfdir = paste0(dir0, "/rloop/consensus_gtf")

dir.create(countdir, showWarnings = FALSE)

files=list.files(path = bamdir, full.names = TRUE)
file=files[1]

for (file in files) {
  print(paste0("counting", file))
  
  if (grep(file, pattern = "6")) {
    
    annotation = grep(grep(grep(list.files(path = gtfdir, full.names = TRUE), 
                                pattern = "10", value = TRUE), 
                           pattern = "both", value = TRUE), 
                      pattern = "annotation", value = TRUE)
    print(paste0("annotation is ", annotation))
    
    output=featureCounts(files = file, annot.ext = annotation, isGTFAnnotationFile = TRUE, 
                  strandSpecific = 1, isPairedEnd = TRUE, nthreads = 16, tmpDir = ".",
                  autosort = TRUE)
    
    write.table(output, file = paste0("./output_", file, ".txt")
  }
}


annotation<-
featureCounts(annot.ext = "")