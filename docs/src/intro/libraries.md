# ไลบรารี #

ไลบรารีใช้กำหนดพฤติกรรมของ instrumentation เมื่อมันเกินขอบเขตของไวยากรณ์ DSL หลัก
อันที่จริง `Whamm` เองก็พึ่งพาไลบรารีหลักของ Whamm ชื่อ `whamm_core.wasm` เพื่อรองรับการพิมพ์และแมป

## การบิลด์และใช้งานไลบรารีที่กำหนดเอง ##

วิธีบิลด์ไลบรารีที่กำหนดเอง:
1) ออกแบบ API ให้โต้ตอบได้ด้วยชนิดพื้นฐานของ Wasm (เช่น i32, f32 ฯลฯ)
   โปรดทราบว่า Whamm ยังไม่รองรับไลบรารีที่คืนค่าหลายผลลัพธ์ในปัจจุบัน
2) เขียนไลบรารีด้วยภาษาที่คอมไพล์เป็น Wasm
   ตรวจสอบให้แน่ใจว่าฟังก์ชัน API ถูกส่งออกด้วยชื่อที่เข้ากันได้กับคำสงวนของ DSL `Whamm`
3) คอมไพล์ไลบรารีเป็น Wasm
4) ตรวจดูรายการฟังก์ชันที่ส่งออกของไลบรารีด้วย `wasm-tools`

เมื่อคุณมีไบนารีของไลบรารีแล้ว คุณก็ใช้ไลบรารีในสคริปต์ `Whamm` ได้
โดยนำเข้าไลบรารีเข้าสคริปต์ด้วยคีย์เวิร์ด `use`
จากนั้นจึงเรียกไลบรารีได้ด้วยไวยากรณ์: `lib_name.func_name()`

นี่คือตัวอย่างสคริปต์ที่ใช้ไลบรารี Whamm (และยังหลบข้อจำกัดที่ Whamm ไม่รองรับการคืนค่าหลายผลลัพธ์ ด้วยการแพ็กบิต):

```
// import the library that simulates a cache
use cache;

// instrument all load and store opcodes
wasm:opcode:*load*|*store*:before {
    report unshared var hit: u32;
    report unshared var miss: u32;

    // call the library `check_access` function and pass bound variables as parameters
    var result: i32 = cache.check_access(effective_addr as i32, data_size as i32);
    var num_hits: i32 = (result & 0xFFFF0000) >> 16;
    var num_misses: i32 = (result & 0x0000FFFF);

    hit = hit + (num_hits as u32);
    miss = miss + (num_misses as u32);
}
```

## การใช้ไลบรารีตอน Init Time ##

อาจมีไลบรารีบางตัวที่ต้องเริ่มต้นด้วยสถานะบางอย่างตอนเริ่มการทำงานของโปรแกรม
ซึ่งทำได้โดยเพียงเพิ่มแอนโนเทชัน `@init` ให้กับการเรียกนั้น

หากการเรียกไลบรารีถูกติดแท็กเป็น `@init` ในสโคปภายในโพรบ การเรียกนั้นรับประกันว่าจะถูกทำตอน initialization ของโพรบ (เวลานี้ขึ้นอยู่กับเป้าหมายของแบ็กเอนด์ คือ `wei` หรือ rewriting)
ขณะที่การเรียกไลบรารีในสโคปโกลบอลของสคริปต์รับประกันเสมอว่าจะถูกทำในฟังก์ชัน `start` ของโปรแกรม ผู้ใช้ยังติดแท็ก `@init` ให้มันได้ เพื่อแสดงการรับประกันนี้ในสคริปต์อย่างชัดเจนยิ่งขึ้น

```
use toggle;

// both of the following will run in a program's start function
@init toggle.get_value();
toggle.get_value();

wasm:opcode:*:before {
    // will run at probe initialization time
    // rewriting: in the program's start function
    // wei: in the probe's initialization function callback
    @init toggle.get_value();
}
```

## การใช้ไลบรารีตอน Match Time ##

ไลบรารียังใช้ขยายความสามารถด้าน match-time ของ DSL `Whamm` ได้ด้วย
ซึ่งทำได้โดยเพียงเพิ่มแอนโนเทชัน `@static` ให้กับการเรียกนั้น
หมายเหตุ: การเรียกเหล่านี้_ต้อง_ไม่มีผลข้างเคียงที่จำเป็นต้องคงอยู่ไปถึงการทำงานเชิงพลวัต
ผลข้างเคียงดังกล่าวจะคงอยู่บน `wei` แต่ในการเขียนไบต์โค้ดใหม่ สถานะจะหายไป
เราวางแผนจะรองรับสถานะแบบคงทนสำหรับ rewriting ในอนาคต ดู: [`ideas/@static-serialize.md`]

