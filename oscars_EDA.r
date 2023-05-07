#setwd("/Users/diva/Downloads/4th semestr /Exploratory Data Analysis/oscar")


#Exploratory Data Analysis

#1.Loading the necessary packages
install.packages("visdat")
library(visdat)
library(tidyverse)
library(dplyr)
library(readr)


#2.Importing our datasets
movies <- read_csv("data/movies.csv")
oscars <- read_csv("data/oscars.csv")

#3.Exploring the structure of the dataset
str(movies)
head(movies)
summary(movies)
#Description
#The dataset contains information about movies from the years 1980 to 2020, 
#including various attributes such as name, rating, genre, year, release date, score, votes, director, writer, star, country, budget, gross, company, and runtime. 
#Each row in the dataset represents a different movie, and each column represents a specific attribute of the movie.

#Here is a breakdown of the columns in the dataset:

# - Name: The title or name of the movie.
# - Rating: The rating assigned to the movie (e.g., R, PG, etc.), indicating the intended audience age group.
# - Genre: The genre or category of the movie (e.g., Drama, Adventure, Comedy, etc.).
# - Year: The year when the movie was released.
# - Released: The specific release date of the movie, including the country of release.
# - Score: The average rating or score given to the movie.
# - Votes: The number of votes or ratings received by the movie.
# - Director: The name of the director of the movie.
# - Writer: The name of the writer or screenplay writer of the movie.
# - Star: The name of the lead actor or actress in the movie.
# - Country: The country of origin or production of the movie.
# - Budget: The budget or estimated cost of producing the movie.
# - Gross: The total gross revenue or earnings generated by the movie.
# - Company: The production company associated with the movie.
# - Runtime: The duration or runtime of the movie in minutes.



str(oscars) #type of Year is character 
head(oscars)
summary(oscars)
oscars$Year <- as.numeric(oscars$Year) # we don't care about NAs introduced by coercion in the beginning of dataset, as in "movies" dataset data starts from year 1980. 
#Description 
#The dataset consists of information about award winners at various film ceremonies from the years 1927 to 2015. 
#Each entry in the dataset represents a specific award category and includes details 
#such as the year of the ceremony, the ceremony number, the award category, the winner's name, and the film associated with the award.


# Here is a breakdown of the columns in the dataset:
#   
# - Year: The year of the film ceremony.
# - Ceremony: The ceremony number or identifier.
# - Award: The category of the award.
# - Winner: Indicates whether the winner is the first winner mentioned for the award category. The value "1" signifies the first winner.
# - Name: The name of the winner.
# - Film: The film associated with the award.

##Our goal is to provide insights into what movies to succeed at the Oscars,so we can partly omit data from datasets, so there will be data on Oscars ceremonies and films from the years 1980 to 2015.
filtered_movies <- movies[movies$year >= 1980 & movies$year <= 2015, ]
filtered_oscars <- oscars[oscars$Year >= 1980 & oscars$Year <= 2015, ]
summary(filtered_movies)
summary(filtered_oscars)


#4.Handling missing values and data cleaning
missing_movies <- is.na(filtered_movies)
missing_movies
summary_movies <- colSums(missing_movies)
summary_movies # there are 1912 missing values in budget, that is quite a lot, we won't omit it for now.

missing_oscars <- is.na(filtered_oscars) 
missing_oscars
summary_oscars <- colSums(missing_oscars)
summary_oscars 

#Visualizing missing values 
vis_miss(filtered_movies)
vis_miss(filtered_oscars)

#Deleting all the rows with missing rating and/or gross from movies dataset 
movies_no_missing <- filtered_movies[complete.cases(filtered_movies[c("name", "rating", "genre", "year", "released", "score", "votes", "director", "writer", "star", "country", "gross", "company", "runtime")]), ]
#double checking 
vis_miss(movies_no_missing)
#for later analysis preparing dataset with cleaned budget.
movies_no_missing_budget <- na.omit(movies_no_missing[c("budget")])

#Setting values 0 insted of NA for false winners in oscars dataset.
filtered_oscars$Winner[is.na(filtered_oscars$Winner)] <- 0
#Omiting missing values from oscars dataset
oscars_no_missing <- na.omit(filtered_oscars)
oscars_no_missing
#double checking 
vis_miss(oscars_no_missing)


view(oscars_no_missing)
#Almost all instances have switched Film and Name, except Actors and Actresses.
#Fixing the data

##Creating a vector of the four award categories where the Name and Film columns are already correct.
correct_awards <- c("Actor in a Leading Role", "Actor in a Supporting Role", 
                    "Actress in a Leading Role", "Actress in a Supporting Role")

##Creating a new df that contains only the rows where the Award column is not in the correct_awards vector.
data_fix = oscars_no_missing[!(oscars_no_missing$Award %in% correct_awards), ]
##Creating a variable to store the values of the Film column for the rows in data_fix
cat_name = data_fix$Film
##Creating a variable to store the values of the Name column for the rows in data_fix
cat_film = data_fix$Name
##Swapping the values of the Name and Film columns for the rows that are not in the correct_awards vector
oscars_no_missing[!(oscars_no_missing$Award %in% correct_awards), 5] = cat_name
oscars_no_missing[!(oscars_no_missing$Award %in% correct_awards), 6] = cat_film

view(oscars_no_missing)


# Joining two datasets based on the name of the film.
df <- inner_join(oscars_no_missing, movies_no_missing, by = c("Film" = "name"))
view(df)

#write.csv(df, "cleaned_merged.csv", row.names = FALSE)



