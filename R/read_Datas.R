
library(readxl)
files = fs::dir_ls("data/read_data", recurse = TRUE, glob = "*.xlsx")
df = map_dfr(files, read_xlsx)  
head(df)