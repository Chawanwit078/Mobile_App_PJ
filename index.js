const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'New2',
  password: '1234', // 🔧 แก้ให้ตรงกับ MySQL ของคุณ
  database: 'sport_quiz_app' // 🔧 ต้องสร้าง DB ชื่อนี้ก่อนใน MySQL
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL');
});

// 🟡 Login API
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  db.query(
    'SELECT * FROM users WHERE username = ? AND password = ?',
    [username, password],
    (err, results) => {
      if (err) return res.status(500).send(err);
      if (results.length > 0) {
        res.json({ success: true, user_id: results[0].id });
      } else {
        res.status(401).json({ success: false, message: 'Invalid credentials' });
      }
    }
  );
});

// GET กีฬาที่แนะนำตาม user_id
app.post('/user_sport', (req, res) => {
  const { user_id } = req.body;
  // ดึงจาก user_quiz_results
  db.query(
    'SELECT s.* FROM sports s ' +
    'JOIN user_quiz_results q ON s.id = q.sport_id ' +
    'WHERE q.user_id = ?',
    [user_id],
    (err, results) => {
      if (err) return res.status(500).send(err);

      if (results.length > 0) {
        // ถ้ามีการทำ Quiz -> return กีฬาที่แมปมาแล้ว
        res.json(results);
      } else {
        // ถ้ายังไม่เคยทำ Quiz -> return กีฬาทั้งหมด
        db.query('SELECT * FROM sports', (err2, allSports) => {
          if (err2) return res.status(500).send(err2);
          res.json(allSports);
        });
      }
    }
  );
});


// ดึงรายละเอียดทั้งหมดของกีฬา ID ที่กำหนด
app.get('/sport_detail/:id', (req, res) => {
  const sportId = req.params.id;

  // ดึง description
  const descriptionQuery = 'SELECT description FROM sport_description WHERE sport_id = ?';
  // ดึง postures
  const posturesQuery = 'SELECT posture FROM sport_postures WHERE sport_id = ?';
  // ดึง benefits
  const benefitsQuery = 'SELECT benefit FROM sport_benefits WHERE sport_id = ?';

  db.query(descriptionQuery, [sportId], (err, descResult) => {
    if (err) return res.status(500).send(err);

    db.query(posturesQuery, [sportId], (err2, postureResult) => {
      if (err2) return res.status(500).send(err2);

      db.query(benefitsQuery, [sportId], (err3, benefitResult) => {
        if (err3) return res.status(500).send(err3);

        res.json({
          description: descResult[0]?.description ?? '',
          postures: postureResult.map(p => p.posture),
          benefits: benefitResult.map(b => b.benefit)
        });
      });
    });
  });
});

// ✅ Sign Up API
app.post('/signup', (req, res) => {
  const {
    firstName,
    lastName,
    username,
    password,
    dob,
    gender,
    weight,
    height,
  } = req.body;

  // 🔍 ตรวจ username ซ้ำก่อน
  db.query('SELECT * FROM users WHERE username = ?', [username], (err, results) => {
    if (err) return res.status(500).json({ success: false, message: 'DB error' });
    if (results.length > 0) {
      return res.status(409).json({ success: false, message: 'Username already exists' });
    }

    // ✅ ถ้าไม่ซ้ำ -> insert ได้เลย
    const sql = `
      INSERT INTO users (first_name, last_name, username, password, dob, gender, weight, height)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;

    db.query(
      sql,
      [firstName, lastName, username, password, dob, gender, weight, height],
      (err2, result) => {
        if (err2) {
          console.error('Signup Error:', err2);
          return res.status(500).json({ success: false, message: 'Signup failed' });
        }
        res.json({ success: true, userId: result.insertId });
      }
    );
  });
});

app.get('/user_detail/:id', (req, res) => {
  const user_id = req.params.id;

  const userQuery = 'SELECT * FROM users WHERE id = ?';

  db.query(userQuery, [user_id], (err, result) => {
    if (err) return res.status(500).send(err);

    if (result.length > 0) {
      res.json(result[0]);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  });
});


app.post('/save_quiz', (req, res) => {
  console.log("อยู่ใน /save_quiz")


  const { user_id, selected_type, selected_style } = req.body;
  console.log("👉 type:", selected_type);
  console.log("👉 style:", selected_style);


  const sportQuery = 'SELECT id FROM sports WHERE type = ? AND style = ?';
  db.query(sportQuery, [selected_style, selected_type], (err, results) => {
    if (err) {
      console.error("❌ Search Error: ", err);
      return res.status(500).send(err);
    }

    const insertValues = results.map(r => [user_id, selected_type, selected_style, r.id]);
    console.log("📤 insertValues:", insertValues);
    console.log("📥 type:", typeof insertValues);
    if (insertValues.length === 0) return res.status(404).send('No sports matched');

    const insertQuery = `
      INSERT INTO user_quiz_results (user_id, selected_type, selected_style, sport_id)
      VALUES ?
      ON DUPLICATE KEY UPDATE
        selected_type = VALUES(selected_type),
        selected_style = VALUES(selected_style),
        sport_id = VALUES(sport_id)
    `;

    db.query(insertQuery, [insertValues], (err2) => {
      if (err2) {
        console.error("❌ Insert Error: ", err2);
        return res.status(500).send(err2);
      }
      res.send('Quiz answers saved');
    });    
  });
});




app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
