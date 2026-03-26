vs_query <- function(query_text, index_name, num_results = 5L) {
  resp <- request(paste0(
    "https://",
    db_host,
    "/api/2.0/vector-search/indexes/",
    index_name,
    "/query"
  )) |>
    req_auth_bearer_token(db_token) |>
    req_body_json(list(
      query_text = query_text,
      columns = list("chunk_id", "text", "source_url"),
      num_results = num_results
    )) |>
    req_perform() |>
    resp_body_json()

  # Parse the response into a data frame
  cols <- vapply(resp$manifest$columns, \(c) c$name, character(1))
  rows <- resp$result$data_array
  df <- do.call(
    rbind,
    lapply(rows, \(r) {
      setNames(as.data.frame(r, stringsAsFactors = FALSE), cols)
    })
  )
  df
}
