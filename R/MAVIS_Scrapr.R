#Extracting Ellenberg and CSR values from MAVIS output

#Preparation in text editor: 
#Open MAVIS output and add 4 new lines: first line the word "data"; 
#second line the site name; third line the site abbreviation; fourth line survey year
#"data"               e.g. data
#[site_name]          e.g. Roudsea Woods and Mosses NNR
#[site_abbreviation]  e.g. ROU
#[survey_year]        e.g. 2015

#set working directory
setwd("G:/@Projects/LTMN/Data/LTMN_Data/06_Raw_Analysis")

#read MAVIS output into R
raw = read.delim("Thurs2015_MavisOut.txt")
raw



#Plots #################

#create vector of all lines containing plot numbers (note ^ means start of str)
quad.lines = as.character(raw[grep("^Plot", raw$data),])
quad.lines = as.character(quad.lines)
quad.lines

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


#present as boxplots

#transform traits to allow multiple boxpl.
traitst = t(traits)
#create title string
boxplot.title = sprintf("%s: Cover weighted mean traits", site_name) 
#create boxplot
boxplot.matrix(traitst, use.cols = F, 
               main=boxplot.title,  ylab="Mean value", xlab="Indicator",
               ylim = c(0,10))