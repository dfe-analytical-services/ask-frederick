# Ask Frederick

Ask Frederick is a Shiny app that provides AI-powered assistance for analysts and statisticians. As a starting point we're considering offering:

- Guidance search: Answers questions using the Analysts' Guide and HoP Hub materials
- Data interrogator: Analysing uploaded CSV datasets and answering user queries
- Code review: Reviewing uploaded or pasted code and providing feedback
- EES changes: Summarising changes to Explore Education Statistics since a specified date
- Hype me up: Generating motivational messages

## Requirements

You will need access to:
- Statistics services databricks catalog
- Databricks foundation models

You will need to set the following environment variables:
- `DATABRICKS_HOST`
- `DATABRICKS_TOKEN`

## Guidance Frederick

- We've set up a basic RAG architecture to pull in .Qmd files from the Analysts Guide and HoP Hub, chunk them up and index them in a vector database
- There is a databricks workflow defined for this in the `pipelines` folder

## Minimal shinychat with databricks example

Incase you want to experiment yourself, here's a minimal example to get you going with using shinychat / ellmer / databricks models:

``` r {app.R}
library(shiny)
library(bslib)
library(shinychat)
library(ellmer)

## Connect to databricks model ================================================
chat <- ellmer::chat_databricks(
  # Automatically uses DATABRICKS_HOST env var if `workspace` not set
  system_prompt = NULL,
  model = "databricks-meta-llama-3-1-70b-instruct",
  token = Sys.getenv("DATABRICKS_TOKEN")
)

## Example basic app ==========================================================
ui <- bslib::page_fillable(
  chat_ui(
    id = "chat",
    messages = "Hey, hey, hey! How can I help you today?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
```

## Contact

cameron.race@education.gov.uk and laura.selby@education.gov.uk