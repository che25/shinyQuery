## wipe global env
wipe_global_env = T
if(wipe_global_env) rm(list=ls(envir = .GlobalEnv), envir = .GlobalEnv)

## app name and version
assign("APP_NAME", "Shiny Query",  envir = .GlobalEnv)
assign("APP_VERSION", "1.0.3",  envir = .GlobalEnv)
cat(sprintf("\n%s %s\n\n", APP_NAME, APP_VERSION))
cat(sprintf("%s\n\n", getwd()))

## load packages
cat("Loading packages ...\n\n")

library("shiny")
library("shinythemes")
library("shinyWidgets")
library("shinyjs")
library("tidyverse")
library("magrittr")
library("DT")
library("readxl")
library("foreach")
library("openxlsx")
library("stringdist")

## read the databases
source("init/read_databases.R")

## source scripts
source("init/source_scripts.R")


cat("Firing up the server ...")

server = function(input, output, session) {
  
  my_data = reactiveValues()
  
  source(file.path("server_code", "2000_server_query_event.R"),  local = TRUE)$value
  source(file.path("server_code", "2001_server_query_function.R"),  local = TRUE)$value
  
  source(file.path("server_code", "0000_server_infile.R"),  local = TRUE)$value
  source(file.path("server_code", "0100_server_chebi.R"),  local = TRUE)$value
  source(file.path("server_code", "0200_server_kegg.R"),  local = TRUE)$value
  source(file.path("server_code", "0300_server_pathway.R"),  local = TRUE)$value
  source(file.path("server_code", "0400_server_lipidmaps.R"),  local = TRUE)$value
  source(file.path("server_code", "0500_server_hmdb.R"),  local = TRUE)$value
  source(file.path("server_code", "0600_server_mtan.R"),  local = TRUE)$value
  
  source(file.path("server_code", "1000_server_outfile.R"),  local = TRUE)$value

  source(file.path("server_code", "9900_server_stop.R"),  local = TRUE)$value
  
    
}


ui <- fluidPage(
  useShinyjs(),
  navbarPage(
    title = sprintf("%s %s", APP_NAME, APP_VERSION),
    theme = shinytheme("united"),
    tabPanel("Query", source(file.path("ui_code", "0000_ui_infile.R"),  local = TRUE)$value),
    tabPanel("Chebi", source(file.path("ui_code", "0100_ui_chebi.R"),  local = TRUE)$value),
    tabPanel("Kegg", source(file.path("ui_code", "0200_ui_kegg.R"),  local = TRUE)$value),
    tabPanel("Pathway", source(file.path("ui_code", "0300_ui_pathway.R"),  local = TRUE)$value),
    tabPanel("Lipid Maps", source(file.path("ui_code", "0400_ui_lipidmaps.R"),  local = TRUE)$value),
    tabPanel("HMDB", source(file.path("ui_code", "0500_ui_hmdb.R"),  local = TRUE)$value),
    tabPanel("MTAN", source(file.path("ui_code", "0600_ui_mtan.R"),  local = TRUE)$value),
    tabPanel("Output", source(file.path("ui_code", "1000_ui_outfile.R"),  local = TRUE)$value)
  )
)

cat("\n\n Over to you!\n\n")    

shinyApp(ui, server)