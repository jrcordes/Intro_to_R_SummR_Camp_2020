# Installing and loading a package library
# install.packages("tidyverse")
library(tidyverse)

# Vector, matrix, and dataframe
vector_example <- c(1, 2, 3)
matrix_example <- matrix(data = c(1,2,3,4,5,6), nrow = 3, ncol = 2)
dataframe_example <- data.frame(matrix_example)

# Select a particular row from a dataframe
print(dataframe_example$X1)

# Add a column to a dataframe using cbind...by creating a new column and populating
dataframe_cbind <- cbind(matrix_example, vector_example)

# Or by creating a new column and populating
dataframe_example$vector_example <- vector_example

# Make a new column based on existing columns using mutate
dataframe_example <- mutate(dataframe_example, X3 = X1*X2)

# Same mutate operation as above but using a pipe
dataframe_example <- dataframe_example %>% mutate(X3 = X1*X2)

# Subset a dataframe by selecting particular columns using select
dataframe_select <- dataframe_example %>% select(c(X1, X3))

# Subset a dataframe by selecting particular rows that meet a condition using filter
dataframe_filter <- dataframe_example %>% filter(X3 > 5)

# Sample American Community Survey Data for NYC from 2018
acs <- read.csv(file = here::here("nyc_acs_2018.csv"))

# Create a new variable based on a condition of another variable
# NOTE THAT THIS IS JUST AN EXAMPLE - THESE ZIP CODES DO NOT CORRESPOND TO THE DESIGNATED BOROUGHS
acs <- acs %>% mutate(BOROUGH = case_when(ZCTA5A < 10500 ~ "Manhattan",
                                          ZCTA5A < 10900 ~ "Brooklyn",
                                          ZCTA5A < 11100 ~ "Queens",
                                          ZCTA5A < 11400 ~ "Bronx",
                                          TRUE ~ "Staten Island"))

# Create a new variable based on whether percentage with at least a bachelor's degree is less than 30%
acs <- acs %>% mutate(EDUC = case_when(PER_BGRAD < 0.3 ~ 0,
                                       TRUE ~ 1))

# Example scatter plot of rent >= 50% of income and median household income with facetting and loess lines
ggplot(acs) + 
  geom_jitter(aes(x = RENT_50, y = MED_INC, color = factor(BOROUGH)), alpha = 0.3) + 
  geom_smooth(aes(x = RENT_50, y = MED_INC, color = factor(BOROUGH)), method = "loess", se = F) + 
  facet_grid(cols = vars(EDUC), labeller = labeller(EDUC = c("0" = "Low Education", "1" = "High Education"))) + 
  labs(title = "Relationship between rent and median income", 
       subtitle = "By Borough, with Loess curves", x = "Rent 50% of Income", y = "Median Income") + 
  scale_color_manual(values = c("purple", "blue", "green", "yellow", "red"), name = "Borough", 
                     labels = c("Bronx", "Brooklyn", "Manhattan", "Queens", "Staten Island")) + 
  theme_minimal() + 
  theme(legend.position = "bottom")