
#### first row ####

observeEvent(
  my_data$kegg_display_table,
  {
    
    req(my_data$kegg_display_table)
    
    cat("[pathway table] \n")
    
    ## count the number of times pathways are found
    my_data$kegg_pathways = 
      tibble(PATHWAY = my_data$kegg_display_table %$% PATHWAY %>% unlist()) %>% 
      group_by(PATHWAY) %>% summarise(count = n(), .groups = "drop") %>% 
      left_join(kegg_db$pathway_maps, by = c(PATHWAY="name"))
    
  })


output$kegg_pathways = DT::renderDataTable({
  
  req(my_data$kegg_pathways)
  
  my_data$kegg_pathways 
  
}, selection = 'single')


output$selected_pathway_table = DT::renderDataTable({
  
  req(my_data$kegg_pathways, input$kegg_pathways_rows_selected)
  
  pw = my_data$kegg_pathways %>% slice(input$kegg_pathways_rows_selected) %$% PATHWAY 
  
  my_data$kegg_display_table %>% filter(sapply(PATHWAY, function(y) pw %in% y)) %>% 
    select(QUERY, KEGG_ID, NAME, FORMULA, EXACT_MASS) %>% 
    mutate(NAME = sapply(NAME, first))
  
}, selection = "single", options = list(scrollX = TRUE))

#### second row ####


output$outfile_select_pathway =  renderUI({
  
  req(my_data$kegg_pathways)
  
  tags$div(
    selectizeInput(
      inputId = "outfile_pathway",
      label = "Select pathways",
      choices = my_data$kegg_pathways$map,
      selected = NULL,
      multiple = T,
      options = list(plugins = list('drag_drop'))
    ),
    actionBttn(inputId ="outfile_pathway_select_all", label = "Select all",style = "minimal", color = "primary", size = "xs"),
    actionBttn(inputId ="outfile_pathway_select_clear", label = "Clear",style = "minimal", color = "primary", size = "xs"),
    br(),
    br()
  )
  
})

## select all
observeEvent(
  input$outfile_pathway_select_all,
  {
    updateSelectizeInput(session, "outfile_pathway", selected = my_data$kegg_pathways$map)
  }
)

## clear
observeEvent(
  input$outfile_pathway_select_clear,
  {
    shinyjs::reset("outfile_pathway")
  }
)



output$outfile_pathways_table = DT::renderDataTable({
  
  req(input$outfile_pathway)
  
  my_data$kegg_pathways %>% 
    filter(map %in% input$outfile_pathway)
  
  
})
