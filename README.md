# whamm-th

```
██╗    ██╗██╗  ██╗ █████╗ ███╗   ███╗███╗   ███╗   ████████╗██╗  ██╗
██║    ██║██║  ██║██╔══██╗████╗ ████║████╗ ████║   ╚══██╔══╝██║  ██║
██║ █╗ ██║███████║███████║██╔████╔██║██╔████╔██║█████╗██║   ███████║
██║███╗██║██╔══██║██╔══██║██║╚██╔╝██║██║╚██╔╝██║╚════╝██║   ██╔══██║
╚███╔███╔╝██║  ██║██║  ██║██║ ╚═╝ ██║██║ ╚═╝ ██║      ██║   ██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚═╝      ╚═╝   ╚═╝  ╚═╝
```

---

## ◆ PULSE

[![GitHub Pages](https://img.shields.io/badge/Pages-live-2ea44f)](https://suradet-ps.github.io/whamm-th/)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](#-anatomy)

A Wasm program has a first opcode, and a dynamic analysis has a first
probe - whamm-th is the Thai bridge to that moment. This is the complete
Thai translation of the official `whamm!` book: 41 chapters built with
mdbook, terminology locked by a single glossary, and every code block
byte-identical to the original. The links are checked against the built
book (285 anchors), the structure mirrors the upstream repo file-for-file,
and the license travels with the text. Five upstream defects were repaired
along the way - four broken links and one mislabeled heading - each one
recorded in the verifier. Built for the Thai-speaking student of Wasm
instrumentation:
[suradet-ps.github.io/whamm-th](https://suradet-ps.github.io/whamm-th/).

| แปลครบ 41 บท ▣ | Glossary ▣ | ลิงก์ 285/285 ▣ | Build ผ่าน ▣ |
|---|---|---|---|

*v1.0.0 - translation, glossary, verification, and the static build
are all sealed.*

> Built with mdbook 0.5 + Markdown, translated from
> [ejrgilbert/whamm](https://github.com/ejrgilbert/whamm),
> verified by script and rendered as static HTML - a book with the
> probes on the page.
>
> **suradet-ps**, artifact keeper

---

## ◆ IGNITION

One book, three commands.

```
⟫ git clone https://github.com/suradet-ps/whamm-th.git
⟫ cd whamm-th
⟫ cargo install mdbook
⟫ mdbook serve docs --open
```

Open [http://localhost:3000](http://localhost:3000).

```
⟫ mdbook build docs                                  # static HTML into docs/book
⟫ powershell scripts/check-links.ps1                 # all anchors in the built book (pwsh on Linux/macOS)
⟫ powershell scripts/verify-translation.ps1          # byte-exact check vs upstream
```

> On Linux or macOS, run the verification scripts using `pwsh scripts/<script>.ps1`.
> `verify-translation.ps1` checks against `whamm` in adjacent directories or via `-Orig <path>`.

<details>
<summary>Translating a chapter</summary>

A chapter is a file: `docs/src/<chapter>.md`, listed in
`docs/src/SUMMARY.md`. The glossary lives in `GLOSSARY.md` - a term
is chosen once and reused everywhere. Code blocks, commands, links,
and filenames stay verbatim; only prose and headings are translated.
Heading anchors follow mdbook's slug rules (Thai tone marks are
stripped and spaces become dashes), so anchors are read from the built
HTML, never guessed.

</details>

---

## ◆ ANATOMY

One stack, zero custom JS, several quiet helpers.

- **Translates** - the complete book: introduction, getting started,
  17 syntax chapters, events, libraries, injection strategies, 3 example
  monitors, and the developer guide - Thai prose over untouched code.
- **Glossaries** - `GLOSSARY.md` locks the vocabulary (instrumentation =
  การทำอินสตรูเมนเทชัน, probe = โพรบ, predicate = เพรดิเคต), so chapter
  nine agrees with chapter two.
- **Verifies** - `scripts/verify-translation.ps1` diffs every code
  block, heading level, and link target against upstream `whamm` -
  byte-exact or it does not pass, with the link-level upstream fixes
  printed on each run.
- **Checks** - `scripts/check-links.ps1` walks the built book and
  resolves every anchor link against real heading ids - 285 of them,
  all reachable.
- **Builds** - mdbook renders static HTML into `docs/book/`, zero
  server runtime, readable offline and searchable by built-in static
  index.
- **Licenses** - Apache-2.0, inherited from upstream, with the
  LICENSE file shipped beside the text.

---

## ◆ RITUALS

**The core ceremony** - the translation pass:

1. Open a chapter in `docs/src/`. The upstream `whamm` repo sits beside
   it (clone `https://github.com/ejrgilbert/whamm` alongside `whamm-th`)
   - structure is a contract.
2. Translate the prose; keep every code block and command as the
   original wrote it.
3. Consult `GLOSSARY.md` for every term that already has a canon.
   New terms get proposed in the glossary first.
4. Build, verify, check. The book builds clean, the diff is
   byte-exact, and the anchors resolve.

**The ceremony of the anchor** - mdbook slugs strip Thai tone marks
(`ตัวช่วย` becomes `ตัวชวย`). Anchors are read from the built HTML,
written into the source, and re-verified - a guessed anchor is a
broken link waiting to happen.

**The ceremony of the code block** - a translated command that is not
byte-identical to the original is a regression, not a translation.
The verifier is the conscience of the repo.

---

## ◆ ECHOES

**Where this artifact is heading**

```
P1 ▸ SUMMARY + introduction, getting started, language ────────────── ▸ sealed
P2 ▸ all 17 syntax chapters ───────────────────────────────────────── ▸ sealed
P3 ▸ events, libraries, injection strategies, 3 example monitors ──── ▸ sealed
P4 ▸ developer guide, glossary, license, link verification, build ─── ▸ sealed
```

**Raising the artifact** - the honest path lives in `GLOSSARY.md`
(term canon), `scripts/` (the verification gate), and `docs/book.toml`
(book config). New chapters follow the frontmatter-free contract of
the SUMMARY. Open an issue first to discuss a change.

**Status** - on every change: `mdbook build docs` must pass, the
translation verifier must report byte-exact code blocks across all 43
files (41 chapters + `SUMMARY.md` + `404.md`), and the link checker must
report `ALL ANCHOR LINKS OK`.
[Watch the gates](scripts).

---

```
  ─────────────────────────────────────────
   ทุกโปรแกรมมีออปโค้ดแรกของมัน
   ทุกหนังสือมีหน้าแรกของมัน
  ─────────────────────────────────────────
```

Translated from the [whamm](https://github.com/ejrgilbert/whamm)
book, which is licensed under [Apache-2.0](LICENSE-APACHE).
