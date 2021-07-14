sidebarLayout(
  sidebarPanel(
    h4("Customise table"),
    uiOutput("chebi_col_selector"),
    hr(style="border-color: black;"),
    h4("Expand list"),
    p("show complete entry of cell in selected row"),
    uiOutput("chebi_col_record"),
    textOutput("chebi_cell_record")
  ),
  mainPanel(
    h4("Your Chebi matches"),
    DT::dataTableOutput('chebi_contents')
  )
)
