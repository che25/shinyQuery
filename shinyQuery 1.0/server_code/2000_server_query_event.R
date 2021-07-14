observeEvent(
  c(
    my_data$query,
    my_data$tolerance
  ),
  {
    
    req(my_data$query)
    
    cat(sprintf("[%s search] (%d %s)\n", input$query_search_type, length(my_data$query), ifelse(length(my_data$query)==1, "query", "queries")))
    
    cat(sprintf("Searching chebi ...\n"))
    my_data$chebi_table = run_search(chebi_db$chebi, chebi_db$inchi_key)
    my_data$chebi_display_table = make_display_table(my_data$chebi_table)
    
    cat(sprintf("Searching kegg ...\n"))
    my_data$kegg_table = run_search(kegg_db$kegg, kegg_db$inchi_key)
    my_data$kegg_display_table = make_display_table(my_data$kegg_table)
    
    cat(sprintf("Searching Metaboanalyst compound db ...\n"))
    my_data$mtan_table = run_search(mtan_db$mtan, mtan_db$inchi_key)
    my_data$mtan_display_table = make_display_table(my_data$mtan_table)

    cat(sprintf("Searching hmdb ...\n"))
    my_data$hmdb_table = run_search(hmdb_db$hmdb, hmdb_db$inchi_key)
    my_data$hmdb_display_table = make_display_table(my_data$hmdb_table)

    cat(sprintf("Searching lipid maps ...\n"))
    my_data$lipid_maps_table = run_search(lima_db$lima, lima_db$inchi_key)
    my_data$lipid_maps_display_table = make_display_table(my_data$lipid_maps_table)
    
    my_data$finished = ifelse(is.null(my_data$finished), 1, my_data$finished+1)
    
  }
)

output$search_log = renderPrint({
  
  req(my_data$finished)
  
  cat(sprintf("[%s search] (%d %s)\n", input$query_search_type, length(my_data$query), ifelse(length(my_data$query)==1, "query", "queries")))
  cat(sprintf("Searching chebi ... found %d hits \n", nrow(my_data$chebi_table)))
  cat(sprintf("Searching kegg ... found %d hits \n", nrow(my_data$kegg_table)))
  cat(sprintf("Searching hmdb ... found %d hits \n", nrow(my_data$hmdb_table)))
  cat(sprintf("Searching mtan ... found %d hits \n", nrow(my_data$mtan_table)))
  cat(sprintf("Searching lipid maps ... found %d hits \n", nrow(my_data$lipid_maps_table)))
  
  
})

