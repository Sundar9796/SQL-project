Create database Airline_Flight_Management_System;
Use Airline_Flight_Management_System;

#1.Write a query to display the average monthly ticket cost for each flight in ABC Airlines.
#The query should display the Flight_Id,From_location,To_Location,Month Name as “Month_Name” and average price as “Average_Price”
#Display the records sorted in ascending order based on flight id and then by Month Name.

SELECT f.flight_id, f.from_location, f.to_location, MONTHNAME(fd.flight_departure_date) AS Month_name, AVG(fd.price) AS Average_price 
FROM air_flight AS f 
JOIN air_flight_details AS fd ON f.flight_id = fd.flight_id 
GROUP BY f.flight_id, Month_name 
ORDER BY f.flight_id, MONTH(fd.flight_departure_date);


#/2.Write a query to display the customer(s) who has/have booked least number of tickets in ABC Airlines
#The Query should display profile_id, customer’s first_name, Address and Number of tickets booked as “No_of_Tickets”
#Display the records sorted in ascending order based on customer's first name 

SELECT apf.profile_id, apf.first_name, apf.address, COUNT(ati.ticket_id) AS No_of_Tickets
FROM air_passenger_profile AS apf
JOIN air_ticket_info AS ati ON apf.profile_id = ati.profile_id
GROUP BY apf.profile_id
HAVING COUNT(ati.ticket_id) <= ALL
(SELECT COUNT(ati.ticket_id) FROM air_passenger_profile AS apf
JOIN air_ticket_info AS ati ON apf.profile_id = ati.profile_id
GROUP BY apf.profile_id)
ORDER BY apf.first_name;

#3.Write a query to display the number of flight services between locations in a month. 
#The Query should display From_Location, To_Location, Month as “Month_Name” and number of flight services as “No_of_Services”.  
#Hint: The Number of Services can be calculated from the number of scheduled departure dates of a flight.
 #The records should be displayed in ascending order based on From_Location and then by To_Location and then by month name                      


SELECT af.from_location, af.to_location, MONTHNAME(afd.flight_departure_date) AS Month_Name,
COUNT(afd.flight_departure_date) AS No_of_Services 
FROM air_flight AS af 
JOIN air_flight_details AS afd ON af.flight_id = afd.flight_id 
GROUP BY af.from_location, af.to_location, Month_Name 
ORDER BY af.from_location, af.to_location, Month_Name;

 #4.Write a query to display the customer(s) who have booked maximum number of tickets in ABC Airlines. 
 #The Query should display profile_id, customer’s first_name, Address and Number of tickets booked as “No_of_Tickets”
 #Display the records in ascending order based on customer's first name.


SELECT app.profile_id, app.first_name, app.address, COUNT(ati.ticket_id) AS No_of_Tickets
FROM air_passenger_profile AS app
JOIN air_ticket_info AS ati ON app.profile_id = ati.profile_id  
JOIN air_flight AS af ON ati.flight_id = af.flight_id
WHERE af.airline_name = 'ABC Airlines' 
GROUP BY app.profile_id 
HAVING COUNT(ati.ticket_id) >= ALL 
    (SELECT COUNT(ati.ticket_id) 
     FROM air_passenger_profile AS app
     JOIN air_ticket_info AS ati ON app.profile_id = ati.profile_id 
     JOIN air_flight AS af ON ati.flight_id = af.flight_id
     WHERE af.airline_name = 'ABC Airlines' 
     GROUP BY app.profile_id)
ORDER BY app.first_name;


#5.Write a query to display the number of tickets booked from Chennai to Hyderabad. The Query should display passenger profile_id,first_name,last_name, Flight_Id , Departure_Date and  number of tickets booked as “No_of_Tickets”.
#Display the records sorted in ascending order based on profile id and then by flight id and then by departure date.


SELECT ati.profile_id, app.first_name, app.last_name, ati.flight_id, ati.flight_departure_date, COUNT(ati.ticket_id) AS No_of_Tickets
FROM air_ticket_info AS ati
JOIN air_passenger_profile AS app ON ati.profile_id = app.profile_id
JOIN air_flight AS af ON ati.flight_id = af.flight_id
WHERE af.from_location = 'Chennai' AND af.to_location = 'Hyderabad'
GROUP BY ati.profile_id, ati.flight_id, ati.flight_departure_date
ORDER BY ati.profile_id, ati.flight_id, ati.flight_departure_date;


#6.Write a query to display flight id,from location, to location and ticket price of flights whose departure is in the month of april.
#Display the records sorted in ascending order based on flight id and then by from location.
SELECT af.flight_id, af.from_location, af.to_location, afd.price 
FROM air_flight AS af 
JOIN air_flight_details AS afd ON af.flight_id = afd.flight_id 
WHERE MONTHNAME(afd.flight_departure_date) = 'April' 
ORDER BY af.flight_id, af.from_location;


#7Query to display the average cost of the tickets in each flight on all scheduled dates:
SELECT af.flight_id, af.from_location, af.to_location, AVG(afd.price) AS Price
FROM air_flight af 
JOIN air_flight_details afd ON af.flight_id = afd.flight_id 
GROUP BY af.flight_id, af.from_location, af.to_location 
ORDER BY af.flight_id, af.from_location, af.to_location;

#8.Query to display the customers who have booked tickets from Chennai to Hyderabad:
SELECT app.profile_id, CONCAT(app.first_name, ',', app.last_name) AS customer_name, app.address
FROM air_passenger_profile app 
JOIN air_ticket_info ati ON app.profile_id = ati.profile_id
JOIN air_flight af ON ati.flight_id = af.flight_id 
WHERE af.from_location = 'Chennai' AND af.to_location = 'Hyderabad' 
GROUP BY app.profile_id 
ORDER BY app.profile_id;


#9.Query to display profile id of the passenger(s) who has/have booked the maximum number of tickets:
SELECT profile_id 
FROM air_ticket_info 
GROUP BY profile_id 
HAVING COUNT(ticket_id) >= ALL 
    (SELECT COUNT(ticket_id) 
     FROM air_ticket_info 
     GROUP BY profile_id) 
ORDER BY profile_id;


#10.Query to display the total number of tickets booked in each flight in ABC Airlines:
SELECT af.flight_id, af.from_location, af.to_location, COUNT(ati.ticket_id) AS No_of_Tickets
FROM air_flight af 
JOIN air_ticket_info ati ON af.flight_id = ati.flight_id 
GROUP BY af.flight_id, af.from_location, af.to_location 
HAVING COUNT(ati.ticket_id) >= 1
ORDER BY af.flight_id;


#11.Query to display the number of services offered by each flight and the total price of the services:
SELECT af.flight_id, COUNT(afd.flight_departure_date) AS No_of_Services, SUM(afd.price) AS Total_Price 
FROM air_flight af 
JOIN air_flight_details afd ON af.flight_id = afd.flight_id 
GROUP BY af.flight_id 
ORDER BY Total_Price DESC, af.flight_id DESC;


#12.Query to display the number of passengers who have traveled in each flight on each scheduled date:
SELECT flight_id, flight_departure_date, COUNT(ticket_id) AS No_of_Passengers 
FROM air_ticket_info 
GROUP BY flight_id, flight_departure_date 
ORDER BY flight_id, flight_departure_date;


#13.Query to display profile id of passengers who booked the minimum number of tickets:
SELECT profile_id 
FROM air_ticket_info 
GROUP BY profile_id 
HAVING COUNT(profile_id) <= ALL 
    (SELECT COUNT(profile_id) 
     FROM air_ticket_info 
     GROUP BY profile_id) 
ORDER BY profile_id;







