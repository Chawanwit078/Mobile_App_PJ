create database sport_quiz_app;
use sport_quiz_app;

grant all privileges on sport_quiz_app.* to 'Pattaraporn'@'localhost';

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
INSERT INTO users (username, password) VALUES 
('AA', '1234'),
('BB', '1234');


CREATE TABLE user_quiz_results (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  selected_type VARCHAR(50),   -- เช่น "indoor"
  selected_style VARCHAR(50),  -- เช่น "solo"
  sport_id INT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (sport_id) REFERENCES sports(id) ON DELETE CASCADE
);
INSERT INTO user_quiz_results (user_id, selected_type, selected_style,sport_id) VALUES 
(1,"Indoor","Solo sports",1),
(1,"Indoor","Solo sports",2);





-- SPORT PART
CREATE TABLE sports (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  pic VARCHAR(50),
  duration INT,
  calories INT,
  type VARCHAR(50),
  style VARCHAR(50)
);

CREATE TABLE sport_description (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sport_id INT,
  description TEXT,
  FOREIGN KEY (sport_id) REFERENCES sports(id) ON DELETE CASCADE
);

CREATE TABLE sport_postures (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sport_id INT,
  posture TEXT,
  FOREIGN KEY (sport_id) REFERENCES sports(id) ON DELETE CASCADE
);

CREATE TABLE sport_benefits (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sport_id INT,
  benefit TEXT,
  FOREIGN KEY (sport_id) REFERENCES sports(id) ON DELETE CASCADE
);

select * from users;
select * from user_quiz_results;
select * from sports;
show tables;








-- sport 1 and 2
INSERT INTO sports (name, pic, duration, calories, type, style) VALUES 
('Swimming', 'swimming.jpg', 60, 450, 'Indoor', 'Solo sports'),
('Yoga', 'yoga.jpg', 30, 180, 'Indoor', 'Solo sports');


INSERT INTO sport_description (sport_id, description) VALUES
(1, 'Swimming is a full-body aerobic exercise that enhances muscular strength, cardiovascular endurance, and lung capacity. It''s a low-impact workout, making it suitable for all ages and fitness levels. Swimming is also effective for burning calories and boosting circulation.'),
(2, 'Yoga is a mind-body practice that combines physical postures, breathing techniques, and meditation. It improves flexibility, balance, and mental clarity. Yoga is suitable for all fitness levels and helps reduce stress.');

INSERT INTO sport_postures (sport_id, posture) VALUES
-- Swimming
(1, 'Freestyle – A fast-paced stroke using alternating arm movements and flutter kicks to propel forward.'),
(1, 'Breaststroke – A slower, more controlled stroke using simultaneous arm and leg movements, great for endurance.'),
(1, 'Backstroke – Performed on your back with coordinated arm lifts and flutter kicks, engaging the back and shoulder muscles.'),

-- Yoga
(2, 'Downward Dog – A full-body stretch that improves flexibility and circulation.'),
(2, 'Warrior Pose – Builds strength and stamina in legs and core.'),
(2, 'Tree Pose – Enhances balance and focus by standing on one leg.');

INSERT INTO sport_benefits (sport_id, benefit) VALUES
-- Swimming
(1, 'Improves cardiovascular and lung health'),
(1, 'Burns calories efficiently'),
(1, 'Low impact on joints'),
(1, 'Builds full-body strength'),

-- Yoga
(2, 'Improves flexibility and posture'),
(2, 'Reduces stress and anxiety'),
(2, 'Enhances breathing and lung capacity'),
(2, 'Strengthens muscles and improves balance');



-- 3. TABLE TENNIS
-- 1. sports
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Team Table-Tennis', 'Team_Table_Tennis.jpg', 20, 150, 'Indoor', 'Team sports');

-- 2. sport_postures
INSERT INTO sport_postures (sport_id, posture) VALUES
(3, 'Doubles Rally – Fast-paced rallies between two-player teams requiring coordination and quick reflexes.'),
(3, 'Serve & Receive – Strategic serving and receiving techniques to outmaneuver opponents.'),
(3, 'Spin Techniques – Using topspin, backspin, and sidespin to create unpredictable ball movement.');

