###########################################################
#  CODEALPHA_ToolOverloadAnalytics
#  Script: Course_Metadata_Scraper.R
#  Purpose: Scrape public "Data Analytics" course metadata
#           from Coursera, Udemy, edX, and FutureLearn.
#  Author:  Agbo Emmanuel
#  ---------------------------------------------------------
#  Output:  ../Data/Course_Info.csv
###########################################################

# ---- Libraries ----
library(rvest)
library(dplyr)
library(purrr)
library(stringr)

clean_text <- function(x) {
  x <- gsub("[\n\r\t]", "", x)     # remove line breaks and tabs
  x <- str_squish(x)               # remove extra spaces
  return(x)
}

# =========================================================
# 1️⃣  SCRAPE COURSERA
# =========================================================
cat("Scraping Coursera...\n")

coursera_url <- "https://www.coursera.org/search?query=data%20analytics"
coursera_page <- read_html(coursera_url)

# Extract course titles and info
coursera_titles   <- coursera_page %>% html_text2(html_elements(coursera_page, ".cds-ProductCard-title"))
coursera_partners <- coursera_page %>% html_text2(html_elements(coursera_page, ".cds-ProductCard-partner-name"))
coursera_ratings  <- coursera_page %>% html_text2(html_elements(coursera_page, ".cds-Rating-stars"))
coursera_links    <- coursera_page %>% html_attr(html_elements(coursera_page, "a"), "href")

# Build Coursera dataframe
coursera_df <- data.frame(
  CourseTitle = clean_text(coursera_titles),
  Partner     = clean_text(coursera_partners),
  Rating      = clean_text(coursera_ratings),
  Platform    = "Coursera",
  URL         = paste0("https://www.coursera.org", coursera_links[1:length(coursera_titles)])
)

# =========================================================
# 2️⃣  SCRAPE UDEMY
# =========================================================
cat("Scraping Udemy...\n")

udemy_url <- "https://www.udemy.com/courses/search/?q=data%20analytics"
udemy_page <- read_html(udemy_url)

udemy_titles   <- udemy_page %>% html_text2(html_elements(udemy_page, ".course-card--course-title--2f7tE"))
udemy_instructors <- udemy_page %>% html_text2(html_elements(udemy_page, ".udlite-text-sm"))
udemy_ratings  <- udemy_page %>% html_text2(html_elements(udemy_page, ".star-rating--rating-number--3lVe8"))
udemy_links    <- udemy_page %>% html_attr(html_elements(udemy_page, "a"), "href")

udemy_df <- data.frame(
  CourseTitle = clean_text(udemy_titles),
  Partner     = clean_text(udemy_instructors),
  Rating      = clean_text(udemy_ratings),
  Platform    = "Udemy",
  URL         = paste0("https://www.udemy.com", udemy_links[1:length(udemy_titles)])
)

# =========================================================
# 3️⃣  SCRAPE EDX
# =========================================================
cat("Scraping edX...\n")

edx_url <- "https://www.edx.org/search?q=data+analytics"
edx_page <- read_html(edx_url)

edx_titles   <- edx_page %>% html_text2(html_elements(edx_page, ".discovery-card-title"))
edx_partners <- edx_page %>% html_text2(html_elements(edx_page, ".provider"))
edx_links    <- edx_page %>% html_attr(html_elements(edx_page, "a"), "href")

edx_df <- data.frame(
  CourseTitle = clean_text(edx_titles),
  Partner     = clean_text(edx_partners),
  Rating      = NA,
  Platform    = "edX",
  URL         = paste0("https://www.edx.org", edx_links[1:length(edx_titles)])
)

# =========================================================
# 4️⃣  SCRAPE FUTURELEARN
# =========================================================
cat("Scraping FutureLearn...\n")

future_url <- "https://www.futurelearn.com/courses?filter_category=Data%20Analytics"
future_page <- read_html(future_url)

future_titles   <- future_page %>% html_text2(html_elements(future_page, ".m-card__title"))
future_partners <- future_page %>% html_text2(html_elements(future_page, ".m-card__partner"))
future_links    <- future_page %>% html_attr(html_elements(future_page, "a"), "href")

future_df <- data.frame(
  CourseTitle = clean_text(future_titles),
  Partner     = clean_text(future_partners),
  Rating      = NA,
  Platform    = "FutureLearn",
  URL         = paste0("https://www.futurelearn.com", future_links[1:length(future_titles)])
)

# =========================================================
# 5️⃣  COMBINE ALL DATASETS
# =========================================================
cat("Combining all platforms...\n")

all_courses <- bind_rows(coursera_df, udemy_df, edx_df, future_df)

# Remove duplicates and missing titles
all_courses <- all_courses %>%
  filter(CourseTitle != "") %>%
  distinct(CourseTitle, Platform, .keep_all = TRUE)

# =========================================================
# 6️⃣  SAVE TO CSV
# =========================================================
cat("Saving file to Data/Course_Info.csv...\n")

write.csv(all_courses, "../Data/Course_Info.csv", row.names = FALSE)

cat("✅ Done! You can now open Data/Course_Info.csv to see your results.\n")