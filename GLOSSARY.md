# พจนานุกรมศัพท์ (Glossary) — whamm! ฉบับภาษาไทย

ตารางนี้เป็นคำศัพท์ที่ใช้อย่างสม่ำเสมอตลอดทั้งเล่ม เพื่อให้การแปลทุกบทใช้คำเดียวกัน

| ศัพท์ต้นฉบับ | คำแปลไทย | หมายเหตุ |
|---|---|---|
| annotation | แอนโนเทชัน | เช่น `@init`, `@static` |
| application | แอปพลิเคชัน | |
| assertion | แอสเซอร์ชัน | ข้อความยืนยันผลในไฟล์ `.wast` |
| AST (Abstract Syntax Tree) | ต้นไม้ไวยากรณ์นามธรรม (AST) | |
| bound variable | ตัวแปรที่ผูกไว้ (bound variable) | ตัวแปรที่อีเวนต์มอบให้ในสโคปของโพรบ |
| bytecode | ไบต์โค้ด | |
| bytecode rewriting | การเขียนไบต์โค้ดใหม่ (bytecode rewriting) | |
| callback | คอลแบ็ก | |
| compilation | การคอมไพล์ | |
| compiler | คอมไพเลอร์ | |
| compile | คอมไพล์ | |
| constant folding | การพับค่าคงที่ | |
| constant propagation | การแพร่ค่าคงที่ | |
| crate | เครต | |
| dynamic analysis | การวิเคราะห์เชิงพลวัต (dynamic analysis) | |
| emitter | ตัวปล่อยโค้ด (emitter) | |
| engine | เอนจิน | |
| event | อีเวนต์ | |
| export / import | ส่งออก / นำเข้า (export / import) | |
| frame | เฟรม | |
| frame variable | ตัวแปร `frame` | คีย์เวิร์ด `frame` คงชื่อเดิม |
| function | ฟังก์ชัน | |
| generator | ตัวสร้าง (generator) | |
| glob | กล็อบ (glob) | รูปแบบไวลด์การ์ดอย่าง `*` |
| glob matching | การจับคู่แบบกล็อบ | |
| injection | การอินเจกต์ (injection) | การนำโค้ดเข้าไปในโปรแกรม |
| injection strategy | กลยุทธ์การอินเจกต์ | |
| instrumentation | การทำอินสตรูเมนเทชัน (instrumentation) | การแทรกโค้ดตรวจวัดเข้าไปในโปรแกรม |
| interpreter | อินเทอร์พรีเตอร์ | |
| library | ไลบรารี | |
| manipulate / manipulation | ปรับเปลี่ยน / การปรับเปลี่ยน | |
| map | แมป | |
| match rule | กฎการแมตช์ | รูปแบบ `provider:package:event:mode` |
| match site | จุดที่แมตช์ | ตำแหน่งในโปรแกรมที่โพรบเข้าไปแทรก |
| mode | โหมด | |
| module | โมดูล | |
| monitor | มอนิเตอร์ | |
| opcode | ออปโคด | |
| package | แพ็กเกจ | |
| parser | ตัวแยกวิเคราะห์ (parser) | |
| partial evaluation | การประเมินบางส่วน | |
| predicate | เพรดิเคต | เงื่อนไขที่ต้องเป็นจริงก่อนรัน actions |
| probe | โพรบ | หน่วยของ instrumentation ในภาษา whamm |
| probe rule | กฎโพรบ | รูปแบบ `provider:package:event:mode` |
| provider | พรอไวเดอร์ (provider) | |
| report variable | ตัวแปร `report` | คีย์เวิร์ด `report` คงชื่อเดิม |
| runtime | รันไทม์ | |
| scope | สโคป | |
| script | สคริปต์ | ไฟล์นามสกุล `.mm` |
| shared variable | ตัวแปร `shared` | คีย์เวิร์ด `shared` คงชื่อเดิม |
| side effect | ผลข้างเคียง | |
| static analysis | การวิเคราะห์เชิงสถิต (static analysis) | |
| string | สตริง | |
| symbol table | ตารางสัญลักษณ์ (symbol table) | |
| test harness | ฮาร์เนสทดสอบ | |
| trap | แทรป | |
| tuple | ทูเพิล | |
| type bound | ขอบเขตชนิด (type bound) | |
| type checker | ตัวตรวจชนิด (type checker) | |
| unshared variable | ตัวแปร `unshared` | คีย์เวิร์ด `unshared` คงชื่อเดิม |
| variable | ตัวแปร | |
| verifier | ตัวตรวจสอบ (verifier) | |
| Wasm / WebAssembly | Wasm / WebAssembly (คงชื่อเดิม) | |
| `wei` | `wei` (คงชื่อเดิม) | Whamm Engine Interface |

## หลักการทั่วไป

- ชื่อเครื่องมือ คำสั่ง CLI ชื่อแพ็กเกจ ชื่อ struct/ฟังก์ชัน/ตัวแปร และ URL **ไม่แปล** เช่น `whamm`, `--defs-path`, `--wei`, `@static`, `i32`, `WasmRegistry`, `whamm_core.wasm`
- โค้ดทุกบล็อก (``` ... ```) เก็บไว้ตามต้นฉบับทุกตัวอักษร รวมถึงคอมเมนต์ภายในโค้ด
- ลิงก์ (ทั้ง inline และ reference-style) คง path เดิม ยกเว้นลิงก์ที่เสียอยู่ในต้นฉบับ ซึ่งมีการแก้ไขและบันทึกไว้ใน `scripts/verify-translation.ps1` และ README
- ชื่อตัวเลือก/แฟล็ก CLI และคำสงวนของภาษา อ้างถึงด้วยชื่อเดิมเสมอ เช่น `--script`, `report`, `unshared`, `frame`
- หัวข้อเป็นภาษาไทย แต่ระดับของหัวข้อต้องเท่าเดิม และแองเคอร์ภายในหน้าต้องเป็นไปตามกฎ slug ของ mdbook (เครื่องหมายวรรณยุกต์ถูกตัดทิ้ง เช่น `#ตัวช่วย info ใน CLI` → `#ตัวชวย-info-ใน-cli`) แองเคอร์อ่านจาก HTML ที่ build แล้ว ไม่เดา
- คำศัพท์เทคนิคที่กลายเป็นศัพท์ไทยที่ใช้กันแพร่หลายแล้ว ใช้คำไทยได้เลย เช่น โพรบ, เพรดิเคต, ไบต์โค้ด, ออปโคด, เอนจิน, มอนิเตอร์
- เมื่อศัพท์เทคนิคปรากฏครั้งแรกในบท ให้เอ่ยคำอังกฤษในวงเล็บกำกับไว้ด้วย เช่น "การเขียนไบต์โค้ดใหม่ (bytecode rewriting)" จากนั้นใช้คำไทยเพียงอย่างเดียว
