sidebarLayout(
  sidebarPanel(
    h4("Customise table"),
    uiOutput("kegg_col_selector"),
    hr(style="border-color: black;"),
    h4("Expand list"),
    p("show complete entry of cell of selected row"),
    uiOutput("kegg_col_record"),
    textOutput("kegg_cell_record")
  ),
  mainPanel(
    h4("Your Kegg matches"),
    DT::dataTableOutput("kegg_contents")
  )
)