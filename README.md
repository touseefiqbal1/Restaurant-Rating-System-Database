# Restaurant Rating System Database

A SQL-based restaurant rating and management system that handles restaurant information, consumer ratings, and cuisine categorization.

## Database Structure

The system consists of several interconnected tables:
- **Restaurant**: Core restaurant information
- **Consumers**: Customer data
- **Ratings**: Customer ratings for restaurants
- **Restaurant_Cuisines**: Restaurant and cuisine associations

## Table Relationships

### Primary Keys
- Restaurant (Restaurant_ID)
- Consumers (Consumer_ID)

### Foreign Keys
- Ratings → Consumers (Consumer_ID)
- Ratings → Restaurant (Restaurant_ID)
- Restaurant_Cuisines → Restaurant (Restaurant_ID)

## Key Features

### Restaurant Search and Filtering
- Filter restaurants by:
  - Price range
  - Seating area type
  - Cuisine type
  - Parking availability
  - Rating scores

### Rating Analysis
- Multiple rating dimensions:
  - Overall rating
  - Food rating
  - Service rating
- Age-based analysis of ratings
- Restaurant ranking system

## Implemented Queries

### Restaurant Search
```sql
-- Find restaurants with specific criteria (e.g., Medium price, Open area, Mexican cuisine)
SELECT Restaurant_ID, Name, City, State, Price, Area
FROM Restaurant AS R
INNER JOIN Restaurant_Cuisines AS RC 
ON R.Restaurant_ID = RC.Restaurant_ID
WHERE Price = 'Medium' 
AND Area = 'Open' 
AND RC.Cuisine = 'Mexican';
```

### Statistical Analysis
1. Cuisine-specific rating counts
2. Average consumer age analysis
3. Age-based restaurant rankings
4. Rating distribution analysis

### Top Performers
- Top 10 highest-rated restaurants with parking
- Restaurants with highest number of customer ratings
- Cuisine performance analysis

## Stored Procedures

### UpdateServiceRating
Automatically updates service ratings based on parking availability:
```sql
CREATE PROCEDURE UpdateServiceRating
AS
BEGIN
    UPDATE r
    SET r.Service_Rating = 2
    FROM Ratings r
    INNER JOIN Restaurant rt 
    ON r.Restaurant_ID = rt.Restaurant_ID
    WHERE rt.Parking IN ('Yes', 'Public');
END;
```

## Analytics Features

### Consumer Analysis
- Age demographics of reviewers
- Rating patterns by consumer age
- Identification of most active reviewers

### Restaurant Performance Metrics
- Overall rating averages
- Food quality ratings
- Service quality assessment
- Parking facility impact on ratings

### Cuisine Analysis
- Average ratings by cuisine type
- Popular cuisine identification
- Cuisine-specific customer preferences

## Sample Queries

### Consumer Behavior Analysis
```sql
-- Average age of consumers giving 0 service rating
SELECT ROUND(AVG(C.Age), 0) AS Average_Age_Of_0_Service_Rating
FROM Consumers AS C
JOIN Ratings AS R ON C.Consumer_ID = R.Consumer_ID
WHERE R.Service_Rating = 0;
```

### Restaurant Performance
```sql
-- Top 10 restaurants by number of ratings
SELECT TOP 10 Restaurant_ID, COUNT(*) AS NumberOfRatings 
FROM Ratings 
GROUP BY Restaurant_ID
ORDER BY NumberOfRatings DESC;
```

## Use Cases

1. Restaurant owners analyzing their performance
2. Customers searching for restaurants
3. Market analysis for cuisine preferences
4. Service quality monitoring
5. Customer demographic analysis

## Installation

1. Execute the table creation scripts
2. Run the ALTER TABLE statements to establish relationships
3. Implement the stored procedures
4. Test with sample queries

## Best Practices

- Regular index maintenance
- Periodic statistics update
- Regular backup of rating data
- Monitor query performance
- Validate incoming ratings

## Future Enhancements

1. Time-based rating analysis
2. Seasonal trend analysis
3. Geographic performance metrics
4. Price range impact analysis
5. Customer loyalty tracking

## Contributing

Contributions welcome! Please follow the standard pull request process.
