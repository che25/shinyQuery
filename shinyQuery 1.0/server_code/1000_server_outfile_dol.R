

#### BIG EVENT #### 

observeEvent(
  input$outfile_make,
  {

    outlist = list()
    
    if(!is.null(my_data$input_table)) {
      outlist$input = my_data$input_table %>% select_at(all_of(input$query_col_sel)) %>% set_names(., sprintf("input_%s", names(.))) %>% rename(QUERY = 1)
    } else {
      outlist$input = tibble(QUERY = my_data$query)
    }
    
    if(input$outfile_chebi_include == "Yes" && isTruthy(my_data$chebi_table)) {
      
      outlist$chebi = my_data$chebi_table %>% select_at(all_of(union(c("QUERY", "CHEBI_ID") ,input$chebi_col_sel))) %>% 
        set_names(., sprintf("chebi_%s", names(.))) %>% rename(`__QUERY__` = 1)
    }
      
      
    if(input$outfile_kegg_include == "Yes" && isTruthy(my_data$kegg_table)) {
      
      outlist$kegg = my_data$kegg_table %>% select_at(all_of(union(c("QUERY", "KEGG_ID") ,input$kegg_col_sel))) %>% 
        set_names(., sprintf("kegg_%s", names(.))) %>% rename(`__QUERY__` = 1)
    }
    
    if(input$outfile_lipid_maps_include  == "Yes" && isTruthy(my_data$lipid_maps_table)) {
      outlist$lm = my_data$lipid_maps_table %>% select_at(all_of(union(c("QUERY", "LM_ID") ,input$lipid_maps_col_sel))) %>% 
        set_names(., sprintf("lima_%s", names(.))) %>% rename(`__QUERY__` = 1)
    }
    
    if(input$outfile_hmdb_include == "Yes" && isTruthy(my_data$hmdb_table)) {
      outlist$hmdb = my_data$hmdb_table %>% select_at(all_of(union(c("QUERY", "HMDB_ID") ,input$hmdb_col_sel))) %>% 
        set_names(., sprintf("hmdb_%s", names(.))) %>% rename(`__QUERY__` = 1)
    }
    
    pathway_long = 
      my_data$kegg_display_table %>% 
      select(KEGG_ID, PATHWAY) %>% 
      unnest(cols = c(PATHWAY)) %>% 
      left_join(kegg_db$pathway_maps, by = c(PATHWAY="name"))
    
    ## filter for pathway
    if(input$outfile_pathway_filter == "Yes") {
      
      ## KEGG entries with pathway annotation
      keep_entry = 
        pathway_long %>% 
        filter(map %in% input$outfile_pathway) %$% kegg_KEGG_ID %>%
        unique()
      
      ## queries that match the above KEGG entries
      keep_query = my_data$kegg_table %>% 
        filter(KEGG_ID %in% keep_entry) %$% QUERY 
      
      ## filter all sheets for above queries
      outlist %<>% map(~filter(., `__QUERY__` %in% keep_query)) 
      
    }
    
    if(input$outfile_merged_table == "Yes" && length(outlist)>1) {
      
      merged_table = 
        outlist1[[1]] 
      
      for(i in seq(2, length(outlist))) {
      
         merged_table  %<>%  
            full_join(outlist[[i]], by = "`__QUERY__`")
        }
        
      outlist$merged = merged_table
         
    }

    ## add pathways matrix
    if(input$outfile_pathway_include == "Yes" && isTruthy(my_data$kegg_table)) {
      
      if(isTruthy(input$outfile_pathway)) pathway_long %<>% filter(PATHWAY_ID %in% input$outfile_pathway)
      
      pathway_long %<>% 
        ## encode missing as ""
        pivot_wider(id_cols = KEGG_ID, names_from = PATHWAY, values_from = map, values_fill = "") #%>% 
        ## make sure to include all compounds
        # left_join(merged %>% select(ChEBI_ID, KEGG), ., by=c(KEGG="KEGG_ID")) %>% 
        # mutate_all(.funs = ~replace(., is.na(.), ""))
    
      outlist$pathway = pathway_long 
    }
    
    my_data$result_outlist = outlist
    
  }
)
  

output$download_table = renderUI({
  
  req(my_data$result_outlist)
  
  downloadButton(outputId = "metabolist.xlsx", label = "Download table as xlsx")
  
})


output$metabolist.xlsx <- downloadHandler(
  filename = function() "metabolist.xlsx",
  content = function(file) {
    
    openxlsx::write.xlsx(my_data$result_outlist, file = file)
  }
)

output$outlist_final_table = DT::renderDataTable({
  
  req(my_data$result_outlist)
  
  my_data$result_outlist$merged
  
}, options = list(scrollX = TRUE))

output$outlist_final_table_pathway = DT::renderDataTable({
  
  req(my_data$result_outlist)
  
  my_data$result_outlist$pathway
  
}, options = list(scrollX = TRUE))
