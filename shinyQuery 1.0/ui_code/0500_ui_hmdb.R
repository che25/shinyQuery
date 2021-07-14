sidebarLayout(
  sidebarPanel(
    h4("Customise table"),
    uiOutput("hmdb_col_selector"),
    hr(style="border-color: black;"),
    h4("Expand list"),
    p("show complete entry of cell of selected row"),
    uiOutput("hmdb_col_record"),
    textOutput("hmdb_cell_record")
  ),
  mainPanel(
    h4("Your HMDB matches"),
    DT::dataTableOutput("hmdb_contents")
  )
)