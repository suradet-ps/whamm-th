# ตัวแปร #

ตัวแปรใช้เก็บข้อมูล เช่น ตัวเลขและสตริง

```
// Declaring a new variable `<type> <var_name>;`:
var i: i32;
```

```
// Assigning a value to a variable `<var_name> = <value>;`:
i = 0;

// Variables can also be set to the result of an expression `<var_name> = <expression>;`:
i = 1 + 2;
i = add(1, 2) + 9; // (assuming that the `add` fn is in scope and returns an `i32`)
```

## สโคป ##

ตัวแปรแต่ละตัวผูกกับ_สโคป_บางอย่าง ซึ่งคือช่วงของโปรแกรมที่ตัวแปรนั้นทำงานอยู่และเข้าถึงได้
เราจะได้เห็นว่ามีสโคปที่ผูกกับ[ฟังก์ชัน](functions.md), [โพรบ](probes.md) และ[สคริปต์](scripts.md)
ไวยากรณ์สำหรับประกาศและกำหนดค่าตัวแปรสอดคล้องกันในทุกบริบทเหล่านี้
