# Solutions
## 1. Top 10 Rated Games
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

### Majority of the top 10 rated games where done in 2010s.

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

## 4. The 10 Lowest Rated Games
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
 view(lowest_rated_video_games %>% filter(Decade==2020)%>% select(title,year,genre,rating,directors))
  ````
  
  
|   | title                            | year | genre               | rating | directors        |
| - | -------------------------------- | ---- | ------------------- | ------ | ---------------- |
| 1 | Taishogun: The Rise of Emperor   | 2021 | Action              | 1.8    | Gilson B. Pontes |
| 2 | Shadow the Ronin                 | 2020 | Action, Adventure   | 1.8    | Gilson B. Pontes |
| 3 | Chickens on the Road             | 2020 | Action              | 2.0    | Missing          |
| 4 | Fast and Furious Crossroads      | 2020 | Action, Crime,Drama | 2.2    | Ian Bell         |
| 5 | eFootball 2022                   | 2021 | Sport               | 2.4    | Missing          |
| 6 | Road Bustle                      | 2020 | Adventure           | 2.4    | Missing          |
  
## Weighted Rating
### I am using the formula provided by nyagami,i.e Weighted rating (WR) = (v/(v + m)) * R + ( m / (v + m)) * C
 where: R = average for the movie (mean) = (Rating)
 v = number of votes for the movie = (votes),
 m = minimum votes required to be listed in the Top 50 (currently 1000),
 C = the mean vote across the whole report
 
 ````r
v= imdb_videogame_ratings_cleaned$votes
m= 1000
R= imdb_videogame_ratings_cleaned$rating
C= round(mean(imdb_videogame_ratings_cleaned$rating), digits = 2)
imdb_videogame_ratings_cleaned$Weighted_Rating <- ((v/(v+m))*R + (m/(v+m))*C)
  ````
  
## Show top 50 games by Weighted rating 
  ````r
game_ranking<- imdb_videogame_ratings_cleaned %>%
  select(title,rating,votes,Weighted_Rating) 
top_50_games_WR <- head(arrange(game_ranking,desc(Weighted_Rating)), n=50)
view( top_50_games_WR)
````

