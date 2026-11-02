movie <- read.csv('box_office.csv')
View(movie)

movie <- na.omit(movie) #Remove data with NA 
movie <- movie[, -1] #Remove rank column
movie <- movie[movie$Genres != "", ]
movie <- movie[movie$Production_Countries != "", ]

hist(movie$X.Worldwide, main = "Histogram of worldwide revenue")
hist(log(movie$X.Worldwide), main = "Histogram of logarithmic worldwide revenue")

hist(movie$Vote_Count)
hist(log(movie$Vote_Count))

movie$Rating <- as.numeric(sub("/10", "", movie$Rating))
hist(movie$Rating)
movie <- movie[movie$Vote_Count >= 30, ] #Set minimum number of votes = 30

all_genres <- unique(unlist(strsplit(movie$Genres, ", ")))
for (genre in all_genres) {
  movie[[genre]] <- as.integer(grepl(genre, movie$Genres))  # Create binary indicator for each genre
}

names(movie)[names(movie) == "TV Movie"] <- "TV_Movie"
names(movie)[names(movie) == "Science Fiction"] <- "Science_Fiction"

# Get a list of genre names
genre_list <- colnames(movie)[which(names(movie) == "Adventure"):which(names(movie) == "TV_Movie")]

# Create a list to store revenue values for each genre
boxplot_data <- lapply(genre_list, function(genre) {
  log(movie$X.Worldwide)[movie[[genre]] == 1]  # Select log revenue for movies in that genre
})

# Create a boxplot with all genres side by side
boxplot(boxplot_data, 
        names = genre_list,  # Use genre names as labels
        las = 2,  # Rotate x-axis labels for readability
        col = "lightblue", 
        main = "Log Revenue by Genre", 
        ylab = "Log Revenue", 
        xlab = "Genres")  

genre_matrix <- data.matrix(movie[, which(names(movie) == "Adventure"):which(names(movie) == "TV_Movie")])
co_occurrence <- t(genre_matrix) %*% genre_matrix
co_occurrence_percent <- co_occurrence / diag(co_occurrence)

library(ggplot2)
library(reshape2)

co_occurrence_df <- melt(co_occurrence_percent)

