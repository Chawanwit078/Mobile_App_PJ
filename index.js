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
    console.error('❌ Error connecting to MySQL:', err);
    return;
  }
  console.log('✅ Connected to MySQL');
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


app.listen(port, () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
});