|    | title                                     | rating | votes | Weighted_Rating |
| -- | ----------------------------------------- | ------ | ----- | --------------- |
| 1  | The Last of Us                            | 9.7    | 61103 | 9.655719        |
| 2  | Red Dead Redemption II                    | 9.7    | 36441 | 9.626551        |
| 3  | The Witcher 3: Wild Hunt                  | 9.7    | 26328 | 9.599371        |
| 4  | God of War                                | 9.6    | 26507 | 9.503661        |
| 5  | Grand Theft Auto V                        | 9.5    | 60381 | 9.458456        |
| 6  | Uncharted 4: A Thief's End                | 9.5    | 28985 | 9.414957        |
| 7  | Red Dead Redemption                       | 9.5    | 26767 | 9.408164        |  
| 8  | Metal Gear Solid                          | 9.6    | 11809 | 9.393114        |
| 9  | The Witcher 3: Wild Hunt - Blood and Wine | 9.7    | 7610  | 9.380604        |
| 10 | Mass Effect 2                             | 9.5    | 19961 | 9.378345        |
| 11 | The Legend of Zelda: Ocarina of Time      | 9.6    | 9576  | 9.349433        |
| 12 | Grand Theft Auto: San Andreas             | 9.4    | 39797 | 9.339947        |
| 13 | Batman: Arkham City                       | 9.4    | 30935 | 9.323282        |
| 14 | The Elder Scrolls V: Skyrim               | 9.4    | 29526 | 9.319741        |
| 15 | Uncharted 2: Among Thieves                | 9.4    | 25191 | 9.306456        |
| 16 | Metal Gear Solid 3: Snake Eater           | 9.5    | 10477 | 9.277817        |
| 17 | Final Fantasy VII                         | 9.5    | 10452 | 9.277331        |
| 18 | Half-Life 2                               | 9.4    | 16160 | 9.257226        |
| 19 |  Portal 2                                 | 9.4    | 15687 | 9.253179        |
| 20 |  Star Wars: Knights of the Old Republic   | 9.5    | 8633  | 9.235285        |
| 21 | The Legend of Zelda: Breath of the Wild   | 9.5    | 7253  | 9.191021        |
| 22 | Metal Gear Solid 4: Guns of the Patriots  | 9.4    | 10635 | 9.189428        |
| 23 | The Witcher 3: Wild Hunt -Hearts of Stone | 9.5    | 6302  | 9.150781        |
| 24 | Batman: Arkham Asylum                     | 9.2    | 27733 | 9.121693        |
| 25 | Grand Theft Auto: Vice City               | 9.2    | 26495 | 9.118167        |
| 26 | Spider-Man                                | 9.2    | 21197 | 9.098635        |
| 27 | Silent Hill 2                             | 9.4    | 6645  | 9.079529        |
| 28 | Detroit: Become Human                     | 9.2    | 17135 | 9.075931        |
| 29 | Max Payne                                 | 9.2    | 15085 | 9.060118        |
| 30 | Ghost of Tsushima                         | 9.3    | 8707  | 9.057907        |
| 31 | Resident Evil 4                           | 9.2    | 13201 | 9.041560        |
| 32 | The Walking Dead                          | 9.2    | 12776 | 9.036672        |
| 33 | Elden Ring                                | 9.5    | 4378  | 9.025846        |
| 34 | Uncharted: The Nathan Drake Collection    | 9.4    | 5436  | 9.019329        |
| 35 | Kingdom Hearts II                         | 9.3    | 7177  | 9.012609        |
| 36 | Assassin's Creed II                       | 9.1    | 23202 | 9.011164        |
| 37 | Half-Life                                 | 9.2    | 10211 | 8.999304        |
| 38 | BioShock Infinite                         | 9.1    | 20240 | 8.998776        |
| 39 | BioShock                                  | 9.1    | 19831 | 8.996788        |
| 40 | Fallout 3                                 | 9.1    | 18944 | 8.992198        |
| 41 | Mass Effect                               | 9.1    | 18211 | 8.988085        |
| 42 | God of War II                             | 9.2    | 9156  | 8.978456        |
| 43 | Mass Effect 3                             | 9.1    | 15609 | 8.970552        |
| 44 | Portal                                    | 9.1    | 12829 | 8.944530        |
| 45 | Kingdom Hearts                            | 9.2    | 7362  | 8.930926        |
| 46 | Max Payne 2: The Fall of Max Payne        | 9.1    | 10741 | 8.916881        |
| 47 | Call of Duty 4: Modern Warfare            | 9.0    | 22571 | 8.913029        |
| 48 | God of War III                            | 9.1    | 10421 | 8.911750        |
| 49 | Uncharted 3: Drake's Deception            | 9.0    | 22091 | 8.911221        |
| 50 | God of War                               | 9.1     | 10200 | 8.908036        |

## Relationships  between variables; has the average rating of video games changed or remained constant over the years?
````r
ggplot(data = imdb_videogame_ratings_completeyears, 
       mapping = aes(x=year,y=rating))+ geom_point( color= "red")+
  geom_smooth(method = lm, color="black", se=FALSE)+
  labs(title="Relationship between year of launch and rating ")
````

![Launch year vs rating](https://user-images.githubusercontent.com/88348888/210616338-09443911-00ff-4c83-b174-960d17b84286.jpeg)

### There is a positive correlation between the rating and release year.

## Relationship between the number of votes and rating
````r
ggplot(data = imdb_videogame_ratings_completeyears, 
       mapping = aes(x=votes,y=year))+ geom_point( color= "red")+
  geom_smooth(method = lm, color="black", se=FALSE)+
  labs(title="Relationship between number of votes and rating of video games ")
  ````
  
  ![Votes vs ratings](https://user-images.githubusercontent.com/88348888/210616648-48164b8b-a6c7-46ef-bffd-09c0a2fa39b9.jpeg)

### The correlation between these two variables is non-linear.  

### To get a positive correlation between these two variables, I took the log of them.
````r
ggplot(data = imdb_videogame_ratings_completeyears, 
       mapping = aes(x=log(votes),y=log(rating)))+ geom_point( color= "red")+
  geom_smooth(method = lm, color="black", se=FALSE)+
    labs(title="Relationship between log votes and log rating ")
  ````
  
  ![log votes vs log ratings](https://user-images.githubusercontent.com/88348888/210617129-75c8320e-f53a-4bf0-84ac-09e3ab773282.jpeg)

  
