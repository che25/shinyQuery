my_multi_filter = function(x, queries, var_names, reg_exp_mask = "\\b%s\\b") {
  
  #' x: tibble
  #' queries: character[n]
  #' var_names: character[n], names of columns in db
  #' reg_exp: character[1]
  #' return value: x filtered for rows in which any query occurs 
  #' in any column
  #' the query successful query is prepended as a new column
  #' the same row can occur more than once because it can generate
  #' hits with different queries
  
  # save(list=ls(), file = "multi_filter2.RData")
  
  var_names %<>% intersect(names(x))
  
  if(length(var_names) == 0) return()
  
  foreach(q = queries, .final = bind_rows) %do% {
    x %>% filter_at(
      .vars = all_of(var_names),
      .vars_predicate = any_vars(grepl(sprintf(reg_exp_mask, q), ., ignore.case = T))
    ) %>% 
      bind_cols(QUERY = q, .)
    
  } 
}


my_single_character_filter = function(x, queries, var_names, reg_exp_mask = "\\b%s\\b", ignore_case = T) {
  
  #' x: tibble
  #' queries: character[n]
  #' var_names: character[n], names of columns in db; ** only first will be used! **
  #' reg_exp: character[1]
  #' return value: x filtered for rows in which any query occurs 
  #' in any column
  #' the query successful query is prepended as a new column
  #' the same row can occur more than once because it can generate
  #' hits with different queries
  #' grepl now with
  #' hits ranked with string dist
  #' ... also correctly now if there are multiple NAMEs separated by " __ "
  
  # save(list=ls(), file = "multi_filter.RData")
  
  var_name = var_names %>% first() %>% intersect(names(x)) 
  
  if(length(var_name) == 0) return()
  
  foreach(q = queries, .final = bind_rows) %do% {
    x %>% filter(grepl(sprintf(reg_exp_mask, q), !!as.name(var_name), ignore.case = ignore_case)
    ) %>% 
      bind_cols(QUERY = q, .) %>% 
      mutate(score = strsplit(NAME, " __ ") %>% lapply(stringdist, q) %>% sapply(min)) %>% 
      arrange(score)
  } 
}

my_numeric_filter = function(x, queries, var_names, tolerance) {
  
  # save(list=ls(), file = "numeric_filter.RData")
  
  var_names %<>% intersect(x %>% sapply(is.numeric) %>% which() %>% names())
  
  if(length(var_names) == 0) return()
  
  foreach(q = queries, .final = bind_rows) %do% {
    x %>% filter_at(
      .vars = all_of(var_names),
      .vars_predicate = any_vars(abs(. - q)<tolerance)
    ) %>% 
      bind_cols(QUERY = q, .)
  } 
}  

my_single_numeric_filter = function(x, queries, var_names, tolerance) {
  
  # save(list=ls(), file = "numeric_filter.RData")
  
  var_name = var_names %>% first() %>%  intersect(x %>% sapply(is.numeric) %>% which() %>% names())
  
  if(length(var_name) == 0) return()
  
  foreach(q = queries, .final = bind_rows) %do% {
    x %>% 
      mutate(DELTA =abs(!!as.name(var_name)-q)) %>% 
      filter(DELTA<=tolerance) %>% 
      bind_cols(QUERY = q, .)
  } %>% 
    arrange(DELTA)
}  
