# ตัวดำเนินการเชิงตรรกะ #

ตัวดำเนินการเชิงตรรกะใช้เชื่อมนิพจน์บูลีนหลายนิพจน์เข้าด้วยกัน
เช่นเดียวกับ C/C++ และ Java ตัวดำเนินการ `&&` และ `||` ให้การดำเนินการ AND เชิงตรรกะและ OR เชิงตรรกะ
ตัวดำเนินการทั้งสองมี_การประเมินแบบลัดวงจร (short-circuit evaluation)_; จะประเมินนิพจน์ทางขวาก็ต่อเมื่อทางซ้ายประเมินเป็น `true` หรือ `false` ตามลำดับ

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
