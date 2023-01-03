# Solutions
## 1. Top Rated Games
````r
head(arrange(imdb_videogame_ratings_cleaned,desc(rating)), n=10) %>%
  select(title,year, rating)
  ````
  
| title                                     | year | rating |
| ----------------------------------------- | ---- | ------ |
| The Last of Us: Part I                    | 2022 | 9.8    |
| Red Dead Redemption II                    | 2018 | 9.7    |
| The Witcher 3: Wild Hunt - Blood and Wine | 2016 | 9.7    |
| The Withcer 2: Wild Hunt                  | 2015 | 9.7    |
| The Last of Us                            | 2013 | 9.7    |
| Mass Effect: Legendary Edition            | 2021 | 9.7    |
| God of War                                | 2018 | 9.6    |
| Persona 5 Royal                           | 2019 | 9.6    |     
| Legend of Zelda: Ocarina of Time          | 1998 | 9.6    |
| Metal Gear Solid                          | 1998 | 9.6    | 

## 2. Number of Games done per decade
````r
imdb_videogame_ratings_completeyears$Decade<- (as.integer(
  imdb_videogame_ratings_completeyears$year/10)*10)
no_of_games_per_decade<-imdb_videogame_ratings_completeyears %>%
  group_by(Decade) %>% summarise(  number_of_games_produced= n())
ggplot(data = no_of_games_per_decade,
       mapping= aes(x=Decade,y=number_of_games_produced))+
  geom_bar(stat="identity") + labs(title="Video Games Produced per Decade")
 ````
 
 ![Video Games per Decade](https://user-images.githubusercontent.com/88348888/210440405-f753fd7b-741e-4448-8672-60cc110f4cbc.jpeg)

## 3. Distribution of ratings
````r
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
           col = "purple",size = 5) + labs(title="Ratings Distribution")
  ````
  
  ![Ratings Distribution](https://user-images.githubusercontent.com/88348888/210443723-202267db-18a0-48d2-94e6-7d09ac405b75.jpeg)

## 4. Lowest Rated Games
````r
head(arrange(imdb_videogame_ratings_cleaned, rating), n=10) %>%
  select(title,year,rating)
 ````
 
| title                     | year | rating |
| ------------------------- | ---- | ------ |
| CrazyBus                  | 2004 | 1.0    |
| Animal Soccer World       | 2005 | 1.2    |
| Action 52                 | 1991 | 1.3    |
| Plumbers Don't Wear Ties  | 1994 | 1.3    |
| Ride to Hell: Retribution | 2013 | 1.4    |
| Superman                  | 1999 | 1.4    |
| Hunt Down the Freeman     | 2018 | 1.5    |
| E.T. Phone Home!          | 1983 | 1.5    |     
| Jenga World Tour          | 2007 | 1.5    |
| Super Noah's Ark 3D       | 1994 | 1.5    | 

## 5. Which decade produced the majority of the lowest 100 rated games
````r
lowest_rated_video_games <- head(arrange(imdb_videogame_ratings_completeyears,
                                         rating),n=100)

head(arrange((lowest_rated_video_games %>%group_by(Decade) %>% 
  summarise(number_of_games_produced = n()) ),desc(number_of_games_produced)),
  n=1)
 ````
| Decade | number_of_games_produced |
| ------ | ------------------------ |
| 2010   | 41                       |


````r
lowest_rated_video_games_count <-  lowest_rated_video_games %>%
  group_by(Decade) %>% dplyr:: summarise(number_of_games_produced = n())

ggplot(data = lowest_rated_video_games_count,
       mapping= aes(x=Decade,y=number_of_games_produced, 
                    fill=number_of_games_produced))+ geom_bar(stat="identity") + 
  labs(title="Number of Lowest Rated Games per Decade")
 ````
 
 ![Lowest rated games per decade](https://user-images.githubusercontent.com/88348888/210457874-9842b559-b897-415f-aeb4-4f8e1445be48.jpeg)

 ## 6. The lowest Rated Gamess in the 2020s
 ````r
 print(lowest_rated_video_games %>% filter(Decade==2020))
  ````
  
  
  
