# สตริง #

`Whamm` มีการรองรับสตริงขั้นพื้นฐานมาก โดยสตริงจะถูกฉีดเข้าไปในโปรแกรม Wasm ที่ทำ instrumentation
และแทนด้วยทูเพิล: `(memory_address, length)` กำหนดได้เฉพาะสตริงสแตติก
เช่น `"i'm a string"` ยังไม่รองรับการสร้างสตริงแบบพลวัต (เช่น `"i " + " am " + " groot"`)
อย่างไรก็ตาม ใช้เป็นทางเลือกสำรองได้โดยดึงสตริงจากไลบรารีของผู้ใช้เพื่อให้ได้ฟังก์ชันนี้

```
var a: str = "";
var b: str = "The quick brown fox";
// var c: string = null; // INVALID -- strings cannot be set to null
```

## การหลบอักขระ (Escapes) ##

สตริงใช้ตัวอักษร `\` เพื่อหลบลำดับบางอย่างได้ เช่น:
- `\n` ขึ้นบรรทัดใหม่
- `\t` แท็บ
- `\"` เครื่องหมายอัญประกาศคู่
- `\'` เครื่องหมายอัญประกาศเดี่ยว
- `\\` แบ็กสแลช
- `\0` ไบต์ null
- `\x(HEX_DIGIT{2})` แทรกเลขฐานสิบหก
- `\u(HEX_DIGIT+)` แทรกยูนิโคด
-


```
// encodes the string literal: "hello drop😀😀A"
report var s: str = "hello drop\u{1F600}😀\x41\n";
```

## ยูทิลิตี้ ##

ยูทิลิตี้ต่อไปนี้มีให้สำหรับการดำเนินการกับสตริง:

```
var s: str = "test";

/// Returns the length of the string.
/// This length is in bytes, not chars or graphemes. In other words, it might not be
/// what a human considers the length of the string.
var l: u32 = s.len();

/// Returns true if the given pattern matches a prefix of this string slice.
/// Returns false if it does not.
var r0: bool = s.starts_with("te");    // `true`
var r1: bool = s.starts_with("st");    // `false`

/// Returns true if the given pattern matches a suffix of this string slice.
/// Returns false if it does not.
var r2: bool = s.ends_with("te");      // `false`
var r3: bool = s.ends_with("st");      // `true`

/// Returns true if the given pattern matches a sub-slice of this string.
/// Returns false if it does not.
var r4: bool = s.contains("te");       // `true`
var r5: bool = s.contains("NA");       // `false`
```

# สตริงและไลบรารี #

สตริงส่งต่อให้ / ดึงจากไลบรารีได้ผ่านการดำเนินการกับหน่วยความจำ เพื่อให้
สิ่งนี้ทำงานในไลบรารีของคุณเอง คุณต้องเปิดเผยฟังก์ชันสำหรับจัดสรร/คืนหน่วยความจำ

เขียนไปยังไลบรารี:
```
use whamm_core;

wasm:opcode:drop:before {
    // initialize the string to pass
    var s: str = "hello world!";
    var l: u32 = s.len();

    // allocate the right number of bytes to store the string
    var ptr: i32 = whamm_core.mem_alloc(l as i32);

    // write the string to the target library's memory
    write_str(memid(whamm_core), ptr, s);

    // call a function in the library that uses the passed string
    // (this just prints the string)
    whamm_core.puts(ptr, l as i32);

    // free the allocated memory
    whamm_core.mem_free(ptr);
}
```

ดึงจากไลบรารี:
```
use alpha;

wasm:opcode:drop:before {
    // allocate some space in memory to store the library's string
    var MAX: i32 = 100;
    var ptr: i32 = alpha.mem_alloc(MAX);

    // write a string to memory, return the length of the string written
    var l: i32 = alpha.write_alphabet(ptr, MAX);

    // read the string from the library's memory
    var s: str  = read_str(memid(alpha), ptr, l as u32);

    // free the memory we've just used
    alpha.mem_free(ptr);
}
```