ggplot(co_occurrence_df, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +  
  scale_fill_gradient(low = "white", high = "red") +  
  labs(title = "Genre Co-Occurrence Heatmap", x = "Genres", y = "Genres") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +  
  geom_text(aes(label = round(value, 1)), color = "black", size = 3)

lm_model <-lm(log(X.Worldwide) ~ Adventure + Action + Thriller + Drama + Comedy +
                Romance + Animation + Family + Fantasy + Science_Fiction +
                Horror + Mystery + Crime + History + War + Music + Western +
                Documentary + TV_Movie, data = movie)
summary(lm_model)

library(glmnet)

# Prepare the model matrix
X <- model.matrix(log(X.Worldwide) ~ Adventure + Action + Thriller + Drama + Comedy + 
                    Romance + Animation + Family + Fantasy + Science_Fiction + 
                    Horror + Mystery + Crime + History + War + Music + 
                    Western + Documentary + TV_Movie, data = movie)[, -1]  # Remove intercept

# Response variable
y <- log(movie$X.Worldwide)

# Fit Lasso model (alpha = 1)
lasso_model <- glmnet(X, y, alpha = 1)

# Cross-validation to find optimal lambda
cv_lasso <- cv.glmnet(X, y, alpha = 1)
best_lambda <- cv_lasso$lambda.min

# Fit the final Lasso model
final_lasso <- glmnet(X, y, alpha = 1, lambda = best_lambda)

# Coefficients
coef(final_lasso)

# Fit ANOVA model
anova_result <- aov(log(X.Worldwide) ~ Adventure + Action + Thriller + Drama + Comedy +
                      Romance + Animation + Family + Fantasy + Science_Fiction +
                      Horror + Mystery + Crime + History + War + Music + Western +
                      Documentary + TV_Movie, data = movie)  
summary(anova_result)

# Performing Kruskal-Wallis test for each genre
kruskal_results <- list()

# List of genre variables
genres <- c("Adventure", "Action", "Thriller", "Drama", "Comedy", 
            "Romance", "Animation", "Family", "Fantasy", 
            "Science_Fiction", "Horror", "Mystery", 
            "Crime", "History", "War", "Music", 
            "Western", "Documentary", "TV_Movie")

# Loop through each genre and run the Kruskal-Wallis test
for (genre in genres) {
  formula <- as.formula(paste("log(X.Worldwide) ~", genre))
  kruskal_results[[genre]] <- kruskal.test(formula, data = movie)
}

# Print results
kruskal_results

plot(movie$Rating, log(movie$X.Worldwide))

lm_rev_rating <- lm(log(X.Worldwide) ~ Rating, data = movie)
summary(lm_rev_rating)

plot(movie$Rating * log(movie$Vote_Count), log(movie$X.Worldwide))
cor(movie$Rating * log(movie$Vote_Count), log(movie$X.Worldwide))

movie$pop <- movie$Rating * log(movie$Vote_Count)
lm_fit <- lm(log(movie$X.Worldwide) ~ movie$pop)
summary(lm_fit)
abline(lm(log(movie$X.Worldwide) ~ movie$pop), col = "red")


hist(movie$Foreign.., breaks = 100)

# Filter for domestic-only (0-5%) and international-only (95-100%)
edge_cases <- subset(movie, Foreign.. <= 5 | Foreign.. >= 95)
edge_cases$Release_Type <- ifelse(edge_cases$Foreign.. <= 5, "Domestic Only", "International Only")

table(edge_cases$Original_Language, edge_cases$Release_Type)

filtered_movies <- movie[movie$Foreign.. > 5 & movie$Foreign.. < 95, ]
avg_foreign_by_lang <- tapply(filtered_movies$Foreign.., 
                              filtered_movies$Original_Language, 
                              mean, na.rm = TRUE)
sorted_avg <- sort(avg_foreign_by_lang, decreasing = TRUE)
print(round(sorted_avg, 2))
barplot(sorted_avg,
        las = 2,
        col = "salmon",
        main = "Average % of International Revenue by Language",
        ylab = "Average % International Revenue")
boxplot(Foreign.. ~ Combined_Language, 
        data = filtered_movies,
        las = 2,                      # Rotate axis labels for readability
        col = "lightblue",
        main = "% of International Revenue by Movie Language",
        ylab = "Foreign Revenue (%)",
        xlab = NA)             
View(filtered_movies)

# Create a Combined Language Column
filtered_movies$Combined_Language <- filtered_movies$Original_Language

# Grouping languages accordingly
filtered_movies$Combined_Language[filtered_movies$Original_Language %in% c("hi", "ta", "te")] <- "Indian"
filtered_movies$Combined_Language[filtered_movies$Original_Language %in% c("zh", "cn")] <- "Chinese"
filtered_movies$Combined_Language[filtered_movies$Original_Language == "ja"] <- "Japanese"
filtered_movies$Combined_Language[filtered_movies$Original_Language == "ko"] <- "Korean"
filtered_movies$Combined_Language[filtered_movies$Original_Language == "fr"] <- "French"
filtered_movies$Combined_Language[filtered_movies$Original_Language == "de"] <- "German"
filtered_movies$Combined_Language[filtered_movies$Original_Language == "es"] <- "Spanish"
filtered_movies$Combined_Language[filtered_movies$Original_Language == "it"] <- "Italian"
filtered_movies$Combined_Language[filtered_movies$Original_Language %in% c("sv", "da", "nl", "no", "fi")] <- "Nordic"
# Include English in its own group
filtered_movies$Combined_Language[filtered_movies$Original_Language == "en"] <- "English"

# Count occurrences of each combined language
language_counts <- table(filtered_movies$Combined_Language)

# Identify valid languages with at least 5 occurrences
valid_languages <- names(language_counts[language_counts >= 5])

# Filter the dataset to keep only rows with valid languages
filtered_movies_valid <- filtered_movies[filtered_movies$Combined_Language %in% valid_languages, ]

boxplot(Foreign.. ~ Combined_Language, 
        data = filtered_movies_valid,
        las = 2,
        col = "lightblue",
        main = "% of International Revenue by Language",
        ylab = "Foreign Revenue (%)",
        xlab = NA)
