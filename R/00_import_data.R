#data import

library(tidyverse)
library(readxl)

# import baseline data
raw_bsln <- read_xls("data/STOD_96.XLS", skip = 4, sheet = 1) %>% 
  full_join(read_xls("data/STOD_96.XLS", skip = 4, sheet = 2)) %>% 
  full_join(read_xls("data/STOD_96.XLS", skip = 4, sheet = 3)) %>%
  full_join(read_xls("data/STOD_96.XLS", skip = 4, sheet = 4)) %>%
  full_join(read_xls("data/STOD_96.XLS", skip = 4, sheet = 5)) %>%
  full_join(read_xls("data/STOD_96.XLS", skip = 4, sheet = 6)) %>%
  full_join(read_xls("data/STOD_96.XLS", skip = 4, sheet = 7)) %>%
  full_join(read_xls("data/STOD_96.XLS", skip = 4, sheet = 8)) %>%
  full_join(read_xls("data/STOD_96.XLS", skip = 4, sheet = 9))

ditch_bsln <- raw_bsln[91:101,] %>% select(key = 'Ditch Number', everything()) %>%
  select(-'% Freq') %>% 
  gather(key = ditch_id, value = value, -c(key)) %>% 
  mutate(survey = "baseline") %>% 
  spread(key = key, value = value) %>% 
  select(ditch_id, survey, conductivity = Conductivity, choked = `Ditch choked`, 
         dry = `Ditch dry`, n_aquatics = `Number of Aquatics**`, 
         n_banks = `Number of Banks`, n_emergent = `Number of Emergents`, 
         scrub = Scrub, n_spp = `Total number of species`) %>% 
  distinct()

data_bsln <- raw_bsln[1:90,] %>% 
  select(species = 'Ditch Number', perc_freq = '% Freq', everything()) %>% 
  gather(key = ditch_id, value = present, -c(species, perc_freq)) %>% 
  mutate(survey = "baseline")

# import pilot data
raw_plt <- read_xlsx("data/data-2019 Mar and July.xlsx")

ditch_plt <- raw_plt %>% 
  select(ditch_id = `Ditch No. (after 1996 survey)`, 
         sample_no = `Sample No.`, date = Date, gridref = `Grid Reference`, 
         wetness = `Wetness (1-5)`, scrub = `Scrub (1-3)`, 
         canopy_perccov = `Canopy (% cover)`, canopy_spp = `Canopy species`, 
         habitat = Habitat, ditch_width_m = `Ditch width (m)`, 
         ditch_depth_m = `Ditch depth (m)`, 
         ditch_openwater_perccov = `Ditch open water % cover (Clear or choked 1996)`, 
         ditch_pH = `Water pH`, ditch_microS = `Water µS`, ditch_ppm = `Water ppm`) %>% 
  mutate(survey = "pilot") %>% 
  distinct()

data_plt <- raw_plt %>% 
  select(species = Species, ditch_id = `Ditch No. (after 1996 survey)`, 
         sample_no = `Sample No.`, date = Date, gridref = `Grid Reference`,
         plant_dafor = `Plant sp freq or p/a`, 
         mollusc_dafor = `Mollusc sp frequency`, vm_count_ad = `Vm Count Adult`,
         vm_count_juv = `Vm Count Juv`, sn_count_ad = `Sn Count Adult`, 
         sn_count_juv = `Sn Count Juv`, 
         notes = Notes, determiner = `Determined by`, date_irecord = iRecord) %>% 
  mutate(survey = "pilot")





# export them to csv: 
write_csv(data_bsln, "data/data_bsln.csv")
write_csv(data_plt, "data/data_plt.csv")
write_csv(ditch_bsln, "data/ditch_bsln.csv")
write_csv(ditch_plt, "data/ditch_plt.csv")
