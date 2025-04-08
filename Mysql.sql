create database sport_quiz_app;
use sport_quiz_app;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  username VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  dob DATE,
  gender ENUM('Male', 'Female'),
  weight FLOAT,
  height FLOAT
);

INSERT INTO users (username, password)
VALUES ('BB', '1234');

select * from users;

grant all privileges on sport_quiz_app.* to 'New2'@'localhost';
drop table users;