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



-- 4. Soccer
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (4, 'Soccer', 'Soccer.jpg', 30, 230, 'Outdoor', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(4, 'Basic Soccer Techniques – Fundamental movements and skills required to perform in soccer.'),
(4, 'Advanced Strategies – Tactical or technical maneuvers used in competitive soccer.'),
(4, 'Endurance Training – Exercises and drills to improve performance in soccer.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  4,
  'Soccer is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(4, 'Improves physical strength and stamina'),
(4, 'Enhances coordination and balance'),
(4, 'Boosts mental focus and discipline'),
(4, 'Provides full-body workout');



-- 5. Basketball
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (5, 'Basketball', 'Basketball.jpg', 30, 320, 'No preference', 'Team sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(5, 'Basic Basketball Techniques – Fundamental movements and skills required to perform in basketball.'),
(5, 'Advanced Strategies – Tactical or technical maneuvers used in competitive basketball.'),
(5, 'Endurance Training – Exercises and drills to improve performance in basketball.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  5,
  'Basketball is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(5, 'Improves physical strength and stamina'),
(5, 'Enhances coordination and balance'),
(5, 'Boosts mental focus and discipline'),
(5, 'Provides full-body workout');



-- 6. Running
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (6, 'Running', 'Running.jpg', 30, 320, 'Outdoor', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(6, 'Basic Running Techniques – Fundamental movements and skills required to perform in running.'),
(6, 'Advanced Strategies – Tactical or technical maneuvers used in competitive running.'),
(6, 'Endurance Training – Exercises and drills to improve performance in running.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  6,
  'Running is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(6, 'Improves physical strength and stamina'),
(6, 'Enhances coordination and balance'),
(6, 'Boosts mental focus and discipline'),
(6, 'Provides full-body workout');



-- 7. Archery
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (7, 'Archery', 'Archery.jpg', 30, 260, 'No preference', 'Solo sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(7, 'Basic Archery Techniques – Fundamental movements and skills required to perform in archery.'),
(7, 'Advanced Strategies – Tactical or technical maneuvers used in competitive archery.'),
(7, 'Endurance Training – Exercises and drills to improve performance in archery.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  7,
  'Archery is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(7, 'Improves physical strength and stamina'),
(7, 'Enhances coordination and balance'),
(7, 'Boosts mental focus and discipline'),
(7, 'Provides full-body workout');



-- 8. Indoor Climbing
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (8, 'Indoor Climbing', 'Indoor Climbing.jpg', 30, 200, 'Indoor', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(8, 'Basic Indoor Climbing Techniques – Fundamental movements and skills required to perform in indoor climbing.'),
(8, 'Advanced Strategies – Tactical or technical maneuvers used in competitive indoor climbing.'),
(8, 'Endurance Training – Exercises and drills to improve performance in indoor climbing.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  8,
  'Indoor Climbing is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(8, 'Improves physical strength and stamina'),
(8, 'Enhances coordination and balance'),
(8, 'Boosts mental focus and discipline'),
(8, 'Provides full-body workout');



-- 9. Mountain Biking
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (9, 'Mountain Biking', 'Mountain Biking.jpg', 30, 290, 'Outdoor', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(9, 'Basic Mountain Biking Techniques – Fundamental movements and skills required to perform in mountain biking.'),
(9, 'Advanced Strategies – Tactical or technical maneuvers used in competitive mountain biking.'),
(9, 'Endurance Training – Exercises and drills to improve performance in mountain biking.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  9,
  'Mountain Biking is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(9, 'Improves physical strength and stamina'),
(9, 'Enhances coordination and balance'),
(9, 'Boosts mental focus and discipline'),
(9, 'Provides full-body workout');



-- 10. Parkour
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (10, 'Parkour', 'Parkour.jpg', 30, 230, 'No preference', 'Extreme sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(10, 'Basic Parkour Techniques – Fundamental movements and skills required to perform in parkour.'),
(10, 'Advanced Strategies – Tactical or technical maneuvers used in competitive parkour.'),
(10, 'Endurance Training – Exercises and drills to improve performance in parkour.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  10,
  'Parkour is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(10, 'Improves physical strength and stamina'),
(10, 'Enhances coordination and balance'),
(10, 'Boosts mental focus and discipline'),
(10, 'Provides full-body workout');



-- 11. Water Polo
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (11, 'Water Polo', 'Water Polo.jpg', 30, 320, 'Indoor', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(11, 'Basic Water Polo Techniques – Fundamental movements and skills required to perform in water polo.'),
(11, 'Advanced Strategies – Tactical or technical maneuvers used in competitive water polo.'),
(11, 'Endurance Training – Exercises and drills to improve performance in water polo.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  11,
  'Water Polo is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(11, 'Improves physical strength and stamina'),
(11, 'Enhances coordination and balance'),
(11, 'Boosts mental focus and discipline'),
(11, 'Provides full-body workout');



-- 12. Surfing
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (12, 'Surfing', 'Surfing.jpg', 30, 230, 'Outdoor', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(12, 'Basic Surfing Techniques – Fundamental movements and skills required to perform in surfing.'),
(12, 'Advanced Strategies – Tactical or technical maneuvers used in competitive surfing.'),
(12, 'Endurance Training – Exercises and drills to improve performance in surfing.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  12,
  'Surfing is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(12, 'Improves physical strength and stamina'),
(12, 'Enhances coordination and balance'),
(12, 'Boosts mental focus and discipline'),
(12, 'Provides full-body workout');



-- 13. Kayaking
INSERT INTO sports (id, name, pic, duration, calories, type, style)
VALUES (13, 'Kayaking', 'Kayaking.jpg', 30, 320, 'No preference', 'Water sports');

INSERT INTO sport_postures (sport_id, posture) VALUES
(13, 'Basic Kayaking Techniques – Fundamental movements and skills required to perform in kayaking.'),
(13, 'Advanced Strategies – Tactical or technical maneuvers used in competitive kayaking.'),
(13, 'Endurance Training – Exercises and drills to improve performance in kayaking.');

INSERT INTO sport_description (sport_id, description)
VALUES (
  13,
  'Kayaking is a sport that offers both physical and mental challenges. It helps develop coordination, endurance, and discipline while providing an enjoyable way to stay fit.'
);

INSERT INTO sport_benefits (sport_id, benefit) VALUES
(13, 'Improves physical strength and stamina'),
(13, 'Enhances coordination and balance'),
(13, 'Boosts mental focus and discipline'),
(13, 'Provides full-body workout');







-- QUIZ PART
CREATE TABLE user_quiz_results (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  selected_type VARCHAR(50),   -- เช่น "indoor"
  selected_style VARCHAR(50),  -- เช่น "solo"
  sport_id INT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (sport_id) REFERENCES sports(id) ON DELETE CASCADE
);
ALTER TABLE user_quiz_results ADD UNIQUE(user_id, sport_id);

INSERT INTO user_quiz_results (user_id, selected_type, selected_style,sport_id) VALUES 
(1,"Indoor","Solo sports",1),
(1,"Indoor","Solo sports",2);