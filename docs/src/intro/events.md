# อีเวนต์ที่ทำ instrumentation ได้ #

`packages` ที่มีให้ใช้ในปัจจุบัน:
- `wasm:opcode`: สำหรับทำ instrumentation กับออปโค้ดของ Wasm
- `wasm:func`: สำหรับทำ instrumentation กับฟังก์ชันของ Wasm
  - ปัจจุบันรองรับ `entry` และ `exit`
  - อนาคต: `unwind`
- `wasm:block`: สำหรับทำ instrumentation กับ basic block ของ Wasm

`Packages` ที่จะเพิ่มในอนาคต:
- อีเวนต์การทำงานของ `thread`
- อีเวนต์การทำงานของ `gc`
- อีเวนต์การเข้าถึง `memory` (อ่าน/เขียน)
- อีเวนต์การเข้าถึง `table` (อ่าน/เขียน)
- อีเวนต์การทำงานของ `component` ใน WASI เช่น `wasi:http:send_req:alt`
- อีเวนต์ `wasm:begin`/`wasm:end`
- `traps`
- อีเวนต์ throw/rethrow/catch ของ `exception`
