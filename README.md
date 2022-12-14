# IMDB Video Game Ratings Analysis

![video_games](https://user-images.githubusercontent.com/88348888/207042146-309c3787-5509-4401-9f6b-0361442da3af.jpg)

This is my take into the analysis of ratings of video games produced between 1948 and 2022. The data set was acquired from Davis Nyagami on Kaggle who scrapped the data
from the imdb website (https://www.kaggle.com/code/nyagami/web-scraping-video-game-ratings-on-imdb).
The dataset consists of details of video games which include;

- Game Title
- Launch Year
- Game Genre
- Game Rating
- Number of Votes
- Director
- Game Description/plot

## Key Actions Taken

### Data Cleaning and Transformation
I focused on harmonizing the data types across the Year and Votes columns in the dataset. Following this, I removed inconsistent data within the dataset and saved 
the results as new datasets. The new datasets are;

- imdb_videogame_ratings_cleaned; The dataset with the converted Year and Votes columns to integer data type.
- imdb_videogame_ratings_completeyears; The dataset with the Year column exclusive of non-integer data.

## Data Exploration
Using the new datasets, I took a look into the following;

- The top and lowest rated games
- The distribution of the ratings 
- The number of games produced per decade
- The weighted rating per video game
- The relationship between variables such as votes and ratings (regression analysis)

The tasks for this project was gotten from Davis Nyagami on Kaggle,https://www.kaggle.com/datasets/nyagami/video-game-ratings-from-imdb.
photo credit; polygon.com
