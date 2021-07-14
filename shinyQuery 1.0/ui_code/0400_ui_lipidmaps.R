sidebarLayout(
  sidebarPanel(
    h4("Customise table"),
    uiOutput("lipid_maps_col_selector"),
    hr(style="border-color: black;"),
    h4("Expand list"),
    p("show complete entry of cell of selected row"),
    uiOutput("lipid_maps_col_record"),
    textOutput("lipid_maps_cell_record")
  ),
  mainPanel(
    h4("Your Lipid Maps matches"),
    DT::dataTableOutput("lipid_maps_contents")
  )
)