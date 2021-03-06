####ANALYSIS

#########################################################################################
##HAPLOID SEQUENCE DATA
#########################################################################################
#require(ape)
library(ape)

# Check that Rtools can be used
# Sys.getenv("PATH")

# install.packages("sp")
# require(adegenet)
# adegenet from Thibaut's github
# find_rtools()
library(devtools)
install_github("thibautjombart/adegenet")
library(adegenet)

# install.packages("stringi")

# Eric's strataGdevel
  # install_github("ericarcher/swfscMisc/swfscMisc")

# if (!require('devtools')) install.packages('devtools')
# devtools::install_github('ericarcher/strataG/strataG')

#Restart R
library(strataG)
library(swfscMisc)

library(poppr)
library(MASS)

# Need Thibaut's apex from repository
  # library(devtools)
  # install_github("thibautjombart/apex")
library(apex)

##Empirical and simulated data ('x') should be in DNAbin format, and a metadata df should
##also be created (i.e. 'strata' three columns: id.col(indivID), strata.col(pops), locus.col(haps))
##depending on required summary stats, these files will be coverted to either strataG gtype and/or
###adegenet genind and then to hierfstat format

#In test.runSim: error
          #Error in params@sim.func(params) : fastsimcoal exited with error 127
          #In addition: Warning message:
          #running command 'fsc252.exe -i testRun.1.1.par -n 1  ' had status 127
# Can't find in my PATH system variable - where is it?! it's in the path, i swear!
# I did change the name, maybe it doesn't match?
# Had to add the path to the fastsimcoal folder

#testRunFastsimcoal.R error:

# ---- Run replicates ----
> test.params <- runSim(test.params)
title.not.null at.least.1.rep
TRUE           TRUE
title.not.null at.least.1.rep
TRUE           TRUE
Show Traceback

Rerun with Debug
Error in rbind(params@sim.check.func(params), gen.scenario.check(params)) :
  attempt to apply non-function


#################################  format rep.results from multidna to gtypes #########
# load test multidna.rdata into global environment
class(rep.result)

# multidna, from apex
class(rep.result[[2]])
class(rep.result$dna.seqs)
inherits(rep.result, "multidna")

data(dolph.seqs)
strata <- dolph.strata$fine
names(strata) <- dolph.strata$ids
dloop <- sequence2gtypes(dolph.seqs, strata, seq.names = "dLoop")
dloop[,1,] #not list of DNAbins... only one locus

# sequence gtype example
params<- new("skeleSim.params")
params@rep.result <- dloop
params@analyses.requested<-c(Global=TRUE,Locus=TRUE,Pairwise=TRUE)
curr_scn<-1
curr_rep<-1
num_loci <- 1
num_reps <- 5
num_pops <- nStrata(dloop)

# multidna sequence example
data(woodmouse)
inherits(woodmouse, "DNAbin")
genes <- list(gene1=woodmouse[,1:500], gene2=woodmouse[,501:965])
x <- new("multidna", genes)
x.g <- sequence2gtypes(x)
strata(x.g) <- c("A", "B")
inherits(x.g, "gtypes")

params<- new("skeleSim.params")
params@analyses.requested<-c(Global=TRUE,Locus=TRUE,Pairwise=TRUE)
params@rep.result <- x.g
curr_scn<-1
curr_rep<-1
num_loci <- nLoc(x.g)
num_reps <- 5
num_pops <- nStrata(x.g)



##############################################################
genes <- rep.result$dna.seqs#the multidna object
names(genes@dna) <- paste("gene", 1:length(genes@dna))
id <- genes@labels
df <- data.frame(id = id, strata = rep.result[[1]])
gene.labels <- matrix(id, nrow = length(id), ncol = getNumLoci(rep.result[[2]]))
colnames(gene.labels) <- paste("gene", 1:ncol(gene.labels), sep = "_")
df <- cbind(df, gene.labels)
test.g <- df2gtypes(df, 1, sequences = genes)
summary(test.g)

# to test in skeleSim.funcs overall_stats
test.one <- results_gtype[,"gene_1",]

inherits(rep.result, "DNAbin")

#multidna object
# Run skeleSim.classes.R and skeleSim.funcs.R first
### multiDNA example
params<- new("skeleSim.params")
params@analyses.requested<-c(Global=TRUE,Locus=TRUE,Pairwise=TRUE)
params@rep.result <- rep.result
curr_scn<-1
curr_rep<-1
num_loci <- getNumLoci(rep.result$dna.seqs)
num_reps <- 5
num_pops <- nStrata(test.g)


#### Test the multiDNA example in analysis_funcs


nLoc(test.g)
locNames(test.g)

