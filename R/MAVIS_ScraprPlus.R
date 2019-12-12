#MAVIS ScrapR Plus
#Extracting Ellenberg and CSR values plus NVC results from MAVIS output

#This script takes the text output from CEH's MAVIS programme and extracts
#plant traits and NVC results in tabulated form so that they can be analysed.
#Its quite a messy way of doing it, but it works.  Plant traits and NVC are 
#extracted in separate stages and the MAVIS output needs to be prepared a little 
#before it is read into R.   

############################

#Scraping Plant trait output

############################

##Prepare the input file: 

#Open MAVIS output and add 4 new lines:
#"data"               e.g. data
#[site_name]          e.g. Roudsea Woods and Mosses NNR
#[site_abbreviation]  e.g. ROU
#[survey_year]        e.g. 2015

#set working directory if different to project directory
#setwd("G:/@Projects/LTMN/Data/LTMN_Data/06_Raw_Analysis")

#read MAVIS output into R
raw = read.delim("OWH2012_MAVIS_output_for_R.txt")
raw

#create vector of all lines containing plot numbers (note ^ means start of str)
quad.lines = as.character(raw[grep("^Plot", raw$data),])
quad.lines = as.character(quad.lines)
quad.lines; length(quad.lines)

#extract values from their character positions into variable vectors
quad  = as.character(substr(quad.lines, 6,8))
quad

#Ellenberg values

#create vector of all lines containing Ellenberg values
ell.lines = as.character(raw[grep("ELL: Light", raw$data),])
ell.lines = as.character(ell.lines)

#extract values from their character positions into variable vectors
light = as.numeric(substr(ell.lines, 12,14))
wet   = as.numeric(substr(ell.lines, 25,27))
ph    = as.numeric(substr(ell.lines, 33,35))
fert  = as.numeric(substr(ell.lines, 48,50))

#CSR values

#create vector of all lines containing CSR values
csr.lines = as.character(raw[grep("CSR: C:", raw$data),])
csr.lines = as.character(csr.lines)

#extract values from their character positions into variable vectors
comp   = as.numeric(substr(csr.lines, 8,12))
stress = as.numeric(substr(csr.lines, 18,21))
rud    = as.numeric(substr(csr.lines, 27,30))

#put all variable vectors together in a data frame
traits = as.data.frame(cbind(light,wet,ph,fert, comp, stress, rud))
traits

#create vectors for site name, site abbreviation, survey year
site_name   = as.character(raw[1,])
site_code   = as.character(rep(raw[2,],nrow(traits)))
survey_year = as.character(rep(raw[3,],nrow(traits)))

#export data frame as csv file
site.year.traits = cbind(survey_year, site_code, quad, traits)
write.csv(site.year.traits, file = "traits.csv", row.names = F)


#Graphing: present as boxplots

#transform traits to allow multiple boxpl.
traitst = t(traits)
#create title string
boxplot.title = sprintf("%s: Cover weighted mean traits", site_name) 
#create boxplot
boxplot.matrix(traitst, use.cols = F, 
               main=boxplot.title,  ylab="Mean value", xlab="Indicator",
               ylim = c(0,10))


##########################

#Scraping NVC output

##########################


raw2 = read.table("OWH2012_MAVIS_NVC_out_for_R.txt", header = F)


#calculate number of groups by counting lines that start with "Group"
nr.groups = nrow((raw2[grep("^Group", raw2$V1),]))

#start reshaping the data
#first we'll put some of the data into a dataframe.  
#in this case the lines with the group name and the lines for the first three matches
#normally there are 10 matches, but sometimes there are less, so we count from the group line
#also sort the data, so that they appear together in the right order.

nvc.temp <- as.data.frame(raw2[sort(c(grep("^Group", raw2$V1), grep("^Group", raw2$V1)+1, grep("^Group", raw2$V1)+2, grep("^Group", raw2$V1)+3)),])
#this conveniently puts the group names, the NVC codes and the % match into separate cells
#but not into particularly useful column configurations

#to get round that, we make vectors by selecting the appropriate cell for the group name, 
#the nvc code and the nvc % match for each of our groups for the first three matches
groups2 <- nvc.temp$V3[seq(1, length.out = nr.groups, by = 4)]
nvc1    <- as.character(nvc.temp$V2[seq(2, length.out = nr.groups, by = 4)])
nvc1_match  <- nvc.temp$V3[seq(2, length.out = nr.groups, by = 4)]
nvc2    <- as.character(nvc.temp$V2[seq(3, length.out = nr.groups, by = 4)])
nvc2_match  <- nvc.temp$V3[seq(3, length.out = nr.groups, by = 4)]
nvc3    <- as.character(nvc.temp$V2[seq(4, length.out = nr.groups, by = 4)])
nvc3_match  <- nvc.temp$V3[seq(4, length.out = nr.groups, by = 4)]

#bind into a dataframe with each group in one row
NVC_matches <- as.data.frame(cbind(groups2, nvc1, nvc1_match, nvc2, nvc2_match, nvc3, nvc3_match))

#and export
write.csv(NVC_matches, file = "NVC_matches.csv", row.names = F)

#clean up (there's lots of useless temporary files in there.  )
rm(groups2, nvc1, nvc1_match, nvc2, nvc2_match, nvc3, nvc3_match, nr.groups, nvc.temp)
