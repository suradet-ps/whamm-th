# พจนานุกรมศัพท์ (Glossary) — whamm! ฉบับภาษาไทย

ตารางนี้เป็นคำศัพท์ที่ใช้อย่างสม่ำเสมอตลอดทั้งเล่ม เพื่อให้การแปลทุกบทใช้คำเดียวกัน

| ศัพท์ต้นฉบับ | คำแปลไทย | หมายเหตุ |
|---|---|---|
| instrumentation | การทำอินสตรูเมนเทชัน | การแทรกโค้ดตรวจวัดเข้าไปในโปรแกรม |
| probe | โพรบ | หน่วยของ instrumentation ในภาษา whamm |
| probe rule | กฎโพรบ | รูปแบบ `provider:package:event:mode` |
| predicate | เพรดิเคต | เงื่อนไขที่ต้องเป็นจริงก่อนรัน actions |
| match rule | กฎการแมตช์ | |
| match site | จุดที่แมตช์ | ตำแหน่งในโปรแกรมที่โพรบเข้าไปแทรก |
| bound variable | ตัวแปรที่ผูกไว้ (bound variable) | ตัวแปรที่มาพร้อมกับอีเวนต์ |
| event | อีเวนต์ | |
| provider | พรอไวเดอร์ (provider) | คงศัพท์อังกฤษ |
| package | แพ็กเกจ (package) | |
| mode | โหมด (mode) | |
| injection | การอินเจกต์ (injection) | การนำโค้ดเข้าไปในโปรแกรม |
| injection strategy | กลยุทธ์การอินเจกต์ | |
| bytecode rewriting | การเขียนไบต์โค้ดใหม่ (bytecode rewriting) | |
| bytecode | ไบต์โค้ด | |
| opcode | ออปโค้ด | |
| engine | เอนจิน | |
| monitor | มอนิเตอร์ | |
| manipulate / manipulation | ปรับเปลี่ยน / การปรับเปลี่ยน | |
| dynamic analysis | การวิเคราะห์เชิงพลวัต (dynamic analysis) | |
| static analysis | การวิเคราะห์เชิงสถิต (static analysis) | |
| runtime | รันไทม์ | |
| compile time | คอมไพล์ไทม์ | |
| library | ไลบรารี | |
| script | สคริปต์ | |
| glob | กล็อบ (glob) | รูปแบบไวลด์การ์ดอย่าง `*` |
| parser | ตัวแยกวิเคราะห์ (parser) | |
| AST / Abstract Syntax Tree | AST / ต้นไม้ไวยากรณ์นามธรรม | |
| verifier | ตัวตรวจสอบ (verifier) | |
| symbol table | ตารางสัญลักษณ์ (symbol table) | |
| type checker | ตัวตรวจชนิด (type checker) | |
| emitter | ตัวปล่อยโค้ด (emitter) | |
| generator | ตัวสร้าง (generator) | |
| constant propagation | การแพร่ค่าคงที่ | |
| constant folding | การพับค่าคงที่ | |
| partial evaluation | การประเมินบางส่วน | |
| assertion | แอสเซอร์ชัน | |
| test harness | ฮาร์เนสทดสอบ | |
| interpreter | อินเทอร์พรีเตอร์ | |
| trap | แทรป | |
| frame | เฟรม | |
| tuple | ทูเพิล | |
| map | แมป | |
| string | สตริง | |
| boolean | บูลีน | |
| integer | จำนวนเต็ม | |
| floating point | จุดลอยตัว (floating point) | |
| annotation | แอนโนเทชัน | |
| instantiate | สร้างอินสแตนซ์ | |
| traverse | ท่องไปตาม (traverse) | |
| export / import | ส่งออก / นำเข้า (export / import) | |
| side effect | ผลข้างเคียง | |
| persistent | คงทน | |
| module | โมดูล | |
| glob matching | การจับคู่แบบกล็อบ | |

## หลักการทั่วไป

- ชื่อเครื่องมือ คำสั่ง CLI ตัวเลือก (flag) ชื่อแพ็กเกจ ชื่อชนิดข้อมูล และ URL **ไม่แปล** เช่น `whamm`, `--script`, `i32`, `report`
- คำสงวนของภาษา (keyword) **ไม่แปล** เช่น `report`, `unshared`, `shared`, `frame`, `@init`, `@static`
- โค้ดทุกบล็อก (``` ... ```) เก็บไว้ตามต้นฉบับทุกตัวอักษร รวมถึงคอมเมนต์ภายในโค้ด
- ลิงก์ (ทั้ง inline และ reference-style) คง path เดิม ยกเว้นลิงก์ที่เสียอยู่ในต้นฉบับ ซึ่งมีการแก้ไขและบันทึกไว้ใน README
- ชื่อไฟล์และพาธในเอกสาร **ไม่แปล**
- ศัพท์เทคนิคที่ไม่มีคำแปลไทยใช้ทับศัพท์ตามเสียง เช่น อินสตรูเมนเทชัน, โพรบ, เพรดิเคต