-- 3. sport_description
INSERT INTO sport_description (sport_id, description)
VALUES (
  3,
  'Team Table-Tennis is a fast-paced indoor sport where two teams of two players compete in quick and strategic rallies. It requires precise coordination, reflexes, and communication, making it both a mental and physical challenge.'
);

-- 4. sport_benefits
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(3, 'Enhances hand-eye coordination'),
(3, 'Improves team communication'),
(3, 'Boosts reflexes and agility'),
(3, 'Encourages strategic thinking');

-- 4. Handball
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Handball', 'Handball.jpg', 30, 320, 'Indoor', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(4, 'Basic Handball Techniques – Fundamental movements and skills required to perform in handball.'),
(4, 'Advanced Strategies – Tactical or technical maneuvers used in competitive handball.'),
(4, 'Endurance Training – Exercises and drills to improve performance in handball.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  4,
  'Handball is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(4, 'Improves physical strength and stamina'),
(4, 'Enhances coordination and balance'),
(4, 'Boosts mental focus and discipline'),
(4, 'Provides full-body workout');

-- 5. Dodgeball
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Dodgeball', 'Dodgeball.jpg', 30, 200, 'Indoor', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(5, 'Basic Dodgeball Techniques – Fundamental movements and skills required to perform in dodgeball.'),
(5, 'Advanced Strategies – Tactical or technical maneuvers used in competitive dodgeball.'),
(5, 'Endurance Training – Exercises and drills to improve performance in dodgeball.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  5,
  'Dodgeball is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(5, 'Improves physical strength and stamina'),
(5, 'Enhances coordination and balance'),
(5, 'Boosts mental focus and discipline'),
(5, 'Provides full-body workout');

-- 6. Soccer
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Soccer', 'Soccer.jpg', 30, 230, 'Outdoor', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(6, 'Basic Soccer Techniques – Fundamental movements and skills required to perform in soccer.'),
(6, 'Advanced Strategies – Tactical or technical maneuvers used in competitive soccer.'),
(6, 'Endurance Training – Exercises and drills to improve performance in soccer.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  6,
  'Soccer is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(6, 'Improves physical strength and stamina'),
(6, 'Enhances coordination and balance'),
(6, 'Boosts mental focus and discipline'),
(6, 'Provides full-body workout');

-- 7. Cricket
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Cricket', 'Cricket.jpg', 30, 260, 'Outdoor', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(7, 'Basic Cricket Techniques – Fundamental movements and skills required to perform in cricket.'),
(7, 'Advanced Strategies – Tactical or technical maneuvers used in competitive cricket.'),
(7, 'Endurance Training – Exercises and drills to improve performance in cricket.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  7,
  'Cricket is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(7, 'Improves physical strength and stamina'),
(7, 'Enhances coordination and balance'),
(7, 'Boosts mental focus and discipline'),
(7, 'Provides full-body workout');

-- 8. Rugby
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Rugby', 'Rugby.jpg', 30, 290, 'Outdoor', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(8, 'Basic Rugby Techniques – Fundamental movements and skills required to perform in rugby.'),
(8, 'Advanced Strategies – Tactical or technical maneuvers used in competitive rugby.'),
(8, 'Endurance Training – Exercises and drills to improve performance in rugby.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  8,
  'Rugby is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(8, 'Improves physical strength and stamina'),
(8, 'Enhances coordination and balance'),
(8, 'Boosts mental focus and discipline'),
(8, 'Provides full-body workout');

-- 9. Basketball
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Basketball', 'Basketball.jpg', 30, 320, 'No preference', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(9, 'Basic Basketball Techniques – Fundamental movements and skills required to perform in basketball.'),
(9, 'Advanced Strategies – Tactical or technical maneuvers used in competitive basketball.'),
(9, 'Endurance Training – Exercises and drills to improve performance in basketball.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  9,
  'Basketball is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(9, 'Improves physical strength and stamina'),
(9, 'Enhances coordination and balance'),
(9, 'Boosts mental focus and discipline'),
(9, 'Provides full-body workout');

-- 10. Lacrosse
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Lacrosse', 'Lacrosse.jpg', 30, 200, 'No preference', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(10, 'Basic Lacrosse Techniques – Fundamental movements and skills required to perform in lacrosse.'),
(10, 'Advanced Strategies – Tactical or technical maneuvers used in competitive lacrosse.'),
(10, 'Endurance Training – Exercises and drills to improve performance in lacrosse.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  10,
  'Lacrosse is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(10, 'Improves physical strength and stamina'),
(10, 'Enhances coordination and balance'),
(10, 'Boosts mental focus and discipline'),
(10, 'Provides full-body workout');

-- 11. Field Hockey
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Field Hockey', 'Field Hockey.jpg', 30, 230, 'No preference', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(11, 'Basic Field Hockey Techniques – Fundamental movements and skills required to perform in field hockey.'),
(11, 'Advanced Strategies – Tactical or technical maneuvers used in competitive field hockey.'),
(11, 'Endurance Training – Exercises and drills to improve performance in field hockey.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  11,
  'Field Hockey is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(11, 'Improves physical strength and stamina'),
(11, 'Enhances coordination and balance'),
(11, 'Boosts mental focus and discipline'),
(11, 'Provides full-body workout');

-- 12. Badminton
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Badminton', 'Badminton.jpg', 30, 260, 'Indoor', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(12, 'Basic Badminton Techniques – Fundamental movements and skills required to perform in badminton.'),
(12, 'Advanced Strategies – Tactical or technical maneuvers used in competitive badminton.'),
(12, 'Endurance Training – Exercises and drills to improve performance in badminton.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  12,
  'Badminton is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(12, 'Improves physical strength and stamina'),
(12, 'Enhances coordination and balance'),
(12, 'Boosts mental focus and discipline'),
(12, 'Provides full-body workout');

-- 13. Martial Arts
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Martial Arts', 'Martial Arts.jpg', 30, 290, 'Indoor', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(13, 'Basic Martial Arts Techniques – Fundamental movements and skills required to perform in martial arts.'),
(13, 'Advanced Strategies – Tactical or technical maneuvers used in competitive martial arts.'),
(13, 'Endurance Training – Exercises and drills to improve performance in martial arts.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  13,
  'Martial Arts is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(13, 'Improves physical strength and stamina'),
(13, 'Enhances coordination and balance'),
(13, 'Boosts mental focus and discipline'),
(13, 'Provides full-body workout');

-- 14. Running
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Running', 'Running.jpg', 30, 320, 'Outdoor', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(14, 'Basic Running Techniques – Fundamental movements and skills required to perform in running.'),
(14, 'Advanced Strategies – Tactical or technical maneuvers used in competitive running.'),
(14, 'Endurance Training – Exercises and drills to improve performance in running.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  14,
  'Running is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(14, 'Improves physical strength and stamina'),
(14, 'Enhances coordination and balance'),
(14, 'Boosts mental focus and discipline'),
(14, 'Provides full-body workout');

-- 15. Cycling
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Cycling', 'Cycling.jpg', 30, 200, 'Outdoor', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(15, 'Basic Cycling Techniques – Fundamental movements and skills required to perform in cycling.'),
(15, 'Advanced Strategies – Tactical or technical maneuvers used in competitive cycling.'),
(15, 'Endurance Training – Exercises and drills to improve performance in cycling.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  15,
  'Cycling is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(15, 'Improves physical strength and stamina'),
(15, 'Enhances coordination and balance'),
(15, 'Boosts mental focus and discipline'),
(15, 'Provides full-body workout');

-- 16. Rock Climbing
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Rock Climbing', 'Rock Climbing.jpg', 30, 230, 'Outdoor', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(16, 'Basic Rock Climbing Techniques – Fundamental movements and skills required to perform in rock climbing.'),
(16, 'Advanced Strategies – Tactical or technical maneuvers used in competitive rock climbing.'),
(16, 'Endurance Training – Exercises and drills to improve performance in rock climbing.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  16,
  'Rock Climbing is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(16, 'Improves physical strength and stamina'),
(16, 'Enhances coordination and balance'),
(16, 'Boosts mental focus and discipline'),
(16, 'Provides full-body workout');

-- 17. Archery
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Archery', 'Archery.jpg', 30, 260, 'No preference', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(17, 'Basic Archery Techniques – Fundamental movements and skills required to perform in archery.'),
(17, 'Advanced Strategies – Tactical or technical maneuvers used in competitive archery.'),
(17, 'Endurance Training – Exercises and drills to improve performance in archery.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  17,
  'Archery is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(17, 'Improves physical strength and stamina'),
(17, 'Enhances coordination and balance'),
(17, 'Boosts mental focus and discipline'),
(17, 'Provides full-body workout');

-- 18. Shooting
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Shooting', 'Shooting.jpg', 30, 290, 'No preference', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(18, 'Basic Shooting Techniques – Fundamental movements and skills required to perform in shooting.'),
(18, 'Advanced Strategies – Tactical or technical maneuvers used in competitive shooting.'),
(18, 'Endurance Training – Exercises and drills to improve performance in shooting.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  18,
  'Shooting is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(18, 'Improves physical strength and stamina'),
(18, 'Enhances coordination and balance'),
(18, 'Boosts mental focus and discipline'),
(18, 'Provides full-body workout');

-- 19. Roller Skating
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Roller Skating', 'Roller Skating.jpg', 30, 320, 'No preference', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(19, 'Basic Roller Skating Techniques – Fundamental movements and skills required to perform in roller skating.'),
(19, 'Advanced Strategies – Tactical or technical maneuvers used in competitive roller skating.'),
(19, 'Endurance Training – Exercises and drills to improve performance in roller skating.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  19,
  'Roller Skating is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(19, 'Improves physical strength and stamina'),
(19, 'Enhances coordination and balance'),
(19, 'Boosts mental focus and discipline'),
(19, 'Provides full-body workout');

-- 20. Indoor Climbing
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Indoor Climbing', 'Indoor Climbing.jpg', 30, 200, 'Indoor', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(20, 'Basic Indoor Climbing Techniques – Fundamental movements and skills required to perform in indoor climbing.'),
(20, 'Advanced Strategies – Tactical or technical maneuvers used in competitive indoor climbing.'),
(20, 'Endurance Training – Exercises and drills to improve performance in indoor climbing.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  20,
  'Indoor Climbing is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(20, 'Improves physical strength and stamina'),
(20, 'Enhances coordination and balance'),
(20, 'Boosts mental focus and discipline'),
(20, 'Provides full-body workout');

-- 21. Indoor Skateboarding
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Indoor Skateboarding', 'Indoor Skateboarding.jpg', 30, 230, 'Indoor', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(21, 'Basic Indoor Skateboarding Techniques – Fundamental movements and skills required to perform in indoor skateboarding.'),
(21, 'Advanced Strategies – Tactical or technical maneuvers used in competitive indoor skateboarding.'),
(21, 'Endurance Training – Exercises and drills to improve performance in indoor skateboarding.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  21,
  'Indoor Skateboarding is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(21, 'Improves physical strength and stamina'),
(21, 'Enhances coordination and balance'),
(21, 'Boosts mental focus and discipline'),
(21, 'Provides full-body workout');

-- 22. Bouldering
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Bouldering', 'Bouldering.jpg', 30, 260, 'Indoor', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(22, 'Basic Bouldering Techniques – Fundamental movements and skills required to perform in bouldering.'),
(22, 'Advanced Strategies – Tactical or technical maneuvers used in competitive bouldering.'),
(22, 'Endurance Training – Exercises and drills to improve performance in bouldering.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  22,
  'Bouldering is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(22, 'Improves physical strength and stamina'),
(22, 'Enhances coordination and balance'),
(22, 'Boosts mental focus and discipline'),
(22, 'Provides full-body workout');

-- 23. Mountain Biking
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Mountain Biking', 'Mountain Biking.jpg', 30, 290, 'Outdoor', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(23, 'Basic Mountain Biking Techniques – Fundamental movements and skills required to perform in mountain biking.'),
(23, 'Advanced Strategies – Tactical or technical maneuvers used in competitive mountain biking.'),
(23, 'Endurance Training – Exercises and drills to improve performance in mountain biking.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  23,
  'Mountain Biking is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(23, 'Improves physical strength and stamina'),
(23, 'Enhances coordination and balance'),
(23, 'Boosts mental focus and discipline'),
(23, 'Provides full-body workout');

-- 24. Skydiving
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Skydiving', 'Skydiving.jpg', 30, 320, 'Outdoor', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(24, 'Basic Skydiving Techniques – Fundamental movements and skills required to perform in skydiving.'),
(24, 'Advanced Strategies – Tactical or technical maneuvers used in competitive skydiving.'),
(24, 'Endurance Training – Exercises and drills to improve performance in skydiving.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  24,
  'Skydiving is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(24, 'Improves physical strength and stamina'),
(24, 'Enhances coordination and balance'),
(24, 'Boosts mental focus and discipline'),
(24, 'Provides full-body workout');

-- 25. Cliff Climbing
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Cliff Climbing', 'Cliff Climbing.jpg', 30, 200, 'Outdoor', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(25, 'Basic Cliff Climbing Techniques – Fundamental movements and skills required to perform in cliff climbing.'),
(25, 'Advanced Strategies – Tactical or technical maneuvers used in competitive cliff climbing.'),
(25, 'Endurance Training – Exercises and drills to improve performance in cliff climbing.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  25,
  'Cliff Climbing is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(25, 'Improves physical strength and stamina'),
(25, 'Enhances coordination and balance'),
(25, 'Boosts mental focus and discipline'),
(25, 'Provides full-body workout');

-- 26. Parkour
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Parkour', 'Parkour.jpg', 30, 230, 'No preference', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(26, 'Basic Parkour Techniques – Fundamental movements and skills required to perform in parkour.'),
(26, 'Advanced Strategies – Tactical or technical maneuvers used in competitive parkour.'),
(26, 'Endurance Training – Exercises and drills to improve performance in parkour.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  26,
  'Parkour is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(26, 'Improves physical strength and stamina'),
(26, 'Enhances coordination and balance'),
(26, 'Boosts mental focus and discipline'),
(26, 'Provides full-body workout');

-- 27. Freestyle Skateboarding
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Freestyle Skateboarding', 'Freestyle Skateboarding.jpg', 30, 260, 'No preference', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(27, 'Basic Freestyle Skateboarding Techniques – Fundamental movements and skills required to perform in freestyle skateboarding.'),
(27, 'Advanced Strategies – Tactical or technical maneuvers used in competitive freestyle skateboarding.'),
(27, 'Endurance Training – Exercises and drills to improve performance in freestyle skateboarding.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  27,
  'Freestyle Skateboarding is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(27, 'Improves physical strength and stamina'),
(27, 'Enhances coordination and balance'),
(27, 'Boosts mental focus and discipline'),
(27, 'Provides full-body workout');

-- 28. Paragliding
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Paragliding', 'Paragliding.jpg', 30, 290, 'No preference', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(28, 'Basic Paragliding Techniques – Fundamental movements and skills required to perform in paragliding.'),
(28, 'Advanced Strategies – Tactical or technical maneuvers used in competitive paragliding.'),
(28, 'Endurance Training – Exercises and drills to improve performance in paragliding.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  28,
  'Paragliding is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(28, 'Improves physical strength and stamina'),
(28, 'Enhances coordination and balance'),
(28, 'Boosts mental focus and discipline'),
(28, 'Provides full-body workout');

-- 29. Water Polo
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Water Polo', 'Water Polo.jpg', 30, 320, 'Indoor', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(29, 'Basic Water Polo Techniques – Fundamental movements and skills required to perform in water polo.'),
(29, 'Advanced Strategies – Tactical or technical maneuvers used in competitive water polo.'),
(29, 'Endurance Training – Exercises and drills to improve performance in water polo.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  29,
  'Water Polo is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(29, 'Improves physical strength and stamina'),
(29, 'Enhances coordination and balance'),
(29, 'Boosts mental focus and discipline'),
(29, 'Provides full-body workout');

-- 30. Diving
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Diving', 'Diving.jpg', 30, 200, 'Indoor', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(30, 'Basic Diving Techniques – Fundamental movements and skills required to perform in diving.'),
(30, 'Advanced Strategies – Tactical or technical maneuvers used in competitive diving.'),
(30, 'Endurance Training – Exercises and drills to improve performance in diving.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  30,
  'Diving is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(30, 'Improves physical strength and stamina'),
(30, 'Enhances coordination and balance'),
(30, 'Boosts mental focus and discipline'),
(30, 'Provides full-body workout');

-- 31. Surfing
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Surfing', 'Surfing.jpg', 30, 230, 'Outdoor', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(31, 'Basic Surfing Techniques – Fundamental movements and skills required to perform in surfing.'),
(31, 'Advanced Strategies – Tactical or technical maneuvers used in competitive surfing.'),
(31, 'Endurance Training – Exercises and drills to improve performance in surfing.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  31,
  'Surfing is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(31, 'Improves physical strength and stamina'),
(31, 'Enhances coordination and balance'),
(31, 'Boosts mental focus and discipline'),
(31, 'Provides full-body workout');

-- 32. Canoeing
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Canoeing', 'Canoeing.jpg', 30, 260, 'Outdoor', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(32, 'Basic Canoeing Techniques – Fundamental movements and skills required to perform in canoeing.'),
(32, 'Advanced Strategies – Tactical or technical maneuvers used in competitive canoeing.'),
(32, 'Endurance Training – Exercises and drills to improve performance in canoeing.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  32,
  'Canoeing is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(32, 'Improves physical strength and stamina'),
(32, 'Enhances coordination and balance'),
(32, 'Boosts mental focus and discipline'),
(32, 'Provides full-body workout');

-- 33. Windsurfing
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Windsurfing', 'Windsurfing.jpg', 30, 290, 'Outdoor', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(33, 'Basic Windsurfing Techniques – Fundamental movements and skills required to perform in windsurfing.'),
(33, 'Advanced Strategies – Tactical or technical maneuvers used in competitive windsurfing.'),
(33, 'Endurance Training – Exercises and drills to improve performance in windsurfing.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  33,
  'Windsurfing is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(33, 'Improves physical strength and stamina'),
(33, 'Enhances coordination and balance'),
(33, 'Boosts mental focus and discipline'),
(33, 'Provides full-body workout');

-- 34. Kayaking
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Kayaking', 'Kayaking.jpg', 30, 320, 'No preference', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(34, 'Basic Kayaking Techniques – Fundamental movements and skills required to perform in kayaking.'),
(34, 'Advanced Strategies – Tactical or technical maneuvers used in competitive kayaking.'),
(34, 'Endurance Training – Exercises and drills to improve performance in kayaking.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  34,
  'Kayaking is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(34, 'Improves physical strength and stamina'),
(34, 'Enhances coordination and balance'),
(34, 'Boosts mental focus and discipline'),
(34, 'Provides full-body workout');

-- 35. Snorkeling
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Snorkeling', 'Snorkeling.jpg', 30, 200, 'No preference', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(35, 'Basic Snorkeling Techniques – Fundamental movements and skills required to perform in snorkeling.'),
(35, 'Advanced Strategies – Tactical or technical maneuvers used in competitive snorkeling.'),
(35, 'Endurance Training – Exercises and drills to improve performance in snorkeling.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  35,
  'Snorkeling is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(35, 'Improves physical strength and stamina'),
(35, 'Enhances coordination and balance'),
(35, 'Boosts mental focus and discipline'),
(35, 'Provides full-body workout');

-- 36. Free Diving
INSERT INTO sports (name, pic, duration, calories, type, style)
VALUES ('Free Diving', 'Free Diving.jpg', 30, 230, 'No preference', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(36, 'Basic Free Diving Techniques – Fundamental movements and skills required to perform in free diving.'),
(36, 'Advanced Strategies – Tactical or technical maneuvers used in competitive free diving.'),
(36, 'Endurance Training – Exercises and drills to improve performance in free diving.');
INSERT INTO sport_description (sport_id, description)
VALUES (
  36,
  'Free Diving is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);
INSERT INTO sport_benefits (sport_id, benefit) VALUES
(36, 'Improves physical strength and stamina'),
(36, 'Enhances coordination and balance'),
(36, 'Boosts mental focus and discipline'),
(36, 'Provides full-body workout');