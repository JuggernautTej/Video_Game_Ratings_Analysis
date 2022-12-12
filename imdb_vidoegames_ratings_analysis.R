library(tidyverse)
library(ggplot2)
library(lubridate)
?lubridate
library(readr)
library(dplyr)
imdb_videogame_ratings <- read_csv("DA Portfolio/Data sets/imdb_video_game_rating.csv")
view(imdb_videogame_ratings)
str(imdb_videogame_ratings)

#Cleaned the dataset. I first removed the first column
imdb_videogame_ratings_cleaned <- subset(imdb_videogame_ratings,select= -c(...1))
view(imdb_videogame_ratings_cleaned)
str(imdb_videogame_ratings_cleaned)
sapply(imdb_videogame_ratings_cleaned, mode)
sapply(imdb_videogame_ratings_cleaned,class)

# I changed the year and vote columns to integer

imdb_videogame_ratings_cleaned <- transform(imdb_videogame_ratings,year=
                                              as.integer(year), votes=
                                              as.integer(votes))
#removed values with NA year entries 
imdb_videogame_ratings_completeyears <- imdb_videogame_ratings_cleaned %>% 
  drop_na()

imdb_videogame_ratings_completeyears <- subset(
  imdb_videogame_ratings_completeyears,select= -c(...1))
glimpse(imdb_videogame_ratings_cleaned)
summary(imdb_videogame_ratings_cleaned)

## Data Exploratory
# Ratings; 1. Top 10 rated games
head(arrange(imdb_videogame_ratings_cleaned,desc(rating)), n=10)

# 2. Number of Games done per decade
imdb_videogame_ratings_completeyears$Decade<- (as.integer(
  imdb_videogame_ratings_completeyears$year/10)*10)
no_of_games_per_decade<-imdb_videogame_ratings_completeyears %>%
  group_by(Decade) %>% summarise(  number_of_games_produced= n())
ggplot(data = no_of_games_per_decade,
       mapping= aes(x=Decade,y=number_of_games_produced))+
  geom_bar(stat="identity") + labs(title="Video Games Produced per Decade")

#3. Distribution of ratings
ggplot(data= imdb_videogame_ratings_cleaned, mapping = aes(x=rating))+
  geom_histogram(fill="#69b3a2", color="#e9ecef", alpha=0.9)+
  geom_vline(aes(xintercept = mean(rating)),col = "red",lwd = 2)+ 
  annotate("text",x = 10,
           y = 700,
           label = paste("Mean =", signif(
             mean(imdb_videogame_ratings_cleaned$rating)), digits=3),
           col = "red",size = 5) + 
  geom_vline(aes(xintercept = median(rating)),col = "purple",lwd = 2)+ 
  annotate("text",x = 10, y = 500,label = 
             paste("Median =", signif(
               median(imdb_videogame_ratings_cleaned$rating)),digits=2),
           col = "purple",size = 5)
# to confirm the above
summary(imdb_videogame_ratings_cleaned$rating)

#4. Lowest rated games
head(arrange(imdb_videogame_ratings_cleaned, rating), n=10)
#Which decade produced the majority of the lowest 100 rated games
lowest_rated_video_games <- head(arrange(imdb_videogame_ratings_completeyears,
                                         rating),n=100)

head(arrange((lowest_rated_video_games %>%group_by(Decade) %>% 
  summarise(number_of_games_produced = n()) ),desc(number_of_games_produced)),
  n=1)
lowest_rated_video_games_count <-  lowest_rated_video_games %>%
  group_by(Decade) %>% dplyr:: summarise(number_of_games_produced = n())
ggplot(data = lowest_rated_video_games_count,
       mapping= aes(x=Decade,y=number_of_games_produced, 
                    fill=number_of_games_produced))+ geom_bar(stat="identity") + 
  labs(title="Number of Lowest Rated Games per Decade")

#5.Lowest ratest games in the 2020s
print(lowest_rated_video_games %>% filter(Decade==2020))
  
# Weighted Rating
# I am using the formula provided by nyagami
# Weighted rating (WR) = (v/(v + m)) * R + ( m / (v + m)) * C
# where:
# R = average for the movie (mean) = (Rating)
# v = number of votes for the movie = (votes)
# m = minimum votes required to be listed in the Top 50 (currently 1000)
# C = the mean vote across the whole report

v= imdb_videogame_ratings_cleaned$votes
m= 1000
R= imdb_videogame_ratings_cleaned$rating
C= round(mean(imdb_videogame_ratings_cleaned$rating), digits = 2)

# I created weighted rating column
imdb_videogame_ratings_cleaned$Weighted_Rating <- ((v/(v+m))*R + (m/(v+m))*C)

#Show top 50 results
game_ranking<- imdb_videogame_ratings_cleaned %>%
  select(title,rating,votes,Weighted_Rating) 
top_50_games_WR <- head(arrange(game_ranking,desc(Weighted_Rating)), n=50)

#Relationships  between variables; has the average rating of video games
#changed or remained constant over the years?

ggplot(data = imdb_videogame_ratings_completeyears, 
       mapping = aes(x=year,y=rating))+ geom_point( color= "red")+
  geom_smooth(method = lm, color="black", se=FALSE)+
  labs(title="Relationship between year of launch and rating ")

#There is a positive correlation between the rating and release year
# Relationship between the number of votes and rating
ggplot(data = imdb_videogame_ratings_completeyears, 
       mapping = aes(x=votes,y=year))+ geom_point( color= "red")+
  geom_smooth(method = lm, color="black", se=FALSE)+
  labs(title="Relationship between number of votes and rating of video games ")
# The correlation between these two variables is none linear
# To get a positive correlation between these two variables, I took the log of them
ggplot(data = imdb_videogame_ratings_completeyears, 
       mapping = aes(x=log(votes),y=log(rating)))+ geom_point( color= "red")+
  geom_smooth(method = lm, color="black", se=FALSE)+
    labs(title="Relationship between log votes and log rating ")
  
