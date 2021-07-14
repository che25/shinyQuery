cat("Sourcing scripts ...")


path_dir = "generic_code"

for (f in list.files(path_dir, pattern="*.R")) f %>%  file.path(path_dir,.) %>% source 

cat(" Done.\n\n")
