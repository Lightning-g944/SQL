CREATE TABLE if NOT EXISTS Pages (
    page_id INT PRIMARY KEY,
    page_name VARCHAR(255) NOT NULL
);

INSERT INTO Pages (page_id, page_name) VALUES (20001, 'SQL Solutions');
INSERT INTO Pages (page_id, page_name) VALUES (20045, 'Brain Exercises');
INSERT INTO Pages (page_id, page_name) VALUES (20701, 'Tips for Data Analysts');
INSERT INTO Pages (page_id, page_name) VALUES (31111, 'Postgres Crash Course');
INSERT INTO Pages (page_id, page_name) VALUES (32728, 'Break the thread');

CREATE TABLE if NOT EXISTS page_likes (
    user_id INTEGER,
    page_id INTEGER,
    liked_date TIMESTAMP WITHOUT TIME ZONE
);

INSERT INTO Page_Likes (user_id, page_id, liked_date) VALUES 
(111, 20001, '2022-04-08 00:00:00'),
(121, 20045, '2022-03-12 00:00:00'),
(156, 20001, '2022-07-25 00:00:00'),
(255, 20045, '2022-07-19 00:00:00'),
(125, 20001, '2022-07-19 00:00:00'),
(144, 31111, '2022-06-21 00:00:00'),
(125, 31111, '2022-07-04 00:00:00');