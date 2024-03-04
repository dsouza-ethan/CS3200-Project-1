-- Query 1: Join of at least three tables
-- This query finds total distance traveled and carbon emissions saved by each user, along with the user's preferred mode of transportation, by joining the Users, Trips, and Transportation Modes tables.
SELECT 
    User.username,
    Transportation_Mode.mode_name,
    SUM(Trip.distance_traveled) AS total_distance,
    SUM(Trip.carbon_emission_saved) AS total_emissions_saved
FROM 
    User
JOIN 
    Trip ON User.user_id = Trip.user_id
JOIN 
    Transportation_Mode ON User.preferred_transportation_mode = Transportation_Mode.mode_id
GROUP BY 
    User.username, Transportation_Mode.mode_name;
	
-- Query 2: Subquery
-- This query selects all users who have saved more carbon emissions than the average across all trips.
SELECT 
    username,
    location
FROM 
    User
WHERE 
    user_id IN (
        SELECT 
            user_id
        FROM 
            Trip
        GROUP BY 
            user_id
        HAVING 
            SUM(carbon_emission_saved) > (
                SELECT AVG(carbon_emission_saved) 
                FROM Trip
            )
    );
	
-- Query 3: GROUP BY with HAVING clause
-- This query identifies transportation modes that have saved more than an average of 1000 units of carbon emissions per trip.
SELECT 
    mode_name,
    AVG(carbon_emission_saved) AS average_emissions_saved
FROM 
    Trip
JOIN 
    Transportation_Mode ON Trip.mode_id = Transportation_Mode.mode_id
GROUP BY 
    mode_name
HAVING 
    AVG(carbon_emission_saved) > 1000;
	
-- Query 4: Complex search criterion
-- This query finds trips longer than 5 miles that either saved more than 500 units of carbon emissions or took longer than 30 minutes.
SELECT 
    trip_id,
    distance_traveled,
    carbon_emission_saved,
    trip_duration
FROM 
    Trip
WHERE 
    distance_traveled > 5
    AND (carbon_emission_saved > 500 OR trip_duration > 30);
	
-- Query 5: Advanced query mechanism - SELECT CASE/WHEN
-- This query categorizes users based on their preferred transportation mode into 'Eco-Friendly', 'Moderate', or 'Other', demonstrating the use of CASE statement.
SELECT 
    username,
    CASE 
        WHEN preferred_transportation_mode IN (SELECT mode_id FROM Transportation_Mode WHERE mode_name IN ('Cycling', 'Walking')) THEN 'Eco-Friendly'
        WHEN preferred_transportation_mode IN (SELECT mode_id FROM Transportation_Mode WHERE mode_name = 'Public Transit') THEN 'Moderate'
        ELSE 'Other'
    END AS eco_category
FROM 
    User;
