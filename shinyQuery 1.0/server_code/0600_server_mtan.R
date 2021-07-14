
#### col select ###
output$mtan_col_selector = renderUI({
  
  req(my_data$mtan_display_table)
  
  choices = names(my_data$mtan_display_table)
  
  selectizeInput(
    inputId = "mtan_col_sel",
    label = "Select table columns",
    choices = choices,
    selected = c("QUERY", "HMDB_ID", "NAME", "KEGG_ID", "CHEBI_ID"),
    multiple = T,
    options = list(plugins = list('drag_drop')), 
    width = "250px"
  )
  
  
})

#### data table ####
output$mtan_contents = DT::renderDataTable({
  
  req(my_data$mtan_display_table, input$mtan_col_sel)
  
  my_data$mtan_display_table %>%
    select(all_of(input$mtan_col_sel)) %>% 
    ## show only first item of list and summary
    mutate_if(
      .predicate = ~is.list(.) & any(sapply(., length)>1), 
      .funs = ~sapply(., function(y) if(length(y)==0) "" else if(length(y)==1) y else sprintf("%s (%d)", first(y), length(y)))
    )
  
}, selection = "single", options = list(scrollX = TRUE))

### col record ####
output$mtan_col_record = renderUI({
  
  req(my_data$mtan_display_table)
  
  choices = my_data$mtan_display_table %>% select_if(.predicate = is.list) %>% names()
  
  if(length(choices)==0) return()
  
  selectizeInput(
    inputId = "mtan_col_record",
    label = "Select full record column",
    choices = choices,
    selected = choices[1],
    multiple = F,
    width = "250px"
  )
  
  
})

#### cell record ####
output$mtan_cell_record = renderText({
  
  req(input$mtan_col_record, input$mtan_contents_rows_selected)
  
  my_data$mtan_display_table %>% 
    slice(input$mtan_contents_rows_selected) %>% 
    select(all_of(input$mtan_col_record)) %>% 
    unlist %>% unname() %>% trimws(whitespace = "[ ;]") %>% paste(collapse = "; ")
  
})

