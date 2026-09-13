# ตัวแปร `shared` #

หมายเหตุ: ฟังก์ชันนี้ยังพัฒนาไม่เสร็จสมบูรณ์! จะมีเอกสารเพิ่มเติมตามมาหลังการพัฒนา!

หากตัวแปรถูกทำเครื่องหมายเป็น `shared` อินสแตนซ์เดียวของตัวแปรนี้จะถูกใช้ร่วมกันโดย*ทุกจุดที่แมตช์*ของโพรบ
สโคปของตัวแปรนี้จำกัดอยู่ที่*ทุกจุดที่แมตช์*ของโพรบ
ค่าของตัวแปรนี้จะคงที่ในทุกครั้งที่เข้าไปในตรรกะของโพรบ นั่นหมายความว่ามันจะไม่ถูกเริ่มต้นใหม่ทุกครั้ง

คุณจึงใช้ตัวแปรนี้เก็บข้อมูลสำหรับอีเวนต์ที่โพรบ*เมื่อเวลาผ่านไป*ได้

ตัวอย่าง:
```
wasm:opcode:call:before {
    // collect the number of times the `call` opcode is executed during dynamic execution.
    // (a single count tied to the wasm:opcode:call event in the program)
    // This variable will not be reinitialized each time this probe's body is executed,
    // rather, it will be the value it was the last time it ran!
    shared var count: i32;
    count++;
    
    // This variable will be reinitialized to 0 each time this probe's body is executed
    var local_variable: i32;
    local_variable++;
}
```
