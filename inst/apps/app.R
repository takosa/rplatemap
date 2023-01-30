library(shiny)
library(rplatemap)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel = sidebarPanel({
      rplatemapOutput("pm", width = "100%", height = "800px")
    }, width = 7),
    mainPanel = mainPanel({
      
    }, width = 5)
  )
)

server <- function(input, output, session) {
  output$pm <- renderRplatemap({
    rplatemap() |>
      add_single_field(
        "Settings", 
        required=TRUE,
        id="text_field",
        name="Text Field",
        type="text"
      ) |>
      add_single_field(
        "Settings", 
        required=FALSE,
        id="boolean_field",
        name="Boolean Field",
        type="boolean"
      ) |>
      add_single_field(
        "Settings", 
        required=FALSE,
        id="numeric_field",
        name="Numeric Field with Units",
        type="numeric",
        units=c("uL", "mL"),
        defaultUnit="uL"
      ) |>
      add_single_field(
        "Settings", 
        required=TRUE,
        id="select_field",
        name="Select Field",
        type="select",
        options=c("Unknown", "Standard", "NTC")
      )
  })
}

shinyApp(ui = ui, server = server)

