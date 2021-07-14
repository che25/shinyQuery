onStop(function() {
  
  env = parent.env(environment())
  
  ls(envir = env) %>%
    ## .. excluding e.g. session" and "output"
    setdiff(c("session", "output")) %>%
    ## object in a list
    mget(envir = env) %>%
    ## keep only reactive values
    subset(., subset = sapply(., is.reactivevalues)) %>%
    ## convert reactive values
    sapply(function(z) isolate(reactiveValuesToList(z)), simplify=F) %>%
    ## assign to global environment
    list2env(envir = .GlobalEnv)
  
  
  ## load output functions into global name space
  dirname = "server_code/"
  
  for( fname in list.files(dirname , pattern = "^[0-9].*function\\.[rR]$"))
  {
    # cat(fname, " ")
    source_functions_only2(file.path(dirname, fname))
  }
  
  cat("\nSession stopped.\n")
  cat("Type `save(list=ls(), file='tmp.RData')` to save state variables in your current working directory\n")
  cat("Find out what current working directory by typing `getwd()`\n")
}
)