[`ideas/@static-serialize.md`]: https://github.com/ejrgilbert/whamm/blob/master/ideas/@static-serialize.md

### ทำไมสิ่งนี้ถึงมีประโยชน์? ###

สมมติว่าคุณต้องการทำ instrumentation กับ `i32.load` ที่ผลลัพธ์สุดท้ายถูกใช้โดย `br_table` ตัวใดตัวหนึ่ง
คุณไม่สามารถแสดงเงื่อนไขนั้นด้วยความสามารถของกฎการแมตช์ใน `Whamm` ปัจจุบันได้
อันที่จริง สถานการณ์นี้ต้องใช้ abstract interpretation!
เพื่อผลักความซับซ้อนเช่นนี้ออกไป การตัดสินใจตอน match-time จึงใช้ไลบรารีช่วยหาจุดดังกล่าวได้

ยิ่งไปกว่านั้น ในการเขียนไบต์โค้ดใหม่ ไลบรารีดังกล่าวยังใช้ดึงค่าคงที่และลดโค้ดที่ปล่อยออกมาผ่านการแพร่ค่าคงที่ได้
การแพร่ค่าคงที่นี้ลดทอนสวิตช์ `if`/`else` ได้ด้วยซ้ำ!
ลองพิจารณาสคริปต์ตัวอย่างต่อไปนี้ที่ใช้สำหรับ instrumentation แบบแก๊ส:


```
use gas;
use analysis;

TINIT = 0;
TFILL = 0;
TCOPY = 0;

MINIT = 0;
MFILL = 0;
MCOPY = 0;

// Probes for GAS usage

wasm:opcode:*:before / @static analysis.should_inject(fid, pc) && ! @static analysis.linear_cost_at(fid, pc) == 0 / {
    var constant_cost: i32 = @static analysis.constant_cost_at(fid, pc);

    switch (@static analysis.instr_kind(fid, pc)) {
        case CONST => gas.decr_const(constant_cost);
        default => unreachable();
    }
}
wasm:opcode:*(arg0: i32):before / @static analysis.should_inject(fid, pc) && @static analysis.linear_cost_at(fid, pc) > 0  / {
    var linear_cost: i32 = @static analysis.linear_cost_at(fid, pc);
    var constant_cost: i32 = @static analysis.constant_cost_at(fid, pc);
    switch (@static analysis.instr_kind(fid, pc)) {
        case TINIT => gas.finite_wasm_table_init(arg0, linear_cost, constant_cost);
        case TFILL => gas.finite_wasm_table_fill(arg0, linear_cost, constant_cost);
        case TCOPY => gas.finite_wasm_table_copy(arg0, linear_cost, constant_cost);

        case MINIT => gas.finite_wasm_memory_init(arg0, linear_cost, constant_cost);
        case MFILL => gas.finite_wasm_memory_fill(arg0, linear_cost, constant_cost);
        case MCOPY => gas.finite_wasm_memory_copy(arg0, linear_cost, constant_cost);

        default => unreachable();
    }
}
```

### สิ่งนี้ทำงานอย่างไร? ###

_ในการเขียนไบต์โค้ดใหม่_ เราฝัง `wasmtime` ไว้เพื่อเรียกไลบรารีดังกล่าวขณะที่แบ็กเอนด์ท่องไปตามไบต์โค้ดของแอปพลิเคชันเป้าหมาย
ทุกโมดูลที่ถูกเรียกแบบสแตติกจะถูกสร้างอินสแตนซ์ โดยตัวอินสแตนซ์และสถานะถูกเก็บไว้ใน `WasmRegistry`
รีจิสทรีนี้ถูกนิยามใน [`src/lang_features/libraries/registry.rs`]

[`src/lang_features/libraries/registry.rs`]: https://github.com/ejrgilbert/whamm/blob/master/src/lang_features/libraries/registry.rs

_ใน `wei`_ การเรียกเหล่านี้จะถูกทำตอน match time ของเอนจินตรงๆ
ซึ่งรับประกันว่าสถานะใดก็ตามที่ควรคงอยู่ระหว่าง match time กับรันไทม์จะยังอยู่
นอกจากนี้ยังกำหนดให้การรันโมดูลมอนิเตอร์ `wei` ที่สร้างจากสคริปต์ซึ่งมีการเรียก `@static` ไปยังไลบรารี ต้องถูกเชื่อมโยงตอนรันไทม์
ข้อกำหนดนี้ไม่มีสำหรับการเขียนไบต์โค้ดใหม่ เพราะการเรียก `@static` เหล่านั้นถูกทำไปแล้ว (จึงไม่ต้องนำเข้าไลบรารีนั้นใน Wasm)
