# ตัวดำเนินการเชิงตรรกะ #

ตัวดำเนินการเชิงตรรกะ (logical operators) ใช้เชื่อมนิพจน์บูลีนหลายนิพจน์เข้าด้วยกัน
เช่นเดียวกับ C/C++ และ Java ตัวดำเนินการ `&&` และ `||` ให้การดำเนินการ AND เชิงตรรกะและ OR เชิงตรรกะตามลำดับ
ตัวดำเนินการทั้งสองมี*การประเมินแบบลัดวงจร (short-circuit evaluation)* นั่นคือ จะประเมินนิพจน์ทางขวามือก็ต่อเมื่อทางซ้ายมือประเมินเป็น `true` หรือ `false` ตามลำดับเท่านั้น

```
var a: bool;
a = false && false; // == false
a = false && true;  // == false
a = true && false;  // == false
a = true && true;   // == true
```

```
var a: bool;
a = false || false; // == false
a = false || true;  // == true
a = true || false;  // == true
a = true || true;   // == true
```
