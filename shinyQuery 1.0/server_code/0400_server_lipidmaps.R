
#### col select ###
output$lipid_maps_col_selector = renderUI({
  
  req(my_data$lipid_maps_display_table)
  
  choices = names(my_data$lipid_maps_display_table)
  
  selectizeInput(
    inputId = "lipid_maps_col_sel",
    label = "Select table columns",
    choices = choices,
    selected = c("QUERY", "LM_ID","NAME","ABBREVIATION","CATEGORY","MAIN_CLASS","SUB_CLASS","CLASS_LEVEL4"),
    multiple = T,
    options = list(plugins = list('drag_drop')), 
    width = "250px"
  )
  
  
})


#### data table ####
output$lipid_maps_contents = DT::renderDataTable({
  
  req(my_data$lipid_maps_display_table, input$lipid_maps_col_sel)
  
  my_data$lipid_maps_display_table %>%
    select(all_of(input$lipid_maps_col_sel)) %>% 
    ## show only first item of list and summary
    mutate_if(
      .predicate = ~is.list(.) & any(sapply(., length)>1), 
      .funs = ~sapply(., function(y) if(length(y)==0) "" else if(length(y)==1) y else sprintf("%s (%d)", first(y), length(y)))
    )
  
}, selection = "single", options = list(scrollX = TRUE))


### col record ####
output$lipid_maps_col_record = renderUI({
  
  req(my_data$lipid_maps_display_table)
  
  choices = my_data$lipid_maps_display_table %>% select_if(.predicate = is.list) %>% names()
  
  selectizeInput(
    inputId = "lipid_maps_col_record",
    label = "Select full record column",
    choices = choices,
    selected = choices[1],
    multiple = F,
    width = "250px"
  )
  
  
})

#### cell record ####
output$lipid_maps_cell_record = renderText({
  
  req(input$lipid_maps_col_record, input$lipid_maps_contents_rows_selected)
  
  my_data$lipid_maps_display_table %>% 
    slice(input$lipid_maps_contents_rows_selected) %>% 
    select(all_of(input$lipid_maps_col_record)) %>% 
    unlist %>% unname() %>% trimws(whitespace = "[ ;]") %>% paste(collapse = "; ")
  
})