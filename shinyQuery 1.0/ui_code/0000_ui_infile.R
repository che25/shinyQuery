sidebarLayout(
  sidebarPanel(
    h4("Query"),
    radioButtons(
      inputId = "query_search_type",
      label = "Search type",
      choices = c(
        `Metabolite IDs`="id",
        `Name`="text", 
        `Formula` = "formula",
        `(Partial) INCHI key` = "inchi",
        `Exact mass` = "mass"
        ), 
      selected = "id",
      inline = F
    ),
    radioButtons(
      inputId = "query_input_type",
      label = "Query type",
      choices = c(
        `Single query (text input)` = "single",
        `Batch upload (file upload)` = "batch" 
      ), 
      selected = "single",
      inline = F
    ),
    hr(style="border-color: black;"),
    conditionalPanel(
      condition = "input.query_input_type=='batch'",
      fileInput('file1', 'Choose xlsx file to upload', width = "250px"),
      p("Only first sheet will be read."),
      br(),
      uiOutput("query_col_selector"),
      p("The first column you select will be QUERY.")
    ),
    conditionalPanel(
      condition = "input.query_input_type=='single'",
      textInput(
        inputId = "query_text",
        label = "Your query"
        ),
    ),
    conditionalPanel(
      condition = "input.query_search_type=='mass'",
      textInput(
        inputId = "query_tolerance",
        label = "Tolerance (same units as query)"
      )
    ),
    conditionalPanel(
      condition = "input.query_input_type=='single'",
      actionButton(
        inputId = "query_submit_single",
        label = "Submit"
      )
    ),
    conditionalPanel(
      condition = "input.query_input_type=='batch'",
      actionButton(
        inputId = "query_submit_batch",
        label = "Submit"
      )
    )
  ),
  mainPanel(
    verbatimTextOutput("search_log")
    # conditionalPanel(
    #   condition = "input.query_input_type=='batch'",
    #   h4("Your uploaded file"),
    #   DT::dataTableOutput('infile_contents')
    # ),
    # conditionalPanel(
    #   condition = "input.query_input_type=='single'",
    #   h4("Your query"),
    #   textOutput("query_text_message")
    # )
  )
)

