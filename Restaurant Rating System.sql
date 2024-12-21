-- Adding Primary and Foreign Keys to create relationships between the tables
ALTER TABLE Restaurant
ADD CONSTRAINT PK_Restaurant
PRIMARY KEY (Restaurant_ID);

ALTER TABLE Consumers
ADD CONSTRAINT PK_Consumers
PRIMARY KEY (Consumer_ID);

ALTER TABLE Ratings
ADD CONSTRAINT FK_Ratings_Consumers
FOREIGN KEY (Consumer_ID) REFERENCES Consumers(Consumer_ID);

ALTER TABLE Ratings
ADD CONSTRAINT FK_Ratings_Restaurant
FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID);

ALTER TABLE Restaurant_Cuisines
ADD CONSTRAINT FK_Restaurant_Cuisines_Restaurant
FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID);

-- 1. Query for restaurants with Medium range price with open area, serving Mexican food
SELECT 
    R.Restaurant_ID,
    R.Name,
    R.City,
    R.State,
    R.Price,
    R.Area
FROM 
    Restaurant AS R
INNER JOIN 
    Restaurant_Cuisines AS RC ON R.Restaurant_ID = RC.Restaurant_ID
WHERE 
    R.Price = 'Medium' AND 
    R.Area = 'Open' AND 
    RC.Cuisine = 'Mexican';

-- 2. Total number of restaurants with overall rating as 1 for Mexican and Italian cuisines
SELECT 
    (SELECT COUNT(DISTINCT R.Restaurant_ID) 
     FROM Restaurant R
     JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
     JOIN Ratings RAT ON R.Restaurant_ID = RAT.Restaurant_ID
     WHERE RC.Cuisine = 'Mexican'
     AND RAT.Overall_Rating = 1) AS Total_Mexican_Rating_1,

    (SELECT COUNT(DISTINCT R.Restaurant_ID) 
     FROM Restaurant R
     JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
     JOIN Ratings RAT ON R.Restaurant_ID = RAT.Restaurant_ID
     WHERE RC.Cuisine = 'Italian'
     AND RAT.Overall_Rating = 1) AS Total_Italian_Rating_1;

 -- 3. Average age of consumers who have given a 0 rating to the 'Service_rating' column
SELECT ROUND(AVG(C.Age), 0) AS Average_Age_Of_0_Service_Rating
FROM Consumers AS C
JOIN Ratings AS R ON C.Consumer_ID = R.Consumer_ID
WHERE R.Service_Rating = 0;

-- 4. Restaurants ranked by the youngest consumer
SELECT 
    R.Name AS Restaurant_Name,
    YR.Food_Rating,
    YR.Age AS Age
FROM 
    (SELECT 
        RAT.Restaurant_ID,
        RAT.Food_Rating,
        C.Age,
        ROW_NUMBER() OVER (PARTITION BY RAT.Restaurant_ID ORDER BY C.Age ASC, RAT.Food_Rating DESC) AS AgeRank
     FROM 
        Ratings RAT
     JOIN 
        Consumers C ON RAT.Consumer_ID = C.Consumer_ID) YR
JOIN 
    Restaurant R ON YR.Restaurant_ID = R.Restaurant_ID
WHERE 
    YR.AgeRank = 1
ORDER BY 
    YR.Food_Rating DESC, YR.Age ASC;

-- 5. Updating Service rating with parking
CREATE PROCEDURE UpdateServiceRating
AS
BEGIN
    UPDATE r
    SET r.Service_Rating = 2
    FROM Ratings r
    INNER JOIN Restaurant rt ON r.Restaurant_ID = rt.Restaurant_ID
    WHERE rt.Parking IN ('Yes', 'Public');
END;

EXEC UpdateServiceRating;

-- 6(i) Cuisines with an average food rating above 1
SELECT Cuisine, AVG(Food_Rating) AS AvgFoodRating 
FROM Restaurant_Cuisines RC
JOIN Ratings R ON RC.Restaurant_ID = R.Restaurant_ID
GROUP BY Cuisine 
HAVING AVG(Food_Rating) > 1;

-- 6(ii) Consumers who have given the highest food rating to any restaurant
SELECT Consumer_ID 
FROM Ratings
WHERE Food_Rating IN (SELECT MAX(Food_Rating) FROM Ratings);

-- 6(iii) Number of Customers who have given a rating above 1 to restaurants
SELECT COUNT(DISTINCT Consumer_ID) AS NumberOfUsers
FROM Ratings
WHERE Overall_Rating > 1;

-- 6(iv) Top 10 highest rated restaurants with parking
SELECT TOP 10 R.Restaurant_ID, R.Food_Rating 
FROM Ratings R
INNER JOIN Restaurant Rest ON R.Restaurant_ID = Rest.Restaurant_ID
WHERE Rest.Parking IN ('Yes', 'Public')
ORDER BY Food_Rating DESC;

-- 6(v) Top 10 Restaurants with the highest number of ratings from customers
SELECT TOP 10 Restaurant_ID, COUNT(*) AS NumberOfRatings 
FROM Ratings 
GROUP BY Restaurant_ID
ORDER BY NumberOfRatings DESC;