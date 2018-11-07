# Scratch file for working with the files in data. I load (also known as
# "attach") the three libraries that are most useful, I think, for this sort of
# work. One of my roles is to point out which packages are useful. Including the
# package name (or "tidyverse" or "dplyr") when googling will often lead to
# better results than a straight google.

library(tidyverse)
library(dplyr)
library(stringr)
library(fs)
library(purrr)

# 1. Read data/ex_926_I.csv into a tibble and provide a summary.

x_926 <- read_csv("data/ex_926_I.csv")
summary(x_926)

# 2. Create a vector with all the file names in data/.

file_names <- dir_ls("data/")

# 3. Create a vector with just the file names that have an "A" in them.

names_with_a <- dir_ls("data/", regexp = "A")

also_names_with_a <- str_subset(file_names, pattern = "A")

# 4. Read in all the files into one big tibble. Check out ?map_dfr . . .
# Background reading here:
# https://r4ds.had.co.nz/iteration.html#the-map-functions

big_data <- map_dfr(file_names, read_csv)

# 5. Read in everything and also add a new variable, source, which records the
# file name from which the data came.

data_source <- map_dfr(file_names, read_csv, .id = "source")

# 6. Find the 4 files with the largest number of observations.

fourfiles <- data_source %>%
  group_by(source) %>%
  count() %>%
  arrange(desc(n)) 

# 7. Write a function which takes a character string like "A" and then reads in
# all the files which have "A" in the name.

read_A <- function(x) {
  file_names <- dir_ls("data/")
  file_names_A <- str_subset(file_names, pattern = x)
  output <- map_dfr(file_names_A, read_csv, .id = "source")
  output
}

# 8. Create a Shiny App which displays the histogram of b, allowing the user to
# subset the display for specific values of c.

