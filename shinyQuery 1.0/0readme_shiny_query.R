#' TO DO after 1.0
#' - double click rows of table
#' - improve merge, so that the same columns don't appear twice and inconsistencies are shown up

#### SHINY QUERY 1.0 ####

#' shiny query
#' - query chebi, kegg, lipid maps and hmdb
#' - each database is loaded from disk
#' - query against each database independently
#' - optional merge at end
#' - kegg pathway annotation with possibility of filtering
#' 
#' 
#' database structure
#' - RDS file on disk containing a list; one is a tibble with the database and the other is a INCHI_KEY resolver (not for kegg)
#' - the databases have several columns that have the same names:
#' * NAME
#' * ._ID e.g. CHEBI_ID, KEGG_ID ...
#' * FORMULA from INCHI (except kegg)
#' * EXACT_MASS (calculated from FORMULA)
#' * INCHI_KEY without the last character (protonation/charge), again not for kegg
#' * INCHI_P, INCHI_Q
#' 
#' queries
#' - against ID i.e. all "_ID$" columns; exact match required
#' - against text; any text column, can be partial
#' - against FORMULA (exact)
#' - against EXACT_MASS (with tolerance)
#' 
#' To do
#' - e.g. NADP zwitterion CHEBI_ID 44215, gets matched to QUERY C00003 but no KEGG_ID is shown ...
#' - how to use the consensus?

