sidebarLayout(
  sidebarPanel(
    h4("Customise table"),
    uiOutput("mtan_col_selector"),
    hr(style="border-color: black;"),
    h4("Expand list"),
    p("show complete entry of cell of selected row"),
    uiOutput("mtan_col_record"),
    textOutput("mtan_cell_record")
  ),
  mainPanel(
    h4("Your Metaboanalyst db matches"),
    DT::dataTableOutput("mtan_contents")
  )
)