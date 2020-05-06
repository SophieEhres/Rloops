library(DiffBind)
library(pheatmap)

outdir="/Users/ehresms/computational/rloop/analysis"
dir.create(outdir)

samples<-read.csv("/Users/ehresms/computational/Rloops/samples_rloops.csv", stringsAsFactors = FALSE)
samples$Peaks<-paste0("/Users/ehresms/computational/rloop/F_R_mergedbed/",samples$Peaks)

samples<-samples[-grep(samples$SampleID, pattern = "EMB10_IP_2_1"),]

rloop<-dba(sampleSheet = samples)
plot(rloop)
rloop_count<-dba.count(rloop)
plot(rloop_count)
rloop_analyze<-dba.analyze(rloop_count)
plot(rloop_analyze)


##Specific Contrast analysis
mask<-dba.mask(rloop_analyze, attribute = DBA_TISSUE, value = "EMB10")
rloop_contrast<-dba.contrast(rloop_analyze, categories = c(DBA_CONDITION, DBA_TISSUE), name1 = "EMB10:IP", name2= "EMB10:RNH")
rloop_analyze<-dba.analyze(rloop_contrast)

rloop_DB<-dba.report(rloop_analyze, contrast = 1)


dba.plotPCA(rloop_analyze, attributes = c(DBA_CONDITION, DBA_TISSUE)) #plot PCA for cell type and treatment
dba.plotHeatmap(rloop_analyze, attributes = c(DBA_CONDITION, DBA_TISSUE), contrast = 1) ##plot PCA (not ordered b/c names are repeated)
dba.plotBox(rloop_analyze, contrast = 5)  ##plot affinity binding
dba.plotVolcano(rloop_analyze, contrast = 1)

## Export bed file of results

rloop_report<-dba.report(rloop_analyze, contrast = 1, method = DBA_DESEQ2) ##all samples RNH/IP

df <- data.frame(seqnames=seqnames(rloop_report),
                 starts=start(rloop_report)-1,
                 ends=end(rloop_report),
                 names=c(rep(".", length(rloop_report))),
                 scores=c(rep(".", length(rloop_report))),
                 strands=strand(rloop_report))

write.table(df, file = paste0(outdir, "/dba_report_all_RNHvIP.bed"), quote=F, sep="\t", row.names=F, col.names=F)
