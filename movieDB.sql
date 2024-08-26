CREATE DATABASE MovieookDB;
USE MovieBookDB;

-- Create Theatres Table 
CREATE TABLE Theatres (
    TheatreID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Area VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Ratings FLOAT NOT NULL CHECK (RatingS >= 0 AND Rating <= 5),
    Screens INT DEFAULT 1,
    TotalSeats INT NOT NULL CHECK (TotalSeats > 0),
    UserID INT NOT NULL, -- New column for managing admins
    Image VARCHAR(1000) NOT NULL ,
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
);

-- Create Movies Table
CREATE TABLE Movies (
    MovieID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(50) NOT NULL,
    Duration INT NOT NULL CHECK (Duration > 0), -- Duration in minutes
    ReleaseDate DATE NOT NULL,
    Rating FLOAT CHECK (Rating >= 0 AND Rating <= 10), -- Rating between 0 and 10
	Likes INT NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Casting VARCHAR(100) NOT NULL,
	Trailer VARCHAR(500) NOT NULL,
	Language VARCHAR(20) NOT NULL,
	Image VARCHAR(1000) NOT NULL ,
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- Create a Junction Table for Theatres and Movies 
CREATE TABLE TheatreMovies (
    TheatreMovieID INT IDENTITY(1,1) PRIMARY KEY,
    TheatreID INT NOT NULL,
    MovieID INT NOT NULL,
    ScreenNumber INT NOT NULL, 
    ShowDate DATE NOT NULL,
    ShowTimes JSON NOT NULL,
    AvailableSeats INT NOT NULL CHECK (AvailableSeats >= 0),
    FOREIGN KEY (TheatreID) REFERENCES Theatres(TheatreID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

-- Create Users Table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL ,
    PasswordHash VARCHAR(255) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(15) NOT NULL,
    SecurityQuestion VARCHAR(200),
    SecurityAnswer VARCHAR(100),
    Role VARCHAR(10) DEFAULT 'User',
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- Create ShowTimes Table
-- CREATE TABLE ShowTimes (
--    ShowTimeID INT IDENTITY(1,1) PRIMARY KEY,
--     TheatreMovieID INT NOT NULL, -- Link to the TheatreMovies junction table
--     ShowDate DATE NOT NULL,
--     ShowCode VARCHAR(10) NOT NULL,
--     AvailableSeats INT NOT NULL CHECK (AvailableSeats >= 0),
--     SeatAvailability VARCHAR(MAX) NOT NULL, -- New column for seat availability
--     FOREIGN KEY (TheatreMovieID) REFERENCES TheatreMovies(TheatreMovieID)
-- );

-- Create Bookings Table
CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    MovieID INT NOT NULL,
    TheatreID INT NOT NULL,
    BookingDate DATETIME DEFAULT GETDATE(),
    ShowDate DATE NOT NULL,
    ShowTime VARCHAR(10) NOT NULL,
    ScreenNumber INT NOT NULL, 
    NumberOfSeats INT NOT NULL CHECK (NumberOfSeats > 0),
    Seats VARCHAR(MAX) NOT NULL, -- Comma-separated seat numbers
    TotalPrice DECIMAL(10, 2) NOT NULL CHECK (TotalPrice >= 0),
    Status VARCHAR(20) DEFAULT 'Pending',
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (TheatreID) REFERENCES Theatres(TheatreID)
);

-- Create Payments Table (optional)
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount >= 0),
    PaymentDate DATETIME DEFAULT GETDATE(),
    PaymentMethod VARCHAR(50),
    TransactionID VARCHAR(100) UNIQUE,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- Create Reviews Table (optional)
CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    MovieID INT NOT NULL,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5), -- Rating between 1 and 5
    Comment VARCHAR(255),
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

-- Insert sample data into Theatres Table
INSERT INTO Theatres (Name, Location, TotalSeats, ManagedByAdmin) VALUES
('Grand Cinema', 'Downtown', 100, 'Admin1, Admin2'),
('Movie Palace', 'Uptown', 200, 'Admin3, Admin4');

-- Insert sample data into Movies Table
INSERT INTO Movies (Title, Genre, Duration, ReleaseDate, Rating, Description, Director) VALUES
('Inception', 'Sci-Fi', 148, '2010-07-16', 8.8, 'A thief who steals corporate secrets through the use of dream-sharing technology.', 'Christopher Nolan'),
('The Matrix', 'Action', 136, '1999-03-31', 8.7, 'A computer hacker learns from mysterious rebels about the true nature of his reality.', 'Lana Wachowski, Lilly Wachowski');

-- Insert sample data into Users Table
INSERT INTO Users (Username, PasswordHash, Email, FullName, PhoneNumber, SecurityQuestion, SecurityAnswer) VALUES
('john_doe', 'hash1', 'john@example.com', 'John Doe', '1234567890', 'Your first pet\'s name?', 'Fluffy'),
('admin_user', 'hash2', 'admin@example.com', 'Admin User', '0987654321', 'Your favorite teacher?', 'Mr. Smith');

