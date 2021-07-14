fluidPage(
  fluidRow(
    column(
      6,
      wellPanel(
        h4("All pathways"),
        DT::dataTableOutput("kegg_pathways")
      )
    ),
    column(
      6,
      h4("Compounds in pathway"),
      DT::dataTableOutput("selected_pathway_table")
    )
  ),
  fluidRow(
    column(
      4,
      h4("Your selection"),
      uiOutput("outfile_select_pathway"),
    ),
    column(
      8,
      DT::dataTableOutput("outfile_pathways_table")
    )
  )
)