length(genes)
rep.result
length(rep.result$dna.seqs@dna)

# where does this come from?
#length(seq.names)

# Where do I get params from?
#params@analysis.result <- rep.result
num_loci <- getNumLoci(rep.result[[2]])


## will get a gtypes object
data(dolph.msats)
data(dolph.strata)
msats.merge <- merge(dolph.strata[, c("ids", "fine")], dolph.msats, all.y = TRUE)
msats <- df2gtypes(msats.merge, ploidy = 2)

class(msats)
inherits(msats,"multidna")

inherits(msats,"gtypes")

# msats <- dolph.msats
alleleFreqs <- alleleFreqs(msats, by.strata = TRUE)
by.loc <- sapply(alleleFreqs, function(loc) {
  mat <- loc[, "freq", ]
  rowSums(apply(mat, 1, function(r) {
    result <- rep(FALSE, length(r))
    if(sum(r > 0) == 1) result[r > 0] <- TRUE
    result
  }))
})
rownames(by.loc) <- strataNames(msats)
perLocus <- colSums(by.loc) #this has the number of alleles that are private per locus
t(by.loc) #the rows will be have the private alleles for each population by locus

ls.1 <- 1:300
names(ls.1) <- 1:300
ls.2 <- 3:100
names(ls.2) <- 3:100
foo.1 <- list(ls.1,ls.2)
names(foo.1[[1]])
foo.2 <- c("gene1","gene2")
lapply(foo.2, function(x){
  lapply(foo.1, function(y){
    paste(x,names(y))
  })
})   #Ooops, want just first and first and second and second, not all combinations...

Map(function(x,y) paste(x, names(y)),
    foo.2,
    foo.1)

########### Locus testing

# multiDNA
if(inherits(params@rep.result,"multidna")){

  r.m <- lapply(locNames(results_gtype), function(l){
    nd_this_gene<-nucleotideDiversity(results_gtype[,l,]@sequences)
  })
  results.list.names <- Map(function(gene,names) paste(gene, names(names), sep="_"),
                        locNames(results_gtype),
                        r.m)
  results <- do.call(c,r.m)
  names(results) <- do.call(c,results.list.names)
  names(results) <- results.list.names
  analyses <- length(results)
}



nucleotideDiversity(results_gtype[,locNames(results_gtype)[1],])
nucleotideDiversity(msats)


setwd("C:/Users/deprengm/Dropbox/Hackathon/Datasets")
df <- read.fasta("name_checked_acanigror_CyB_JD.fasta")
str(df)

#DNAbin
class(df)

#Error: unable to find an inherited method for function 'concatenate' for 'DNAbin'
if(class(df) == "DNAbin"){
  df.genind <- multidna2genind(df)
  class(df.genind)
  df.gt <- genind2gtypes(df)
}

### July 13, 2015  ###########################################################
### sequence data, vector of pop assignments and DNAbin objects,
#   NO!: a list with population column and sequence ("hap") column data.frame, column name "strata" (one column)
#   value is a label associated with sequence in DNAbin object
### Yes: need to colapse sequence into haplotype, need vector
### Yes: list one element population assigments, other vector of sequences,
##        list(strata = pop.data[,1], dna.seq = as.DNAbin(dna.seq)) <- that's an apex, not DNAbin which is a class of a list of DNAbins

## then don't need to worry about genind objects, no conversions

#
# sequence data
# step one, convert to DNAbin? take DNAbin?

# data out of simulation will be the list,
####  1. vector of population assigments

# use pairwiseTest, strip character vectors, just numbers, add in the overall
# then know replicates for z dimension
# set array from number of populations, if pairwise + 1 for overall, and then
#   runs for simulation   <- from load params when you tell it number of pops


# Very slow - minutes!
pairwiseTest.out <- pairwiseTest(msats)
pairwiseTest.out$result

smsat <- summary(msats)
str(smsat)

# strataG uses this order to pick names, can use this to generate
# population 1v1, 1v2 ...
?combn
combn(1:3, 2)
combn(1:9, 2)

## each run of the simulation would produce a new matrix from
# such analayses as pairwiseTest to array
# No: xyzArray <- sapply(1:nrep, pairwiseTest.out, simplify = 'array')

foo <- combn(1:5, 2)
names <- paste(foo[,1], collapse = "v")

rnames <- c("overall", apply(foo, 2, function(x) paste(x, collapse = "v")))
rnames

#####################################################################
####      ROW NAMES
# for pairwise populations, take number of populations = 'npop'
npp <- combn(1:npop, 2)
names <- c("overall", apply(npp, 2, function(x) paste(x, collapse = "v")))