-- Insert sample data into ShowTimes Table
INSERT INTO ShowTimes (MovieID, TheatreID, ShowDate, StartTime, EndTime, AvailableSeats, SeatAvailability) VALUES
(1, 1, '2024-08-10', '18:00', '20:28', 100, '11111111110000000000'), -- 10 seats available
(2, 2, '2024-08-11', '20:00', '22:16', 200, '11111111111111111111'); -- 20 seats available

-- Insert sample data into Bookings Table
INSERT INTO Bookings (UserID, MovieID, TheatreID, ShowTimeID, NumberOfSeats, Seats, TotalPrice, Status, PaymentMethod) VALUES
(1, 1, 1, 1, 2, '01,02', 20.00, 'Confirmed', 'Credit Card'),
(1, 2, 2, 2, 1, '03', 10.00, 'Confirmed', 'Debit Card');

-- Insert sample data into Payments Table
INSERT INTO Payments (BookingID, Amount, PaymentMethod, TransactionID) VALUES
(1, 20.00, 'Credit Card', 'TXN123456'),
(2, 10.00, 'Debit Card', 'TXN654321');

-- Insert sample data into Reviews Table
INSERT INTO Reviews (UserID, MovieID, Rating, Comment) VALUES
(1, 1, 5, 'Amazing movie!'),
(1, 2, 4, 'Great action scenes.');

-- 1. Retrieve All Movies with Their Details
SELECT MovieID, Title, Genre, Duration, ReleaseDate, Rating, Description, Director
FROM Movies;

-- 2. Find Available Showtimes for a Specific Movie
-- Replace {MovieID} with the desired MovieID
SELECT s.ShowTimeID, t.Name AS TheatreName, s.ShowDate, s.StartTime, s.EndTime, s.AvailableSeats
FROM ShowTimes s
JOIN Theatres t ON s.TheatreID = t.TheatreID
WHERE s.MovieID = {MovieID};

-- 3. Retrieve All Bookings Made by a Specific User with Seat Numbers
-- Replace {UserID} with the desired UserID
SELECT b.BookingID, m.Title, t.Name AS TheatreName, b.BookingDate, b.NumberOfSeats, b.Seats, b.TotalPrice, b.Status
FROM Bookings b
JOIN Movies m ON b.MovieID = m.MovieID
JOIN Theatres t ON b.TheatreID = t.TheatreID
WHERE b.UserID = {UserID};

-- 4. Calculate Total Revenue from Bookings
SELECT SUM(TotalPrice) AS TotalRevenue
FROM Bookings;

-- 5. Retrieve Reviews for a Specific Movie
-- Replace {MovieID} with the desired MovieID
SELECT r.ReviewID, u.FullName, r.Rating, r.Comment, r.ReviewDate
FROM Reviews r
JOIN Users u ON r.UserID = u.UserID
WHERE r.MovieID = {MovieID};

-- 6. Get the Most Popular Movies Based on Ratings
SELECT m.MovieID, m.Title, AVG(r.Rating) AS AverageRating
FROM Movies m
LEFT JOIN Reviews r ON m.MovieID = r.MovieID
GROUP BY m.MovieID, m.Title
ORDER BY AverageRating DESC;

-- 7. Get Available Seats for a Specific Showtime
-- Replace {ShowTimeID} with the desired ShowTimeID
SELECT AvailableSeats
FROM ShowTimes
WHERE ShowTimeID = {ShowTimeID};

-- 8. Update Available Seats After a Booking
-- Replace {SeatsBooked} with the actual number of seats booked and {ShowTimeID} with the desired ShowTimeID
UPDATE ShowTimes
SET AvailableSeats = AvailableSeats - {SeatsBooked}
WHERE ShowTimeID = {ShowTimeID};

-- 9. Retrieve All Theatres with Their Movies
SELECT t.Name AS TheatreName, m.Title AS MovieTitle
FROM Theatres t
JOIN ShowTimes s ON t.TheatreID = s.TheatreID
JOIN Movies m ON s.MovieID = m.MovieID
ORDER BY t.Name, m.Title;

-- 10. Get Users Who Have Made Bookings
SELECT DISTINCT u.UserID, u.FullName, u.Email
FROM Users u
JOIN Bookings b ON u.UserID = b.UserID;

-- 11. Get Booking Details by Booking ID with Seat Numbers
-- Replace {BookingID} with the desired BookingID
SELECT b.BookingID, m.Title, t.Name AS TheatreName, b.BookingDate, b.NumberOfSeats, b.Seats, b.TotalPrice, b.Status
FROM Bookings b
JOIN Movies m ON b.MovieID = m.MovieID
JOIN Theatres t ON b.TheatreID = t.TheatreID
WHERE b.BookingID = {BookingID};

