ui <- page_sidebar(
  title = "Ask Frederick",
  sidebar = sidebar(
    img(
      src = "jeeves-frederick.png",
      style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"
    ),
    selectInput(
      "chat_mode",
      "Choose chat mode:",
      choices = c(
        "Guidance search" = "guidance",
        "Data interrogator" = "data_interrogator",
        "Code review" = "review",
        "EES changes" = "changes",
        "Hype me up" = "hype"
      )
    )
  ),
  tags$head(
    shinyjs::useShinyjs(),
    includeHTML("google-analytics.html")
  ),

  # Logo
  #conditionalPanel(
  #  condition = "input.chat_mode == 'guidance'",
  #  img(
  #    src = "guidance-frederick.png",
  #    style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"
  #  )
  #),
  conditionalPanel(
    condition = "input.chat_mode == 'data_interrogator'",
    img(
      src = "data-interrogator-frederick.png",
      style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"
    )
  ),
  conditionalPanel(
    condition = "input.chat_mode == 'review'",
    img(
      src = "code-frederick.png",
      style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"
    )
  ),
  conditionalPanel(
    condition = "input.chat_mode == 'changes'",
    img(
      src = "changes-frederick.png",
      style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"
    )
  ),
  conditionalPanel(
    condition = "input.chat_mode == 'hype'",
    img(
      src = "hype-frederick.png",
      style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"
    )
  ),

  # Description
  conditionalPanel(
    condition = "input.chat_mode == 'data_interrogator'",
    p("Frederick will analyse your dataset and answer your questions about it.")
  ),
  conditionalPanel(
    condition = "input.chat_mode == 'review'",
    p("Frederick will review your code and provide feedback.")
  ),
  conditionalPanel(
    condition = "input.chat_mode == 'changes'",
    p(
      "Frederick will summarise any changes and improvements to Explore education statistics (EES) since the date you specify."
    )
  ),
  conditionalPanel(
    condition = "input.chat_mode == 'hype'",
    p(
      "Frederick will give you a personalised hype message to boost your motivation!"
    )
  ),

  # Main dynamic content area to prevent layout jumps
  div(
    id = "main-content",
    style = "min-height: 400px;",
    uiOutput("main_ui")
  )
)
