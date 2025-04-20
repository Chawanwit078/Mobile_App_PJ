# ITDS283_Sec2_Group11 วิธีการ Set Up

- รันใน emulator
1. เปิด mySQL เพื่อทำการรันไฟล์ sport_app
2. สร้าง user รหัสผ่าน เเละ เปลี่ยน limit to hosts Matching ให้เป็น localhost
3. รันคำสั่ง grant all privileges on sport_quiz_app.* to 'UserName'@'localhost';
4. เมื่อ setup mySQL เรียบร้อยให้ไปที่ไฟล์ index.js เปลี่ยน user เเละ password ให้เหมือนกับที่ตั้งไว้ใน mySQL
5. ทำการเปิด emulator เเล้วรันได้เลย

- รันใน device จริง
1. สามารถทำเหมือนขั้นตอน 1-4 ในการรันบน emulator ได้เลย
2. ไปที่ api_service.dart ที่อยู่ภายใต้ folder service
3. ทำการเปลี่ยน baseUrl ให้เป็น ip ของเครื่อง ตัวอย่าง http://your-ipaddress:3000
4. ทำการนำสาย usb ต่อกับคอมพิวเตอร์ เเละโทรศัพท์ **!!!เฉพาะ andriod เท่านั้น!!!**
5. **!!! internet ที่ใช้ในโทรศัพท์จะต้องเป็น internet เดียวกับที่ใช้ในคอมพิมเตอร์ เเละไม่ใช่ internet สาธารณะ !!!!**
6. ทำการเลือก device ใน vscode เเละรันได้เลย
