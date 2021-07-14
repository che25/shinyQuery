
#### col select ###
output$kegg_col_selector = renderUI({

  req(my_data$kegg_display_table)

  choices = names(my_data$kegg_display_table)
  
  selectizeInput(
    inputId = "kegg_col_sel",
    label = "Select table columns",
    choices = choices,
    selected = choices[1:5],
    multiple = T,
    options = list(plugins = list('drag_drop')), 
    width = "250px"
  )


})

#### data table ####
output$kegg_contents = DT::renderDataTable({

  req(my_data$kegg_display_table, input$kegg_col_sel)

  my_data$kegg_display_table %>%
    select(all_of(input$kegg_col_sel)) %>% 
    ## show only first item of list and summary
    mutate_if(
      .predicate = ~is.list(.) & any(sapply(., length)>1), 
      .funs = ~sapply(., function(y) if(length(y)==0) "" else if(length(y)==1) y else sprintf("%s (%d)", first(y), length(y)))
    )
}, selection = "single", options = list(scrollX = TRUE))

### col record ####
output$kegg_col_record = renderUI({
  
  req(my_data$kegg_display_table)
  
  choices = my_data$kegg_display_table %>% select_if(.predicate = is.list) %>% names()
  
  selectizeInput(
    inputId = "kegg_col_record",
    label = "Select full record column",
    choices = choices,
    selected = choices[1],
    multiple = F,
    width = "250px"
  )
  
  
})

#### cell record ####
output$kegg_cell_record = renderText({
  
  req(input$kegg_col_record, input$kegg_contents_rows_selected)
  
  my_data$kegg_display_table %>% 
    slice(input$kegg_contents_rows_selected) %>% 
    select(all_of(input$kegg_col_record)) %>% 
    unlist %>% unname() %>% trimws(whitespace = "[ ;]") %>% paste(collapse = "; ")
  
})
