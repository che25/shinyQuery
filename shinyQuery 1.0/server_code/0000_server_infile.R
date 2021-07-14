observeEvent(
  input$file1,
  {
    req(input$file1)
    
    ## uploaded metabolite list
    my_data$input_table = read_xlsx(input$file1$datapath) 
  }
)


output$query_col_selector = renderUI({
  
  req(my_data$input_table)
  
  choices = names(my_data$input_table)
  
  selectizeInput(
    inputId = "query_col_sel",
    label = "Select table columns",
    choices = choices,
    selected = NULL,
    multiple = T,
    options = list(plugins = list('drag_drop'))
  )
  
  
})


observeEvent(
  input$query_submit_batch,
  {
    req(input$query_col_sel, my_data$input_table)
    
    my_data$query = my_data$input_table[[first(input$query_col_sel)]] %>% 
      {subset(., subset = isTruthy(.))} %>% 
      unique()
    
    my_data$tolerance = input$query_tolerance
    
  }
)


observeEvent(
  input$query_submit_single,
  {
    req(input$query_text)
    
    my_data$query = input$query_text %>% trimws()
    
    my_data$tolerance = input$query_tolerance
  
  }
)

output$query_text_message = renderText({
  
  req(input$query_submit, input$query_text)
  
  sprintf("Querying `%s` against Chebi, Kegg, HMDB and LipidMaps", input$query_text)
  
  
})

output$infile_contents <- DT::renderDataTable({
  
  req(my_data$input_table, input$query_col_sel)
  
  my_data$input_table %>% 
    select_at(all_of(input$query_col_sel)) %>% 
    DT::datatable() 
    
  
})