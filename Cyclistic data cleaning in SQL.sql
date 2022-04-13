
-- An analysis of a dataset provided by Divvy for the marketing team of a bike-share company (Cyclistic) 
/*  
dataset source
https://divvy-tripdata.s3.amazonaws.com/index.html
*/


-- cealning the data 



SELECT * 
FROM Cyclistic.dbo.Jan_data;

SELECT * 
FROM Cyclistic.dbo.Feb_data;

SELECT * 
FROM Cyclistic.dbo.March_data;

SELECT * 
FROM Cyclistic.dbo.April_data;

SELECT * 
FROM Cyclistic.dbo.May_data;

SELECT * 
FROM Cyclistic.dbo.June_data;

SELECT * 
FROM Cyclistic.dbo.July_data;

SELECT * 
FROM Cyclistic.dbo.Aug_data;

SELECT * 
FROM Cyclistic.dbo.Sep_data;

SELECT * 
FROM Cyclistic.dbo.Oct_data;

SELECT * 
FROM Cyclistic.dbo.Nov_data;

SELECT * 
FROM Cyclistic.dbo.Dec_data;

-- I noticed that there are some missing data in the start and end stations name and Id columns. 
-- With filtering it showed No relation to rideable type membership type.



/* Populating Station names based on their longitude and latitude */

 -- Populating for the month March by firstly adding a column to the table that is a decimal copy of the start and end lng and lat columns

 ALTER TABLE Cyclistic.dbo.March_data  
 ADD start_lat_new decimal(15,13);

 ALTER TABLE Cyclistic.dbo.March_data  
 ADD start_lng_new decimal(15,13);

 ALTER TABLE Cyclistic.dbo.March_data  
 ADD ned_lat_new decimal(15,13);

 ALTER TABLE Cyclistic.dbo.March_data  
 ADD end_lng_new decimal(15,13);

-- updating these columns by casting the lat and lng columns to decimals

 UPDATE Cyclistic.dbo.March_data
 SET start_lat_new = CAST(start_lat as decimal(15,13));

 UPDATE Cyclistic.dbo.March_data
 SET start_lng_new = CAST(start_lng as decimal(15,13));

 UPDATE Cyclistic.dbo.March_data
 SET ned_lat_new = CAST(end_lat as decimal(15,13));

 UPDATE Cyclistic.dbo.March_data
 SET end_lng_new = CAST(end_lng as decimal(15,13));


-- populating the null values in the start and end stations by their matching lat and lng values in other rows. (for the month March)
-- to eventually determine which start and end statoin has the most rides in order to be targted by the marketing team

 
 SELECT A.start_lat_new, B.start_lat_new, A.start_lng_new, B.start_lng_new, A.start_station_name, B.start_station_name,
 ISNULL(A.start_station_name, B.start_station_name)
 FROM Cyclistic.dbo.March_data A
 JOIN Cyclistic.dbo.March_data B
 ON A.start_lat_new = B.start_lat_new
 AND A.start_lng_new = B.start_lng_new
 AND A.ride_id <> B.ride_id
 WHERE A.start_station_name is NULL;

 SELECT A.ned_lat_new, B.ned_lat_new, A.end_lng_new, B.end_lng_new, A.end_station_name, B.end_station_name,
 ISNULL(A.end_station_name, B.end_station_name)
 FROM Cyclistic.dbo.March_data A
 JOIN Cyclistic.dbo.March_data B
 ON A.ned_lat_new = B.ned_lat_new
 AND A.end_lng_new = B.end_lng_new
 AND A.ride_id <> B.ride_id
 WHERE A.end_station_name is NULL;

 UPDATE A
 SET start_station_name = ISNULL(A.start_station_name, B.start_station_name)
 FROM Cyclistic.dbo.March_data A
 JOIN Cyclistic.dbo.March_data B
 ON A.start_lat_new = B.start_lat_new
 AND A.start_lng_new = B.start_lng_new
 AND A.ride_id <> B.ride_id
 WHERE A.start_station_name is NULL;

 UPDATE B
 SET end_station_name = ISNULL(A.end_station_name, B.end_station_name)
 FROM Cyclistic.dbo.March_data A
 JOIN Cyclistic.dbo.March_data B
 ON A.ned_lat_new = B.ned_lat_new
 AND A.end_lng_new = B.end_lng_new
 AND A.ride_id <> B.ride_id
 WHERE A.end_station_name is NULL;

SELECT start_station_name, end_station_name
FROM Cyclistic.dbo.March_data;

 -- Results Showed that Some data was populated but some was still unclear based on their longitude and latitude. 
 -- Repopulating the remaining missing station ID values with the most common value

SELECT start_station_name, COUNT(start_station_name) as count
FROM Cyclistic.dbo.March_data
GROUP BY start_station_name
ORDER BY count desc


UPDATE Cyclistic.dbo.March_data
 SET start_station_name = ISNULL(start_station_name, 'Lake Shore Dr & Monroe St')

SELECT end_station_name, COUNT(end_station_name) as count
FROM Cyclistic.dbo.March_data
GROUP BY end_station_name
ORDER BY count desc

UPDATE Cyclistic.dbo.March_data
 SET end_station_name = ISNULL(end_station_name, 'Lake Shore Dr & Monroe St')



 /* 
- Adding a Ride_duration and day of week columns to the table  
- Adding a ride duration and day of week columns to the table 
- setting ride duration by subtracting ended_at column from started_at column
- setting the day of week by extracting the day out of started_at column  
*/

