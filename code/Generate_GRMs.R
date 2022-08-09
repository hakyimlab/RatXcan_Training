library(tidyverse)
load("/Users/sabrinami/Data-From-Abe-Palmer-Lab/Rdata/genoGex.RData")
"%&%" = function(a,b) paste(a,b,sep="")


pheno.dir <- "/Users/sabrinami/Github/Rat_Genomics_Paper_Pipeline/GEMMA/Ac/phenotype_files/"
ge.dir <- "/Users/sabrinami/Github/Rat_Genomics_Paper_Pipeline/GEMMA/Ac/genotype_files/"
grm.dir <- "/Users/sabrinami/Github/Rat_Genomics_Paper_Pipeline/GEMMA/Ac/output/"
bim.dir <- "/Users/sabrinami/Github/Rat_Genomics_Paper_Pipeline/data/bimbam/"
#Read in bimbam file
bimfile <- bim.dir %&% "Ac_bimbam" ###get SNP position information###

bim <- read.table(bimfile)
ensidlist <- gexAc$EnsemblGeneID
setwd("/Users/sabrinami/Github/Rat_Genomics_Paper_Pipeline/GEMMA/Ac/")
for(i in 1:length(ensidlist)){
  cat(i,"/",length(ensidlist),"\n")
  gene <- ensidlist[i]
  geneinfo <- gtf[match(gene, gtf$Gene),]
  chr <- geneinfo[1]
  c <- chr$Chr
  start <- geneinfo$Start - 1e6 ### 1Mb lower bound for cis-eQTLS
  end <- geneinfo$End + 1e6 ### 1Mb upper bound for cis-eQTLs
  chrsnps <- subset(bim, bim[,1]==c) ### pull snps on same chr
  cissnps <- subset(chrsnps,chrsnps[,2]>=start & chrsnps[,2]<=end) ### pull cis-SNP info
  snplist <- cissnps[,3:ncol(cissnps)]
  write.table(snplist, file= ge.dir %&% "tmp.Ac.geno" %&% gene, quote=F,col.names=F,row.names=F)
  geneexp <- cbind(as.numeric(gexAc[i,-1]))
  write.table(geneexp, file= pheno.dir %&% "tmp.pheno." %&% gene, col.names=F, row.names = F, quote=F) #output pheno for gemma
  runGEMMAgrm <- "gemma -g " %&%  ge.dir %&% "tmp.Ac.geno" %&% gene %&% " -p " %&% pheno.dir %&% "tmp.pheno." %&%  gene  %&%  " -gk -o /grm_Ac_" %&% gene
  system(runGEMMAgrm)

}

