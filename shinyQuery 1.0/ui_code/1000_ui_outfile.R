fluidPage(
  fluidRow(
    column(
      3,
      wellPanel(
      h4("Options"),
      radioButtons(
        inputId = "outfile_chebi_include",
        label = "Save CHEBI table",
        choices = c("Yes", "No"),
        selected = "Yes",
        inline = T
      ),
      radioButtons(
        inputId = "outfile_kegg_include",
        label = "Save KEGG table",
        choices = c("Yes", "No"),
        selected = "Yes",
        inline = T
      ),
      radioButtons(
        inputId = "outfile_lipid_maps_include",
        label = "Save LIPID MAPS table",
        choices = c("Yes", "No"),
        selected = "Yes",
        inline = T
      ),
      radioButtons(
        inputId = "outfile_hmdb_include",
        label = "Save HMDB table",
        choices = c("Yes", "No"),
        selected = "Yes",
        inline = T
      ),
      radioButtons(
        inputId = "outfile_mtan_include",
        label = "Save MTAN table",
        choices = c("Yes", "No"),
        selected = "Yes",
        inline = T
      ),
      radioButtons(
        inputId = "outfile_pathway_include",
        label = "Save PATHWAY matrix",
        choices = c("Yes", "No"),
        selected = "Yes",
        inline = T
      ),
      radioButtons(
        inputId = "outfile_pathway_filter",
        label = "Filter compounds for selected pathways",
        choices = c("Yes", "No"),
        selected = "No",
        inline = T
      ),
      radioButtons(
        inputId = "outfile_merged_table",
        label = "Create one merged table",
        choices = c("Yes", "No"),
        selected = "No",
        inline = T
      ),
      )
    ),
    column(
      9,
      h4("Merged compound list"),
      DT::dataTableOutput("outlist_final_table")
    )
  ),
  fluidRow(
    column(
      3,
      wellPanel(
        h4("Download"),
        actionButton(
          inputId = "outfile_make",
          label = "Make output"
        ),
        br(),
        br(),
        uiOutput("download_table")
      )
    ),
    column(
      9,
      h4("Pathway matrix"),
      DT::dataTableOutput("outlist_final_table_pathway")
    )
  )
)