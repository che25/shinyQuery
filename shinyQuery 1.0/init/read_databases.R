
#' all databases are read from disk as RDS
#' each RDS contains a list, and the first item, with the same name as the list, is the database as tibble

cat("Loading databases ...")


## for converting lists into character and back
assign("SPLIT", " __ ", envir = .GlobalEnv)
assign("MASK", sprintf("(^|%s)%s(%s|$)",SPLIT, "%s", SPLIT), envir = .GlobalEnv)

#### chebi ####
assign("chebi_db", readRDS("db/chebi.RDS"), envir = .GlobalEnv)

#### kegg ####
assign("kegg_db", readRDS("db/kegg.RDS"), envir = .GlobalEnv)

#### lipid maps ####
assign("lima_db", readRDS("db/lima.RDS"), envir = .GlobalEnv)

#### hmdb ####
assign("hmdb_db", readRDS("db/hmdb.RDS"), envir = .GlobalEnv)

#### mtan ####
assign("mtan_db", readRDS("db/mtan.RDS"), envir = .GlobalEnv)


cat(" Done.\n\n")