-- For January
 ALTER TABLE Cyclistic.dbo.Jan_data
 ADD  Ride_duration nvarchar(10);

 ALTER TABLE Cyclistic.dbo.Jan_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.Jan_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.Jan_data
 SET Day_of_week = format(started_at, 'dddd');

 -- For Febraury
 ALTER TABLE Cyclistic.dbo.Feb_data
 ADD  Ride_duration nvarchar(10);

 ALTER TABLE Cyclistic.dbo.Feb_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.Feb_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.Feb_data
 SET Day_of_week = format(started_at, 'dddd');


 -- For March
 ALTER TABLE Cyclistic.dbo.March_data
 ADD  Ride_duration nvarchar(10); 

 ALTER TABLE Cyclistic.dbo.March_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.March_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.March_data
 SET Day_of_week = format(started_at, 'dddd');

 -- For April
 ALTER TABLE Cyclistic.dbo.April_data
 ADD  Ride_duration nvarchar(10); 

 ALTER TABLE Cyclistic.dbo.April_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.April_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.April_data
 SET Day_of_week = format(started_at, 'dddd');

 -- For may
 ALTER TABLE Cyclistic.dbo.May_data
 ADD  Ride_duration nvarchar(10); 

 ALTER TABLE Cyclistic.dbo.May_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.May_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.May_data
 SET Day_of_week = format(started_at, 'dddd');

 -- For June
 ALTER TABLE Cyclistic.dbo.June_data
 ADD  Ride_duration nvarchar(10); 

 ALTER TABLE Cyclistic.dbo.June_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.June_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.June_data
 SET Day_of_week = format(started_at, 'dddd');

 -- For July
 ALTER TABLE Cyclistic.dbo.July_data
 ADD  Ride_duration nvarchar(10); 

 ALTER TABLE Cyclistic.dbo.July_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.July_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.July_data
 SET Day_of_week = format(started_at, 'dddd');

-- For Augsut
 ALTER TABLE Cyclistic.dbo.Aug_data
 ADD  Ride_duration nvarchar(10); 

 ALTER TABLE Cyclistic.dbo.Aug_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.Aug_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.Aug_data
 SET Day_of_week = format(started_at, 'dddd');

 -- For Sep

 ALTER TABLE Cyclistic.dbo.Sep_data
 ADD  Ride_duration nvarchar(10); 

 ALTER TABLE Cyclistic.dbo.Sep_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.Sep_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.Sep_data
 set Day_of_week = format(started_at, 'dddd');

 -- For October
 ALTER TABLE Cyclistic.dbo.Oct_data
 ADD  Ride_duration nvarchar(10); 

 ALTER TABLE Cyclistic.dbo.Oct_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.Oct_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.Oct_data
 set Day_of_week = format(started_at, 'dddd');

 -- For november
 ALTER TABLE Cyclistic.dbo.Nov_data
 ADD  Ride_duration nvarchar(10); 

 ALTER TABLE Cyclistic.dbo.Nov_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.Nov_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.Nov_data
 SET Day_of_week = FORMAT(started_at, 'dddd');

 -- For December
 ALTER TABLE Cyclistic.dbo.Dec_data
 ADD  Ride_duration nvarchar(10);

 ALTER TABLE Cyclistic.dbo.Dec_data
 ADD  Day_of_week nvarchar(15); 

 UPDATE	Cyclistic.dbo.Dec_data
 SET Ride_duration  =  FORMAT(DATEADD(ss,DATEDIFF(ss,[started_at], [ended_at] ),0),'hh:mm');
 
 UPDATE	Cyclistic.dbo.Dec_data
 SET Day_of_week = FORMAT(started_at, 'dddd');


 

/* Fining out how many Casual rides to Member rides  */

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.Jan_data
GROUP BY member_casual; 

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.Feb_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.March_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.April_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.May_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.June_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.July_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.Aug_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.Sep_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.Oct_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.Nov_data
GROUP BY member_casual;

SELECT DISTINCT member_casual, COUNT(member_casual) Rides_Count
FROM Cyclistic.dbo.Dec_data
GROUP BY member_casual;

-- The date shows clear increase in rides starting in March and hitting a peak total ride count in July and August and starting to decline in october and througout the Winter months.
-- A further Data visualization of these results is completed using Tableau

/*  Discovering which days of the week has the highest number of rides   */
 SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.Jan_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.Feb_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.March_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.April_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.May_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.June_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.July_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.Aug_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.Sep_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.Oct_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.Nov_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;

SELECT DISTINCT Day_of_week, 
		COUNT(Day_of_week) Weekdays_Count
		FROM Cyclistic.dbo.Dec_data
		GROUP BY Day_of_week
		ORDER BY Weekdays_Count DESC;


-- The data shows that weekends starting Friday until Sunday has more ride counts especially during the summer months 
-- A further Data visualization of these results is completed using Tableau

/*   Identifying Casual Rides stations   */ 

 SELECT start_station_name
 FROM Cyclistic.dbo.Jan_data
 WHERE member_casual = 'casual'
 AND start_station_name IS NOT NULL
 GROUP BY start_station_name

 SELECT start_station_name
 FROM Cyclistic.dbo.Jan_data
 WHERE start_station_name IS NOT NULL
 GROUP BY start_station_name
 
 -- The data shows that there is no relation between member type and stations' locations



 /* Identfying stations with highest ride count per month */

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.Jan_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.Feb_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.March_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.April_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.May_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.June_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.July_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM 
Cyclistic.dbo.Aug_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.Sep_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.Oct_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.Nov_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

SELECT DISTINCT start_station_name,  COUNT(start_station_name) Rides_per_station
FROM Cyclistic.dbo.Dec_data 
WHERE start_station_name IS NOT NUll
GROUP BY start_station_name
ORDER BY Rides_per_station DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

--The data shows specific stations with the highest ride counts and changes as seasons change.










