# ตัวแปร `unshared` #

หากตัวแปรถูกทำเครื่องหมายเป็น `unshared` อินสแตนซ์ของตัวแปรนี้จะถูกสร้างให้_ทุกจุดที่แมตช์_ของโพรบ
สโคปของตัวแปรนี้จำกัดอยู่ที่_จุดที่แมตช์_นั้นๆ
ค่าของตัวแปรนี้จะคงที่ในทุกครั้งที่เข้าไปในตรรกะของโพรบ นั่นหมายความว่ามันจะไม่ถูกเริ่มต้นใหม่ทุกครั้ง

คุณจึงใช้ตัวแปรนี้เก็บข้อมูล ณ จุดหนึ่งของโปรแกรม_เมื่อเวลาผ่านไป_ได้

ตัวอย่าง:
```
wasm:opcode:call:before {
    // collect the number of times each `call` opcode is executed during dynamic execution.
    // (as many counts as there are `call` opcodes in the program)
    // This variable will not be reinitialized each time this probe's body is executed,
    // rather, it will be the value it was the last time it ran!
    unshared var count: i32;
    count++;
    
    // This variable will be reinitialized to 0 each time this probe's body is executed
    var local_variable: i32;
    local_variable++;
}
```
