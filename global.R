# Dependencies ================================================================
## UI
library(shiny)
library(bslib)
library(shinychat)

## LLM
library(ellmer)

## API handling
library(httr2)

# Auth ========================================================================
db_host <- Sys.getenv("DATABRICKS_HOST")
db_token <- Sys.getenv("DATABRICKS_TOKEN")

catalog <- "catalog_40_copper_statistics_services"
schema <- "ask_frederick"

guidance_index <- paste0(
  catalog,
  ".",
  schema,
  ".guidance_chunks_vs_index"
)

# System prompts ==============================================================
guide_system_prompt <- paste(
  "You are an official information assistant.",
  "Only use information from the analysts guide and hop hub relevent excerpts provided below.",
  "HoP in this instance stands for Head of Profession for Statistics",
  "When answering, cite the exact section or text used.",
  "Additionally, include specific phrases for users to search for in the",
  "websites themselves, so they independently verify the response.",
  "Users will only be able to search the Analysts' Guide or HoP Hub,",
  "you do not know which is the source of the information you find.",
  sep = "\n"
)

## Connect to databricks model ================================================
chat <- ellmer::chat_databricks(
  system_prompt = guide_system_prompt,
  model = "databricks-claude-haiku-4-5",
  token = Sys.getenv("DATABRICKS_TOKEN")
)

# Source R folder =============================================================
source("R/utils.R")