-- 12. Get Total Bookings and Revenue per Movie
SELECT m.Title, COUNT(b.BookingID) AS TotalBookings, SUM(b.TotalPrice) AS TotalRevenue
FROM Movies m
LEFT JOIN Bookings b ON m.MovieID = b.MovieID
GROUP BY m.Title;

-- 13. Get Upcoming Shows for a Specific Theatre
-- Replace {TheatreID} with the desired TheatreID
SELECT s.ShowTimeID, m.Title, s.ShowDate, s.StartTime, s.EndTime, s.AvailableSeats
FROM ShowTimes s
JOIN Movies m ON s.MovieID = m.MovieID
WHERE s.TheatreID = {TheatreID} AND s.ShowDate >= CAST(GETDATE() AS DATE)
ORDER BY s.ShowDate, s.StartTime;

-- 14. Get Total Number of Users Registered
SELECT COUNT(UserID) AS TotalUsers
FROM Users;

-- 15. Get All Movies Released in a Specific Year
-- Replace {Year} with the desired year
SELECT *
FROM Movies
WHERE YEAR(ReleaseDate) = {Year};

-- 16. Get Theatres Showing a Specific Movie
-- Replace {MovieID} with the desired MovieID
SELECT DISTINCT t.Name AS TheatreName
FROM Theatres t
JOIN ShowTimes s ON t.TheatreID = s.TheatreID
WHERE s.MovieID = {MovieID};

-- 17. Get All Upcoming Movies with Their Release Dates
SELECT Title, ReleaseDate
FROM Movies
WHERE ReleaseDate >= CAST(GETDATE() AS DATE)
ORDER BY ReleaseDate;

-- 18. Get User Booking History with Movies and Theatres
-- Replace {UserID} with the desired UserID
SELECT b.BookingID, m.Title, t.Name AS TheatreName, b.BookingDate, b.NumberOfSeats, b.TotalPrice, b.Status
FROM Bookings b
JOIN Movies m ON b.MovieID = m.MovieID
JOIN Theatres t ON b.TheatreID = t.TheatreID
WHERE b.UserID = {UserID}
ORDER BY b.BookingDate DESC;

-- 19. Get Total Bookings Per User
SELECT u.UserID, u.FullName, COUNT(b.BookingID) AS TotalBookings
FROM Users u
LEFT JOIN Bookings b ON u.UserID = b.UserID
GROUP BY u.UserID, u.FullName
ORDER BY TotalBookings DESC;

-- 20. Get Movies with Average Ratings Below a Certain Threshold
-- Replace {RatingThreshold} with the desired rating threshold
SELECT m.Title, AVG(r.Rating) AS AverageRating
FROM Movies m
LEFT JOIN Reviews r ON m.MovieID = r.MovieID
GROUP BY m.MovieID, m.Title
HAVING AVG(r.Rating) < {RatingThreshold};

-- 21. Get Available Showtimes for All Movies in a Specific Theatre
-- Replace {TheatreID} with the desired TheatreID
SELECT m.Title, s.ShowTimeID, s.ShowDate, s.StartTime, s.EndTime, s.AvailableSeats
FROM ShowTimes s
JOIN Movies m ON s.MovieID = m.MovieID
WHERE s.TheatreID = {TheatreID} AND s.AvailableSeats > 0
ORDER BY s.ShowDate, s.StartTime;

-- 22. Get Total Revenue Per Movie
SELECT m.Title, SUM(b.TotalPrice) AS TotalRevenue
FROM Movies m
LEFT JOIN Bookings b ON m.MovieID = b.MovieID
GROUP BY m.Title
ORDER BY TotalRevenue DESC;

-- 23. Get Users Who Have Left Reviews
SELECT DISTINCT u.UserID, u.FullName
FROM Users u
JOIN Reviews r ON u.UserID = r.UserID;

-- 24. Get Most Recent Bookings
SELECT TOP 10 b.BookingID, m.Title, t.Name AS TheatreName, b.BookingDate, b.NumberOfSeats, b.TotalPrice, b.Status
FROM Bookings b
JOIN Movies m ON b.MovieID = m.MovieID
JOIN Theatres t ON b.TheatreID = t.TheatreID
ORDER BY b.BookingDate DESC;

-- 25. Get All Showtimes for a Specific Movie in a Specific Theatre
-- Replace {MovieID} with the desired MovieID and {TheatreID} with the desired TheatreID
SELECT s.ShowTimeID, s.ShowDate, s.StartTime, s.EndTime, s.AvailableSeats
FROM ShowTimes s
WHERE s.MovieID = {MovieID} AND s.TheatreID = {TheatreID}
ORDER BY s.ShowDate, s.StartTime;
