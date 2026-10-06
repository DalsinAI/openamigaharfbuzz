# openamigaharfbuzz

HarfBuzz for AmigaOS 3.x on 68k, built as static link libraries for
GCC programs. Part of the [OpenAmiga](https://github.com/DalsinAI/openamiga)
ports, made for [OpenBrowser](https://github.com/DalsinAI/openamigabrowser),
the WebKit browser for AmigaOS 3.2.

**Status:** Working: builds, and the smoke test shapes text on the bench.

This repository holds the Amiga build, not HarfBuzz itself: a build script,
a smoke test and the upstream licences.

## Upstream

| Library | Version | Licence | Home |
| --- | --- | --- | --- |
| HarfBuzz | 14.5.1 | "Old MIT" (upstream/COPYING) | https://harfbuzz.github.io/ |

The exact files and their SHA-256 sums are in [SOURCES](SOURCES). All credit
for the library goes to its authors; see `upstream/` for their notices.

## What the Amiga port changes

- No source changes. Built as HarfBuzz's single-file `harfbuzz.cc` with FreeType support, plus `hb-icu.cc` as libharfbuzz-icu.

## Building

You need the os32-gcc16 compiler (bebbo's amiga-gcc on GCC 16.2 with libnix
and libpthread; see DalsinAI/openamigabrowser `stove/`) and the upstream
tarballs from [SOURCES](SOURCES) in `tarballs/`. Then:

```
./build.sh
```

The libraries and headers land in `out/` (set `PREFIX` to change that). The
script prints which other settings it needs, if any. Target: 68020 or better
with an FPU (`-m68020 -m68881`), libnix (`-mcrt=nix20`).

Link with: `-lharfbuzz -lfreetype -lpng -lz -lstdc++ -lpthread -lm`

## Tested

`tests/hbtest.c`, run on AmigaOS 3.2.3 on AmigaChrome's AC090 emulation (68040 with FPU, 256 MB), Instance-24, 4 October 2026, as `hbtest DH1:OBFonts/LiberationSans-Regular.ttf`:

```
HARFBUZZ 14.5.1 glyphs=16
50:797 73:267 73:285 76:228 70:512 72:570 3:229 36:607 57:683 58:929 68:570 3:285 73:285 76:228 3:285 171:570
HB_DONE advance=7330
```

Text: "Office AVWa fi é" in Liberation Sans at 16 px (glyph:advance in 1/64 px). The kerning pairs (AV, VW, Wa) show smaller advances than the plain glyphs.

It has not yet been run on real Amiga hardware.

## Known issues

- The shaping result has not yet been compared glyph for glyph with HarfBuzz on another platform.

## Licence

Dalsin Limited's Amiga changes (the build script, patches, configuration
headers and tests) are MIT, Copyright (c) 2026 Dalsin Limited: see
[LICENSE](LICENSE). HarfBuzz keeps its own licence, in
[upstream/](upstream/); a patch to its source stays under that licence.

## Contributors

This port is maintained by [SacredTrees](https://github.com/SacredTrees) with the AmigaChrome agent team, copyright Dalsin Limited. Everyone whose work it includes is credited in [`CONTRIBUTORS.md`](CONTRIBUTORS.md).
