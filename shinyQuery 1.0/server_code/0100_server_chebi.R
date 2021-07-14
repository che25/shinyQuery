
#### col select ###
output$chebi_col_selector = renderUI({
  
  req(my_data$chebi_display_table)
  
  choices = names(my_data$chebi_display_table)
  
  selectizeInput(
    inputId = "chebi_col_sel",
    label = "Select table columns",
    choices = choices,
    selected = c("QUERY", "CHEBI_ID", "NAME", "FORMULA", "EXACT_MASS", "KEGG_ID", "HMDB_ID", "LM_ID"),
    multiple = T,
    options = list(plugins = list('drag_drop')), 
    width = "250px"
  )
  
  
})

#### data table ####
output$chebi_contents <- DT::renderDataTable({
  
  req(my_data$chebi_display_table, input$chebi_col_sel)
  
  my_data$chebi_display_table %>% 
    select_at(all_of(input$chebi_col_sel)) %>%
    ## show only first item of list and summary
    mutate_if(
      .predicate = ~is.list(.) & any(sapply(., length)>1), 
      .funs = ~sapply(., function(y) if(length(y)==0) "" else if(length(y)==1) y else sprintf("%s (%d)", first(y), length(y)))
      )
  
  
}, selection = "single", options = list(scrollX = TRUE))


### col record ####
output$chebi_col_record = renderUI({
  
  req(my_data$chebi_display_table)
  
  choices = my_data$chebi_display_table %>% select_if(.predicate = is.list) %>% names()
  
  if(length(choices)==0) return()
  
  selectizeInput(
    inputId = "chebi_col_record",
    label = "Select full record column",
    choices = choices,
    selected = choices[1],
    multiple = F,
    width = "250px"
  )
  
  
})

#### cell record ####
output$chebi_cell_record = renderText({
  
  req(input$chebi_col_record, input$chebi_contents_rows_selected)
  
  my_data$chebi_display_table %>% 
    slice(input$chebi_contents_rows_selected) %>% 
    select(all_of(input$chebi_col_record)) %>% 
    unlist %>% unname() %>% trimws(whitespace = "[ ;]") %>% paste(collapse = "; ")
  
})
