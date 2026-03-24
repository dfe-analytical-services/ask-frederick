server <- function(input, output, session) {
  output$chat_controls <- renderUI({
    switch(
      input$chat_model,
      guidance = tagList(
        textInput("guidance_question", "Your question:", ""),
        actionButton("guidance_submit", "Ask")
      ),
      data_interrogator = tagList(
        fileInput("csv_upload", "Upload CSV file"),
        textInput("data_question", "Ask about your data:", ""),
        actionButton("data_submit", "Ask")
      ),
      review = tagList(
        fileInput("code_upload", "Upload code"),
        textAreaInput("code_text", "Paste code here:", "", rows = 8),
        actionButton("review_submit", "Review")
      ),
      changes = tagList(
        dateInput("since_date", "Pick a date:"),
        actionButton("changes_submit", "Show changes")
      ),
      hype = tagList(
        textInput("hype_name", "What's your name?", ""),
        textInput("hype_goal", "What's up?", ""),
        actionButton("hype_submit", "Hype me up!")
      )
    )
  })

output$response_logo <- renderUI({
  switch(
    input$chat_model,
    guidance = img(src = "guidance-frederick.png", style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"),
    data_interrogator = img(src = "data-interrogator-frederick.png", style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"),
    review = img(src = "code-frederick.png", style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"),
    changes = img(src = "changes-frederick.png", style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"),
    hype = img(src = "hype-frederick.png", style = "height:300px; width:auto; display:block; margin-left:0; margin-right:auto;"),
    NULL
  )
})

  output$response_description <- renderUI({
    switch(
      input$chat_model,
      guidance = "Frederick will search available guidance to provide the answers to your questions.",
      data_interrogator = "Frederick will analyse your dataset and answer your questions about it.",
      review = "Frederick will review your code and provide feedback.",
      changes = "Frederick will summarise any changes and improvements to Explore education statistics (EES) since the date you specify.",
      hype = "Frederick will give you a personalised hype message to boost your motivation!"
    )
  })

output$chat_response <- renderUI({
  switch(
    input$chat_model,
    guidance = if (!is.null(input$guidance_submit) && input$guidance_submit > 0) verbatimTextOutput("guidance_response"),
    data_interrogator = if (!is.null(input$data_submit) && input$data_submit > 0) verbatimTextOutput("data_response"),
    review = if (!is.null(input$review_submit) && input$review_submit > 0) verbatimTextOutput("review_response"),
    changes = if (!is.null(input$changes_submit) && input$changes_submit > 0) verbatimTextOutput("changes_response"),
    hype = if (!is.null(input$hype_submit) && input$hype_submit > 0) verbatimTextOutput("hype_response"),
    "Select a chat model and submit to see the response."
  )
})



  output$guidance_response <- renderText({
    req(input$guidance_submit)
    paste("Frederick received:", input$guidance_question)
  })

  output$data_response <- renderText({
    req(input$data_submit)
    if (!is.null(input$csv_upload)) {
      paste("Frederick received uploaded file:", input$csv_upload$name)
    } else if (nzchar(input$data_question)) {
      paste("Frederick received question about data:\n", input$data_question)
    } else {
      "Please upload a CSV or ask a question about your data."
    }
  })

  output$review_response <- renderText({
    req(input$review_submit)
    if (!is.null(input$code_upload)) {
      paste("Frederick received uploaded file:", input$code_upload$name)
    } else if (nzchar(input$code_text)) {
      paste("Frederick received pasted code:\n", input$code_text)
    } else {
      "Please upload or paste your code."
    }
  })

  output$changes_response <- renderText({
    req(input$changes_submit)
    paste("Frederick will show changes since:", as.character(input$since_date))
  })

output$hype_response <- renderText({
  req(input$hype_submit)
  greatness <- c(
    paste(input$hype_name, "you are the best!"),
    paste(input$hype_name, "the greatest statistician!"),
    paste(input$hype_name, "your skills are legendary!"),
    paste(input$hype_name, "you inspire everyone!"),
    paste(input$hype_name, "you’re unstoppable!")
  )
  motivation <- c(
    "Keep going!",
    "You got this!",
    "Don’t stop now!",
    "Stay awesome!",
    "The world needs your stats!"
  )
  paste(sample(greatness, 1), sample(motivation, 1), sep = "\n")
})

}