# for pairwise loci, take number of loci = nloc
npl <- combn(1:nloc, 2)
names <- c("overall", apply(npl, 2, function(x) paste(x, collapse = "v")))

# for simple populations
names <-  c("overall", 1:npop)

# for loci
names <- c("overall", 1:nloc)
#####################################################################
## to install from github: install_github("jgx65/hierfstat")  Jerome's
library(hierfstat)

# testing ones
analyses <- c("allel","Freq","prop")
nrep <- 5
scenario.results <- sapply(c("Global","Locus","Pairwise"), function(x) NULL)

params<- new("skeleSim.params")

params
#params@num.reps <- 1

## Make the array from the load params info
# nanalyze <- the number of analyses we'll do
npop <- 3 # npop <- the number of rows, pops or pairwise or loci plus overall
# nrep <- the number of replicates
# dimension names will come from the choice of pairwise, by
#   by population, by loci
population.by.loci <- array(0, dim = c(length(names), length(analyses), params@num.reps),
                            dimnames = list(names, analyses, 1:nrep))

## array for global - summary of loci for each population
overall.population <- array(0, dim = (length(names), length(analyses), params@num.reps))

## array for

## test making list of $Global, $Pops, $locus, $pws which each could hold list
# per scenario of analysis columns and sample rows

an.req <- c(Global = T, Pops = F, locus = T, pws = F)

for(x in names(which(an.req)))


####################################################################
# now take each run with all the analyses and put into one matrix (per replicate)

# first do multiDNA to gtypes and genind to gtypes
# params@analysis.result will be multidna
# example rep.result
rep.result
class(rep.result)
inherits(rep.result$dna.seqs, "DNAbin")
inherits(rep.result$dna.seqs, "multidna")
# A multidna with two genes
length(rep.result$dna.seqs@dna)

data(woodmouse)
genes <- list(gene1=woodmouse[,1:500], gene2=woodmouse[,501:965])
x <- new("multidna", genes)
x

length(x@dna)

# example dolphin
msats
str(locNames(msats))

class(msats)
# to test analysis_funcs
params@rep.sample <- msats

str(msats)
length(msats@loci)

#Subset is removed from strataG, instead use gtype[id, locus, strata] to subset
#lapply(locNames(msats), function(x){
#  gtypes_1 <- subset(msats, loci = x)
#  ovl <- overallTest(gtypes_1, nrep = 5, quietly = TRUE)
#})

# Run skeleSim.classes.R and skeleSim.funcs.R first
### genind example
params<- new("skeleSim.params")
params@analyses.requested<-c(Global=TRUE,Locus=TRUE,Pairwise=TRUE)
data(nancycats)
params@rep.result <- nancycats
curr_scn<-1
curr_rep<-1
num_loci <- nLoc(nancycats)
num_reps <- 5
num_pops <- nPop(nancycats)

#After genind2gtypes for results_gtype
nLoc(results_gtype)
nStrata(results_gtype)
nInd(results_gtype)
ploidy(results_gtype)
results_gtype[,"fca8",]

###################### troubleshooting
nancycats
g <- genind2gtypes(nancycats)
summary(g)

overallTest(g, nrep=10, num.cores=2)
overallTest(g[,"fca45",], nrep=10, num.cores=2)

nancycats.gtypes <- genind2gtypes(nancycats)
ovl.foo <- overallTest(nancycats.gtypes, stats="chi2", quietly = TRUE)
# pws.foo <- pairwiseTest(nancycats.gtypes)
pws.foo.chi <- pairwiseTest(nancycats.gtypes, stats="chi2")
overall.foo.fst <- overallTest(nancycats.gtypes, stats="fst", quietly = TRUE)
overall.foo.fst <- pairwiseTest(nancycats.gtypes, stats="fst", quietly = TRUE)


########### HERE ######### Need to collapse/concatenate lists
ovl.loc <- lapply(locNames(msats), function(x){
  gtypes_1 <- msats[,x,]  #[individuals, loci, strata]
  ovl <- overallTest(gtypes_1, nrep = 5, quietly = TRUE)
  ovl$result
})


ovl.out <- do.call(cbind, ovl.loc)

pnam <- c()
for(i in 1:length(colnames(global))){
  pnam <- c(pnam,paste(colnames(global)[i],"pval", sep = ""))
}
global.wide <- c(global[1,],global[2,])
names(global.wide) <- c(colnames(global),pnam)



overall_stats(msats)
################################
# for loop with returning container - the last line of the function, lapply always returns a list, sapply will simplify by end value

mat <- t(sapply(locNames(msats), function (l){
  gtypes_this_loc<-msats[,l,]
  overall_stats(gtypes_this_loc)
}))
###############################

