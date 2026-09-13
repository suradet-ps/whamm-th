# ตัวแปร `report` #

คีย์เวิร์ด `report` ระบุตัวแปรที่ค่าของมันควรถูกระบาย (flush)
เมื่อมอนิเตอร์การทำงานของแอปพลิเคชัน ข้อมูลที่บรรยายสิ่งที่สังเกตได้ควรถูกเก็บในตัวแปร `report` เพื่อใช้ประโยชน์จากฟีเจอร์การระบายนี้

การใช้ `report` จริงๆ แล้วเป็นคำย่อของ `report unshared` ดูเอกสาร[ตัวแปร [`unshared`]](./unshared_vars.md)

พฤติกรรมเริ่มต้นของ "การระบาย" นี้คือการพิมพ์ไปยังคอนโซล (ไลบรารี `Whamm` หลักใช้ WASI ทำสิ่งนี้)
การระบายจะทำ_ตอนสิ้นสุดการทำงานของโปรแกรม_ด้วยค่าสุดท้ายของตัวแปร

ตัวอย่าง:
```
report var count;
wasm:opcode:call:before {
    // count the number of times the `call` opcode was used during the application's dynamic execution.
    // (a single global count)
    count++;
}
```
