# แมป #

`Whamm` มีแมปสำหรับเก็บคู่คีย์-ค่า
คล้ายกับชนิด `Map` ของ `java` และ `dict` ของ `python`
อันที่จริงมันคือชนิด `HashMap` ของ `Rust` เป๊ะๆ ... เพราะ `Whamm` ใช้ชนิดของ `Rust` นี้อยู่เบื้องหลัง!

## การสร้างอินสแตนซ์ ##

```
// No need to instantiate a map, it is automatically created as an empty map.
var a: map<i32, i32>;
```

## การอ่านและเขียนสมาชิก ##

การอ่านและเขียนสมาชิกของแมปใช้ไวยากรณ์ `[ ... ]` เหมือนแมปในภาษาอื่นๆ หลายภาษา
```
var a: map<i32, i32>;
a[0] = 3; // map write
var b: i32 = a[0]; // map read

// maps can also contain tuples!
var c: map<(i32, i32, i32), i32>;
c[(0, 0, 0)] = 3; // map write
var b: i32 = c[(0, 0, 0)]; // map read
```

## ขอบเขตและการตรวจ null ##

การเข้าถึงแมปของ `Whamm` ถูกตรวจสอบกับขอบเขตแบบพลวัต

```
var a: map<i32, i32>;
var b: i32 = a[0]; // produces Wasm trap through Rust
```