scenario.results <- sapply(c("Global","Locus","Pairwise"), function(x) NULL)

#num_loci is known from the parameters gathered earlier

num_loci <- nLoc(msats)
num_reps <- 5
analyses <- names(mat[2,])
num_analyses <- length(analyses)

scenario.results[["Global"]][[curr_scn]] <- array(0, dim=c(num_loci,num_analyses,num_reps),
                                               dimnames = list(1:num_loci,analyses,1:num_reps))


which(locNames(msats) == locNames(msats)[2])
#mat[2,] <- 1:14

# example to test
class(rep.result$dna.seq)
rep.result$dna.seq
genes <- rep.result[[2]]
#genes is a list
class(genes)
names(genes@dna) <- paste("gene", 1:length(genes@dna))
id <- genes@labels
df <- data.frame(id = id, strata = rep.result$strata, hap = id)
class(df)
# errors now with designating sequences = genes
test.g <- df2gtypes(df, 1) #, sequences = genes
class(test.g) # multiDNA to gtypes

class(rep.result)
inherits(rep.result, "DNAbin")
inherits(rep.result$dna.seq, "multidna")
inherits(rep.result, "gtypes")
# to test analysis_funcs
params@rep.result <- rep.result


### after creating Global, Locus, and Pairwise


# Why would we need this? either use the gtypes created at the start or convert to genind, right?
#initialize arrays
if (inherits(params@analysis.results,"multidna"))

  if(params@analyses.requested["Global"]){

    num_loci <- nLoc(results_gtype)

    ######## START HERE: lapply not working, fix it!
    results.matrix <- t(lapply(locNames(results_gtype), function (l){
      gtypes_this_loc<-results_gtype[,l,]
      overall_stats(gtypes_this_loc)
    }))
    analyses <- colnames(results.matrix)
    num_analyses <- length(analyses)

    if(is.null(params@analysis.results[["Global"]][[curr_scn]])){
      params@analysis.results[["Global"]][[curr_scn]] <- array(0, dim=c(num_loci,num_analyses,num_reps),
                                                               dimnames = list(1:num_loci,analyses,1:num_reps))
    }



# http://www.ncbi.nlm.nih.gov/pmc/articles/PMC1894623/
# need apex multiDNA object

### Global, Genotypes
ovl <- overallTest(msats, nrep = 5, stat.list = statList("chi2"), quietly = TRUE)
t(ovl$result)
# need new columns with p-value for each
global <- t(ovl$result)
as.vector(t(ovl$result)) # by row to a vector

# Eric's example
data(woodmouse)
class(woodmouse)
genes <- list(gene1=woodmouse[,1:500], gene2=woodmouse[,501:965])
x <- new("multidna", genes)
x.g <- sequence2gtypes(x)
strata(x.g) <- c("A", "B")

# to test analysis_funcs
params@rep.sample <- x.g

class(x.g)
inherits(x.g,"genind")
inherits(x.g,"DNAbin")
inherits(x.g,"gtypes")
inherits(x.g,"multidna")


#which is population and which are genes for strata? So pairwise should be done between
# gene.A and gene.B or for the two seperately among populations?

foo <- overallTest(msats, nrep = 5, statList("chi2"), quietly = TRUE)
(foo$result)

# for a multiDNA object, need to add row for results of second gene
  ovl.multi <- sapply(locNames(x.g), function(n) {
    ovl.raw <- overallTest(x.g[,n,], nrep=5, stat.list=statList("chi2"), quietly = TRUE)
    ovl.raw$result
  })

t(ovl.multi)

#
ovl.multi <- sapply(locNames(x.g), function(n) {
  ovl.raw <- overallTest(x.g[,n,], nrep=5, stat.list=statList("chi2"), quietly = TRUE)
  ovl.raw$result
})



# vs.
ovl.2 <- overallTest(x.g[,"gene1",], nrep = 5, stat.list = statList("chi2"), quietly = TRUE)
t(ovl.2$result)
# need new columns with p-value for each
global <- t(ovl.2$result)


rownames(ovl.multi)
rownames(ovl.2$result)

ovl.2$result[which(rownames(ovl.2$result),"Chi2"),]

#
pnam <- c()
for(i in 1:length(rownames(ovl$result))){
    pnam <- c(pnam,rownames(ovl$result)[i],paste(rownames(ovl$result)[i],"pval", sep = ""))
}
#global.wide <- c(ovl$result[1,],ovl$result[2,])
global.wide <- c(global[1,],global[2,])
names(global.wide) <- c(rownames(ovl$result),pnam)

ovl <- overallTest(test.g, nrep = 5, stat.list = statList("chi2"), quetly = TRUE)
t(ovl$result)
# need new columns with p-value for each
global <- t(ovl$result)
pnam <- c()
for(i in 1:length(colnames(global))){
  pnam <- c(pnam,paste(colnames(global)[i],"pval", sep = ""))
}
global.wide <- c(global[1,],global[2,])
names(global.wide) <- c(colnames(global),pnam)


# Population, Genotypes
alfre <- alleleFreqs(msats, by.strata = TRUE)
# use rep.result to test
alfre <- alleleFreqs(test.g)  # can skip this
# may want an allele frequency spectrum, distirbution of these
#   made up 'neutral' alleles
#   if we do a 'pre summary' we lose this information -
#   option to write your own, you can save data
#   if rep.result is a list, anyone can add another
#     automate it so user can add any other
# list of frequency of allels per locus per population
# might take a long time, do we need that many columns?
str(alfre)
alfre$hap
length(alfre[[1]][,,1])
alfre[[1]][,,1] 3 first DNAbin in multidna freq and prop of alleles per locus
for(i in 1:length(alfre))

## remove chi2 but keep the p value
#  no.alleles, allelic.richness, obs.He, exp.He, theta, unique.alleles
smry <- summarizeLoci(msats, by.strata = TRUE)


library(reshape2)
melt.smry <- melt(smry[[1]])

smry.wide <- t(melt.smry[,3])
colnames(smry.wide) <- paste(melt.smry[,1],melt.smry[,2],sep="")


smry <- summarizeLoci(test.g, by.strata = TRUE)
colnames(summarizeLoci(msats))

########################################################################################
########################################################################################
########################################################################################
## Need to add if genes > 1 then {
# Pull analyses names from ...
smry.multi <- t(sapply(locNames(msats), function(n) {
  unname(summarizeLoci(msats[, n, ]))
}))

# extract column names and reformat multigene... wouldn't have without multiple loci...
multi.locus <- sapply(locNames(x.g), function(n) {
  summarizeLoci(x.g[,n,])
})

l.nam <- locNames(x.g)
c.nam <- colnames(summarizeLoci(x.g[,l.nam[1],]))

# formatting works but doesn't make sense to summarizeLoci over a sequence....
multi.t.locus <- t(multi.locus)
dimnames(multi.t.locus)[[2]] <- c.nam

# Can't remember now, I want a row per individual and a long vector of resutls... right?
dimnames(smry.multi)[[2]] <- colnames(summarizeLoci(msats))

# Why unname??
n <- locNames(msats)[1]
smry.multi <- sapply(locNames(msats), function(n) {
  summarizeLoci(msats[, n, ])
})



####
melt.smry <- melt(smry[[1]])
smry.wide <- t(melt.smry[,3])
colnames(smry.wide) <- paste(melt.smry[,1],melt.smry[,2],sep="")


### global, haplotype
ovl <- overall



### pairwise, haplotypes
# test data are: test.g and smsat
# x.g from multigene sapply example
# want as wide as there are alleles
# fairly slow:
pws <- pairwiseTest(msats, nrep = 5, stat.list = list(statGst, quietly = TRUE))
pws
pws[1]
test.y <- pws[[1]][-c(1:5)]
pws[[2]][-c(1:5)]
nrow(test.y)
length(pws[[1]][1])
rownames(test.y) <- as.matrix(pws[[1]][1])

#If a multigene example
#subset gtype with [ ,locus, ]
str(x.g)
locNames(x.g)
pws.multi <- sapply(locNames(x.g), function(g){
  gene_gtype <- x.g[,g,]
  pairwiseTest(gene_gtype, nrep =5, keep.null=TRUE)
})
#FST,PHIst
pws.multi[1]
pws.multi[2][[1]]$Chi2
str(pws.multi)
pws.multi$pair.mat

#
pws.out <- pws$result[-c(1:5)]
rownames(pws.out) <- as.matrix(pws[[1]][1])
pws.out

#multigene
pws.multi <- sapply(locNames(x.g), function(n) {
  pairwiseTest(x.g[, n, ], nrep = 5, stat.list = list(statGst, quietly = TRUE))
})

pws.multi.out <- pws.multi[[1]][-c(1:5)]
rownames(pws.multi.out) <- as.matrix(pws.multi[[1]][1])

# What happens to an example with one gene
data(woodmouse)
genes <- list(gene1=woodmouse[,1:500], gene2=woodmouse[,501:965])
x <- new("multidna", genes)
wood.g <- sequence2gtypes(x)
strata(wood.g) <- sample(c("A", "B"), nInd(wood.g), rep = TRUE)
wood.g
gene1 <- wood.g[, "gene1", ]
gene1.dnabin <- getSequences(sequences(gene1))
class(gene1.dnabin)

#genind create
#rep$sample will either be a list or a genind


#which is population and which are genes for strata? So pairwise should be done between
# gene.A and gene.B or for the two seperately among populations?

#switch to lapply
pws.multi <- sapply(locNames(msats), function(n) {
  pairwiseTest(x.g[, n, ], nrep = 5, stat.list = list(statGst, quietly = TRUE))
})

pws.multi.out <- pws.multi[[1]][-c(1:5)]
rownames(pws.multi.out) <- as.matrix(pws.multi[[1]][1])


#
sA <- sharedAlleles(msats)[,-c(1:2)]
sA <- sharedAlleles()
names(sA)
nsharedAlleles <- paste("sharedAlleles", names(sA), sep = ".")
names(sA) <- nsharedAlleles

pws.out <- cbind(pws.out, sA)

sharedAlleles(msats)
sharedAlleles(test.g)

#
test.msats.sa <- sharedAlleles(msats)

shared.haps <- sapply(locNames(x.g), function(g){
  gene <- x.g[,g,]
  sharedAlleles(gene)
})


sharedAlleles(x.g[,"gene2",])
str(shared.haps)

data(dolph.msats)
data(dolph.strata)
msats.merge <- merge(dolph.strata[, c("ids", "fine")], dolph.msats, all.y = TRUE)
msats <- df2gtypes(msats.merge, ploidy = 2)

propSharedLoci(msats)

sharedAlleles(msats)

shared.haps <- sapply(locNames(x.g), function(g){
  gene <- x.g[,g,]
  gene.sh <- propSharedLoci(gene,type="ids")
  list(gene.sh,gene.sh)
})

shared.haps[1]$results
shared.haps[2]

str(shared.haps)
shared.haps[6]

# http://www.genetics.org/content/197/2/769.full.pdf
# http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3352520/
# http://www.genetics.org/content/197/2/769.full.pdf
# http://mbe.oxfordjournals.org/content/early/2012/10/03/molbev.mss232.full.pdf
# http://www.molecularecologist.com/2015/04/visualizing-linkage-disequilibrium-in-r/
# http://stats.stackexchange.com/questions/23117/which-mean-to-use-and-when
# emperical data alongside and want to us abc simulation to make sure everything calculated the same way

class(test.g)

### genotype is genind: chord distance,


### haplotype is class(multiDNA) class the object, Nei'sDa (distance)
### params has a data type skelesim
## genind genotype
### need to work over all DNAbin in multiDNA: multidna@dna which is a list of DNAbin matrices


# gtypes object already has per population:
#       N, average num alleles, percent unique, heterozygosity
#                           per locus:
#       number genotyped, num allels, percent unique, obs heterozygosity

# Some data about populations
summary(msats)$strata.smry

# Shared alleles
# strataG
# ? how to turn this into one value per population??
sharedAlleles(msats) # per locus
propSharedLoci(msats) # per population columns 3:5



# HWE
# HWEgenepop(msats) ## required GENEPop
# library(pegas)
genindobj <- gtypes2genind(msats)
hw.test(genindobj) # B = # replicates for MC or regular test B = 0
hw.test(genindobj, B = 0)
# library(genetics)
# HWE.test(genotype) # some other data type...



# Some data about loci
summary(msats)$locus.smry


#####################################################################

#foo.array <- array(0, c(2,3,4))

# Then fill it in as the analyses are being done
#foo.array[,,1] <- matrix(1:3, nrow = 2, ncol = 3)

for(i in 1:nrep){
  sim.data.analysis[,,i] <- matrix(all the data)
}

######################################################################







###################################################### end July 13, 2015



################################### from analysis_funcs. October 16, 2015
#   @slot analyses.requested vector of logicals specifying "Global", "Population",
#   "Locus", or "Pairwise" analyses have been requested.
# We only really want Global, Locus, and pairwise...should take out population

## Create a skeleSim params object

# gtypes example: test.g
curr_scn <- 3
num_loci <- nLoc(test.g)
num_pops <- nStrata(test.g)
params<- new("skeleSim.params")
params@scenarios$num.pops <- num_pops
params@scenarios$sample.size <- 500

length(params@scenarios)


params@analyses.requested<-c(Global=TRUE,Locus=TRUE,Pairwise=TRUE)
if(params@analyses.requested["Locus"]){
  print("Yay")
}



#To Do: take out "Population" from the analyses.requested choices and mention in creating the slot

# Take out for loop, just if statements for each true selected analysis
for(group in names(which(params@analyses.requested))){

  # group will cycle through selected among Global, Locus, and Pairwise
  # in each iteration of the for loop, group will have only one value



  if(params@analyses.requested["Global"]){

    # TO DO check the data type and do conversions for what is needed
    # For multidna class objects we convert to a gtypes and use strataG for analysis

    # if genes > 1 do different formatting

    #initialize arrays
    if (class(params@analysis.results)=="multidna"){

    msats$dnaseq
      if(inherits(params@analysis.result$dna.seq, "multidna")

  # create the gytpes object earlier so this is DNA sequences, we'd have a list with 1st element strata and the second is the DNA sequences
      # as a multiDNA objects, creats a gtypes if it is a set of sequences, needs to be made
      # earlier
  #   use $strata and $dnaseq - instead of [[2]]
      # allelic:genind and use genind2gtypes vs. sequence: multidna to gtypes
      #test with inherits()
      #if inherits rep.sample genind... inherits(rep.sample, "multidna")
      # class returns value in class slot, we might have something of multiple classes
      # ex. lm() object is an lm and a list, inherits will look through multiple
  # Eric added an m ratio that sean wrote - in strataG
      # mRatio
  #need to add FIS - statFis
      # privateAlleles

      num_loci <- nLoc(params@rep.sample[[2]])

      # Convert the list of DNAbin objects to gtypes
      genes <- params@analysis.result[[2]] #the multidna object
      names(genes@dna) <- paste("gene", 1:length(genes@dna))
      id <- genes@labels
      df <- data.frame(id = id, strata = params@analysis.result[[1]])
      gene.labels <- matrix(id, nrow = length(id), ncol = num_loci)
      colnames(gene.labels) <- paste("gene", 1:ncol(gene.labels), sep = "_")
      df <- cbind(df, gene.labels)
      results_gtype <- df2gtypes(df, 1)


      #put overall analysis in first row using overall_stats()
      # params@current.replicate tells us how deep to put each new run in which list (@current.scenario)
      #run by locus analysis
      results.matrix <- t(sapply(locNames(results_gtype), function (l){
        gtypes_this_loc<-results_gtype[,l,]
        overall_stats(gtypes_this_loc)
      }))
      analyses <- colnames(results.matrix)
      num_analyses <- length(analyses)


      # creates a list of length scenarios for each requested groups of analyses
      for(group in analysis.options[which(params@analyses.requested)])


        ####Need empty lists for each group that will hold replicates for each scenario, add a new list for
        # each new scenario
        params@analysis.results[[group]] <- list()
      params@analysis.results[[group]][1] <- "stuff"
      params@analysis.results[[group]][2] <- "next scenario stuff"





      if(is.null(scenario.results[[group]][[curr_scn]])){
        scenario.results[[group]][[curr_scn]] <- array(0, dim=c(num_loci,num_analyses,num_reps),
                                                       dimnames = list(1:num_loci,analyses,1:num_reps))
      }

      # We are printing by gene, not overall gene analysis. This differs from the genind code below.
      scenario.results[[group]][[curr_scn]][,,curr_rep] <- results.matrix

      #this shouldn't happen here it should be at close of function- this is what is returned
      # We assigned scenario.results a group list item and a curr_scn and [,,curr_rep] slot in our cube
      # but really these need to be assigned for analysis.results, the scenario.results is remade each loop
      params@analysis.results <- scenario.results


    } else if(class(params@analysis.result)=="genind"){

      #Global

      results_genind<-params@rep.result
      #convert genind to gtypes
      results_gtype<-genind2gtypes(results_genind)

      #   analyses <- names(overall_stats(results_gtype))
      #    num_analyses <- length(analyses)

      #put overall analysis in first row using overall_stats()
      # params@current.replicate tells us how deep to put each new run in which list (@current.scenario)
      #run by locus analysis
      mat <- t(sapply(locNames(results_gtype), function (l){
        gtypes_this_loc<-results_gtype[,l,]
        overall_stats(gtypes_this_loc)
      }))
      analyses <- colnames(mat)
      num_analyses <- length(analyses)

      # The first row will hold summary statistics over all loci regardless of population structure.
      # The remaining rows will hold summary statistics per locus
      if(is.null(scenario.results[[group]][[curr_scn]])){
        scenario.results[[group]][[curr_scn]] <- array(0, dim=c(1+num_loci,num_analyses,num_reps),
                                                       dimnames = list(c("Across_loci",1:num_loci),analyses,1:num_reps))
      }

      # combining overall statistics and locus by locus matrix
      scenario.results[[group]][[curr_scn]][,,curr_rep] <-   rbind(overall_stats(results_gtype),mat)

      #this shouldn't happen here it should be at close of function- this is what is returned
      params@analysis.results <- scenario.results

    }



################################################## October 2015 - end












##### Start March Durham  ############################################
####    Old!! From Durham, will now use mostly strataG
#FILE CONVERSION
##Convert to genind, then hierfstat

# From adegenet
# xgenind <- DNAbin2genind(df, pop=strata$pops, exp.char=c("a","t","g","c"))
xgenind <- DNAbin2genind(df, exp.char=c("a","t","g","c"))

xhierfstat <- genind2hierfstat(xgenind, pop=strata$pops)

##Convert to gtype - convert DNAbin file (x) to x.haps, strata will be a df in a list with another df of dna.seq
DNAbin2gtypes <- function(go, strata, popcol = 1){

  if(length(stratafoo > 1)){
    sv <- which(names(strata) == popcol)
  } else {
    sv <- 1
  }

  go <- as.matrix(go)

  x <- sapply(rownames(go), function(n) {
    as.character(go[n, ])[1, ]
  }, simplify = FALSE)

  gtypes(x, strata.vec = sv)

}


#SUMMARY STATISTICS
##population specific
## from genind2hierfstat above
localFst <- betai(xhierfstat)$betaio  #local Fst (Beta of Weir and Hill 2002 NOT of Foll and Gaggiotti 2006)


#### HapFreq <- hap.freqs(gtypes.out) #haplotype frequencies of each population
### Once they all work, make one function that allows choice for which to
##  run, also choice if by population or not - won't that be faster
##  if there isn't population sturcture to, to do by whole group
HapDiv <- haplotypic.diversity(gtypes.out) #haplotype diversities of each population
NucDiv <- nucleotide.diversity(gtypes.out, bases = c("a", "c", "g", "t")) #nucleotide diversity by site
UHap <- pct.unique.haplotypes(gtypes.out)
TajD <- tajimas.d(gtypes.out)

##population pair-wise
NeiD <- nei.Da(gtypes.out) #Nei's Da for each pair of populations
Fst <- pairwise.test(gtypes, stats = "fst", nrep = 10000, keep.null = FALSE,
                     num.cores = 1, quietly = FALSE, write.output = FALSE, ...)
Phist <- pairwise.test(gtypes, stats = "phist", nrep = 10000, keep.null = FALSE,
                       num.cores = 1, quietly = FALSE, write.output = FALSE, ...) #Excoffier et al. 1992

#########################################################################################
##MSAT/SNP DATA
#########################################################################################
require(adegenet)
require(mmod)
require(hierfstat)

##Empirical and simulated data ('x') should be in adegenet genind format, and a metadata df should also be created (i.e. 'strata' three columns: id.col(indivID), strata.col(pops), locus.col(haps))
##depending on required summary stats, these files will be coverted to either genpop (which can be used by adegenet and mmod) or hierfstat data format

#convert to genpop
genind2genpop(x,pop=strata$pops,missing=c("NA"),quiet=FALSE,process.other=FALSE, other.action=mean)

#convert to hierfstat format
genind2hierfstat(x,pop=strata$pops)


#SUMMARY STATISTICS
##population specific
localFst <- betai(xhierfstat) #local Fst (Beta of Weir and Hill 2002 NOT of Foll and Gaggiotti 2006)
HWE <- HWE.test(xgenind,pop=strata$pops,permut=10000,nsim=1999,hide.NA=TRUE,res.type=c("full","matrix")) #DECIDE WHETHER full OR matrix is better output, ALSO HOW MANY permutation and SIMULATIONS
AlFreqs <- scaleGen(xgenpop, center=TRUE, scale=TRUE,
                    missing=c("NA","0","mean"),truenames=TRUE) #computes scaled allele frequencies
AlRich <- allelic.richness(xhierfstat,min.n=NULL,diploid=TRUE) #rarified allele counts, produces a table of rows (loci) and columns (pops), min.all is the number of alleles used for rarefaction

##population pair-wise
DJost <- pairwise_D(xgenind, linearized = FALSE) #This function calculates Jost's D
GprimeST <- pairwise_Gst_Hedrick(xgenind, linearized = FALSE) #This function calculates Hedrick's G'st
GST <- pairwise_Gst_Nei(xgenind, linearized = FALSE) #This function calculates Nei's Gst
FST <- pairwise.fst(xgenind, pop=strata$pops, res.type=c("dist","matrix"), truenames=TRUE) #Nei's Fst (Nei 1973) Ht - ((Hs(A) + Hs(B)/(n_A+n_B)) / Ht ) DECIDE WHETHER dist OR matrix is better output
