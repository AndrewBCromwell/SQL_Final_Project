# SQL_Final_Project
Final project for my Relational Database and SQL class. Hand-crafted database that includes stored procedures, views, and a trigger.
Coded using MySQL

## About
For my final project in my Relational Database and SQL class, I designed and built a database to keep track of venues that a 
circus has visited or is planning to visit, how long the circus stayed there, how many tickets they sold each night at each 
venue, total revenue from a venue, what types of advertisements (tv, radio, billboard, etc.) were used at each city, 
which act of the show was focused on in each ad, and how much each ad campaign cost in total.

It included a view to show the average number of tickets that were sold daily and the average daily revenue from each time a 
venue was visited, as well as one that compares the cost of a particular ad campaign with the average daily number of tickets 
and average daily revenue during that campaign.

It included stored procedures that would
1. Show which venues that were visited had an average daily revenue greater than a value specified by the user
1. Add a record for a day at a location (with exception handling)
1. Show the average daily tickets and revenue when ads focussed on an act specified by the user and the amount spent on these ads was more than the amount specified by the user
1. Add a new venue that can be visited (with rollback if an error occurs)

It also included a trigger so that when a record for a day is added, the total number of tickets sold and total revenue at that 
venue are updated accordingly.
