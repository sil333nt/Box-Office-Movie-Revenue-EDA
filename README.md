# Movie Box Office Revenue – Exploratory Data Analysis

## Overview

This project investigates the factors associated with worldwide movie box office revenue through exploratory data analysis (EDA) and statistical modelling. Using a dataset of 5,000 movies released between 2000 and 2024, the analysis examines how movie genres, audience ratings, viewer engagement, and original language relate to financial performance.

The project focuses on three key research questions:

1. **Genre and Revenue:** Do certain movie genres tend to generate higher worldwide box office revenue?
2. **Rating and Revenue:** Are higher audience ratings associated with greater box office success, and does viewer engagement strengthen this relationship?
3. **Original Language and International Revenue:** How does a movie's original language relate to its reliance on international audiences?

## Dataset

- **Source:** [Movies Box Office Dataset (2000–2024) – Kaggle](https://www.kaggle.com/datasets/aditya126/movies-box-office-dataset-2000-2024)
- **Initial observations:** 5,000 unique movies
- **Final dataset:** 4,797 movies after handling missing values

The dataset contains information on:
- Worldwide box office revenue
- Domestic and foreign revenue shares
- Release year
- Movie genres (1–5 genres per movie)
- TMDB ratings and vote counts
- Original language
- Filming locations

## Methodology

### 1. Data Preprocessing

Several preprocessing steps were performed to prepare the dataset for analysis:

- **Missing Values:** Removed movies containing missing values, reducing the dataset from 5,000 to 4,797 observations.
- **Revenue Transformation:** Applied logarithmic transformation to worldwide revenue to address its highly right-skewed distribution.
- **Genre Encoding:** Applied one-hot encoding to convert multiple movie genres into separate binary variables.
- **Rating and Vote Count:** Converted ratings into numerical format and excluded movies with fewer than 30 votes. Logarithmic transformation was also applied to vote counts.
- **Language Grouping:** Consolidated language categories based on shared geographical and linguistic contexts, excluding categories with fewer than five observations and domestic-only or international-only releases.

### 2. Revenue vs Genre

Explored differences in worldwide box office revenue across movie genres using boxplots.

Applied **Lasso Regression** with log-transformed worldwide revenue as the response variable and one-hot encoded genres as predictors. This helps identify genres associated with higher or lower revenue while performing variable selection through coefficient shrinkage.

### 3. Revenue vs Rating

Investigated the relationship between audience ratings and worldwide box office revenue using scatterplots and linear regression.

Introduced a composite variable:

`Rating × log(Vote Count)`

This incorporates both audience ratings and viewer engagement to investigate whether combining the two provides a stronger relationship with box office revenue.

### 4. Original Language vs International Revenue

Examined how the proportion of revenue earned from foreign markets varies across original language groups.

Used boxplots to compare international revenue percentages and identify differences in international market dependence across film industries.

## Key Findings

### Genre and Revenue

- Science Fiction and Adventure movies showed the strongest positive associations with worldwide revenue in the Lasso regression model, both with coefficients of 0.43.
- Action (0.26) and Family (0.22) also showed positive associations.
- Documentary (-0.31) and TV Movie (-0.64) showed negative associations relative to the baseline.
- Several genres, including Thriller, Romance, Animation, Horror, Mystery, and Crime, had coefficients shrunk to zero.

### Rating and Revenue

- Movie ratings alone had a weak linear relationship with worldwide revenue, with an R² of approximately **0.02**.
- The composite variable `Rating × log(Vote Count)` demonstrated a considerably stronger linear relationship, achieving an R² of **0.3633**.
- This suggests that audience engagement, alongside perceived movie quality, provides additional insight into box office performance.

### Original Language and International Revenue

- Most non-English films tended to derive a substantial proportion of their revenue from international markets.
- English-language films exhibited a much wider distribution of foreign revenue percentages.
- These differences highlight how domestic market size and the diversity of film industries may influence international revenue dependence.

## Tools & Techniques

**Programming & Analysis**
- R
- Exploratory Data Analysis
- Data Cleaning and Preprocessing
- Data Transformation
- Data Visualization

**Statistical Methods**
- One-Hot Encoding
- Lasso Regression
- Linear Regression
- Logarithmic Transformation
- Distribution Analysis

**Visualization**
- Histograms
- Boxplots
- Scatterplots
- Co-occurrence Heatmap

## Conclusion

This project highlights several factors associated with worldwide movie box office performance. Genre composition provides useful insights into revenue differences, while audience ratings become substantially more informative when considered alongside viewer engagement. Additionally, original language reveals interesting differences in how films depend on international markets.

Overall, the analysis demonstrates how exploratory data analysis and statistical modelling can be used to investigate patterns in the movie industry and better understand the factors associated with commercial success.
