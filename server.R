server <- function(input, output, session) {
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

  observeEvent(input$reset_chat, {
    chat_clear("chat")
    chat_append("chat", "Chat has been reset. how can I help?")
  })

  observeEvent(input$chat_user_input, {
    # Retrieve relevant excerpts, handle errors gracefully
    chunks <- tryCatch(
      {
        vs_query(
          input$chat_user_input,
          guidance_index,
          num_results = 5
        )
      },
      error = function(e) {
        chat_append(
          "chat",
          "Sorry, there was a problem, this may be because you've hit an API limit for this thread. Please reset the chat."
        )
        return(NULL)
      }
    )

    if (is.null(chunks)) {
      return()
    }

    context_text <- paste(chunks$text, collapse = "\n\n")

    # Combine user input with context
    user_message <- paste(
      input$chat_user_input,
      "\n\nRelevant excerpts:\n",
      context_text
    )

    # Detect sources from chunks (look for 'analyst' or 'hop' in title or source fields)
    chunk_titles <- tolower(as.character(chunks$title))
    chunk_sources <- tolower(as.character(chunks$source))
    found_analyst <- any(grepl("analyst", chunk_titles, ignore.case = TRUE)) ||
      any(grepl("analysts-guide", chunk_sources, ignore.case = TRUE))
    found_hop <- any(grepl("hop-hub", chunk_titles, ignore.case = TRUE)) ||
      any(grepl("hop-hub", chunk_sources, ignore.case = TRUE))
    sources <- c()
    if (found_analyst) {
      sources <- c(sources, "Analysts Guide")
    }
    if (found_hop) {
      sources <- c(sources, "HoP Hub")
    }
    if (length(sources) == 0) {
      sources <- "Unknown - be wary!"
    }

    # Stream response from model
    stream <- chat$stream_async(user_message)

    # Return chat to user
    chat_append("chat", stream)
  })
}
