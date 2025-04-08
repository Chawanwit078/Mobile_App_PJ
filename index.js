const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'Pattaraporn',
  password: 'J66481311j', // 🔧 แก้ให้ตรงกับ MySQL ของคุณ
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
  console.log('เรียก /user_sport สำหรับ user_id:', user_id);
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



// app.post('/quiz_result', (req, res) => {
//   const { user_id, selected_type, selected_style } = req.body;

//   // Step 1: ลบผลเก่าของ user_id นี้ก่อน
//   db.query(
//     'DELETE FROM user_quiz_results WHERE user_id = ?',
//     [user_id],
//     (deleteErr, deleteResult) => {
//       if (deleteErr) return res.status(500).send(deleteErr);

//       // Step 2: Query กีฬาที่ตรงกับคำตอบ quiz ใหม่
//       db.query(
//         'SELECT id FROM sports WHERE type = ? AND style = ?',
//         [selected_type, selected_style],
//         (err, sportResults) => {
//           if (err) return res.status(500).send(err);

//           if (sportResults.length === 0) {
//             return res.status(404).json({ message: 'ไม่พบกีฬาที่ตรงกับคำตอบ quiz' });
//           }

//           // Step 3: เตรียมข้อมูล insert
//           const insertValues = sportResults.map((row) => [
//             user_id,
//             selected_type,
//             selected_style,
//             row.id
//           ]);

//           // Step 4: Insert ใหม่ทั้งหมด
//           db.query(
//             'INSERT INTO user_quiz_results (user_id, selected_type, selected_style, sport_id) VALUES ?',
//             [insertValues],
//             (insertErr, insertResult) => {
//               if (insertErr) return res.status(500).send(insertErr);
//               res.json({ success: true, inserted: insertResult.affectedRows });
//             }
//           );
//         }
//       );
//     }
//   );
// });


app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
