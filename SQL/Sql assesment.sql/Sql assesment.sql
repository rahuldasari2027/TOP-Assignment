-- Create Database
CREATE DATABASE video_platform;
USE video_platform;


CREATE TABLE viewers (
    viewer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);


CREATE TABLE films (
    film_id INT AUTO_INCREMENT PRIMARY KEY,
    film_title VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    year_released INT NOT NULL
);

-- Trigger
DELIMITER //

CREATE TRIGGER fix_year_before_insert
BEFORE INSERT ON films
FOR EACH ROW
BEGIN
    IF NEW.year_released < 0 THEN
        SET NEW.year_released = 0;
    END IF;
END //

DELIMITER ;


CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    viewer_id INT,
    film_id INT,
    score DECIMAL(2,1) CHECK (score BETWEEN 1 AND 5),
    review_date DATE,
    FOREIGN KEY (viewer_id) REFERENCES viewers(viewer_id),
    FOREIGN KEY (film_id) REFERENCES films(film_id)
);


CREATE TABLE viewing_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    viewer_id INT,
    film_id INT,
    view_date DATE,
    FOREIGN KEY (viewer_id) REFERENCES viewers(viewer_id),
    FOREIGN KEY (film_id) REFERENCES films(film_id)
);


INSERT INTO viewers (full_name, region) VALUES
('Rahul Mehta', 'India'),
('Emma Watson', 'UK'),
('John Carter', 'USA'),
('Li Wei', 'China'),
('Carlos Diaz', 'Mexico');

INSERT INTO films (film_title, category, year_released) VALUES
('Interstellar', 'Sci-Fi', 2014),
('The Dark Knight', 'Action', 2008),
('Joker', 'Drama', 2019),
('Avatar', 'Sci-Fi', 2009),
('Titanic', 'Romance', 1997);

INSERT INTO reviews (viewer_id, film_id, score, review_date) VALUES
(1, 1, 5, '2023-01-10'),
(1, 2, 4, '2023-02-11'),
(2, 3, 5, '2023-03-12'),
(3, 1, 4, '2023-04-15'),
(4, 4, 5, '2023-05-20');

INSERT INTO viewing_log (viewer_id, film_id, view_date) VALUES
(1, 1, '2023-01-05'),
(1, 2, '2023-02-07'),
(2, 3, '2023-03-08'),
(3, 1, '2023-04-09'),
(4, 4, '2023-05-10'),
(1, 1, '2023-06-01');

-- =========================
-- QUERIES
-- =========================


SELECT region, category, total_views
FROM (
    SELECT v.region, f.category, COUNT(*) AS total_views,
    RANK() OVER (PARTITION BY v.region ORDER BY COUNT(*) DESC) AS rnk
    FROM viewing_log vl
    JOIN viewers v ON vl.viewer_id = v.viewer_id
    JOIN films f ON vl.film_id = f.film_id
    GROUP BY v.region, f.category
) ranked
WHERE rnk = 1;


SELECT viewer_id, COUNT(*) AS review_count
FROM reviews
GROUP BY viewer_id
ORDER BY review_count DESC;


SELECT film_title, year_released
FROM films
WHERE year_released > 2010;


SELECT f.category, AVG(r.score) AS avg_score
FROM reviews r
JOIN films f ON r.film_id = f.film_id
GROUP BY f.category
ORDER BY avg_score DESC;


SELECT v.full_name, f.film_title, COUNT(*) AS watch_count
FROM viewing_log vl
JOIN viewers v ON vl.viewer_id = v.viewer_id
JOIN films f ON vl.film_id = f.film_id
GROUP BY v.viewer_id, f.film_id
HAVING COUNT(*) > 1;