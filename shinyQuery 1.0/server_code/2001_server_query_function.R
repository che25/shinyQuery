
## this function needs access to reactive (or global variables)
run_search = function(db, inchi=NULL) {
  
  if(input$query_search_type == "mass") {
    
    ## convert character to numeric
    tol = suppressWarnings(as.numeric(input$query_tolerance)) %>% setdiff(NA)
    query = suppressWarnings(as.numeric(my_data$query)) %>% setdiff(NA)
    
    if(length(tol)==0 || length(query)==0) return()
    
    result =
      my_single_numeric_filter(db, query, "EXACT_MASS", tol)
  
  } else if(input$query_search_type == "id") {
  
    result =
      my_multi_filter(
        db, 
        my_data$query, 
        var_names =  grep("_ID$", colnames(db), value=T),
        reg_exp_mask =  MASK
      )
  } else {
    result =
      my_single_character_filter(
        db, 
        my_data$query, 
        var_names = switch(
          input$query_search_type,
          text = "NAME",
          formula = "FORMULA",
          inchi = "INCHI_KEY"
        ),
        reg_exp_mask = switch(
          input$query_search_type,
          text = "%s",
          formula = "^%s$",
          inchi = "%s"
        )
      )
  }
    
  if(!is.null(inchi)) {
    result %<>% 
      select(QUERY, INCHI_KEY) %>% 
      left_join(inchi, by = "INCHI_KEY") %>% 
      left_join(db, by = names(inchi))
    
  } 
  
  return(result %>% unique())
  
  
}

make_display_table = function(x) {
  
  if(is.null(x)) return(x)
  
  if("EXACT_MASS" %in% names(x)) {
    x %<>% mutate_at(c("EXACT_MASS"), .funs = ~sprintf("%.4f", .))
  }
  
  x %>% 
    ## convert to list if concatenated string
    mutate_if(.predicate = ~is.character(.) & any(grepl(SPLIT, .)), .funs = ~strsplit(., split=SPLIT))
}
  
