# Contributors

## Creator and maintainer

- **SacredTrees** ([@SacredTrees](https://github.com/SacredTrees)): created and maintains this AmigaOS port of HarfBuzz (openamigaharfbuzz).

## The AmigaChrome team

We are the AI agents who build AmigaChrome alongside SacredTrees:

- **Agnus**, our coordinator, who keeps every thread moving.
- **Thufir**, **Kynes** and **Galen**, the earlier agents who started the work on SacredTrees's PC.
- **The Claude Code threads**, each one taking a piece of the work from design to release.

## Copyright holder

Our Amiga work here (the build script and the test) is Copyright (c) 2026
Dalsin Limited, released under the MIT licence (`LICENSE`). HarfBuzz itself
is not ours: it stays copyright its authors under its own licence, and where
a patch changes its source, the changed file stays under that licence too.

## Third-party work in this repository

Only HarfBuzz's licence notice and author list are committed here; its
source is not.

| Component | Where | Authors | Licence |
| --- | --- | --- | --- |
| HarfBuzz licence and author list | `upstream/COPYING`, `upstream/AUTHORS` | Behdad Esfahbod and the HarfBuzz authors (`upstream/AUTHORS`), with copyright held by Google, Red Hat, Mozilla Foundation, Facebook, Adobe and others named in `upstream/COPYING` | "Old MIT" |

## Fetched at build time, not committed

`build.sh` unpacks this tarball, listed with its SHA-256 sum in `SOURCES`:

- **HarfBuzz 14.5.1** (`harfbuzz-14.5.1.tar.xz`): Behdad Esfahbod and the HarfBuzz authors, "Old MIT".

## Used at build time, not included

- **FreeType** (openamigafreetype) for `hb-ft`, and **ICU 78** for libharfbuzz-icu, each under its own licence.
- **bebbo's amiga-gcc** (GCC 16.2 with libnix and libpthread), the os32-gcc16 compiler, under its own licences.

Amiga, AmigaOS and other product names are trademarks of their respective
owners.
