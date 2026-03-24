
ui <- page_sidebar(
  title = "My dashboard",
  sidebar = "Sidebar",
  "Main content area"
)


ui <- page_sidebar(
  title = "Ask Frederick",
  sidebar = sidebar(
    img(src = "jeeves-frederick.png",style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"),
    selectInput(
      "chat_model",
      "Choose chat model:",
      choices = c(
        "Guidance search" = "guidance",
        "Data interrogator" = "data_interrogator",
        "Code review" = "review",
        "EES changes" = "changes",
        "Hype me up" = "hype"
      )
    )
  ),
    
    uiOutput("response_logo"),
    uiOutput("response_description"),
    uiOutput("chat_controls"),
    uiOutput("chat_response")

)
