#!/bin/sh
# openamigaharfbuzz: HarfBuzz, built for AmigaOS 3.x (68020 + FPU) with the
# os32-gcc16 compiler (bebbo's amiga-gcc, GCC 16.2, libnix, libpthread).
# MIT, Copyright (c) 2026 Dalsin Limited. The library keeps its own licence.
#
#   OS32_GCC16   compiler root holding prefix/ and compat/
#                (default ~/AmigaChrome/stoves/os32-gcc16)
#   PREFIX       where include/ and lib/ go (default ./out)
#   TARBALLS     folder holding the upstream tarballs listed in SOURCES
#                (default ./tarballs); the script checks their SHA-256
#   JOBS         parallel jobs for CMake/make builds (default 2)
#
# usage: ./build.sh
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
S=${OS32_GCC16:-"$HOME/AmigaChrome/stoves/os32-gcc16"}
P=$S/prefix
OUT=${PREFIX:-"$HERE/out"}
TARBALLS=${TARBALLS:-"$HERE/tarballs"}
JOBS=${JOBS:-2}
WORK="$HERE/work"
CC="$P/bin/m68k-amigaos-gcc"
CXX="$P/bin/m68k-amigaos-g++"
AR="$P/bin/m68k-amigaos-ar"
CPU=${OS32_CPU_FLAGS:-"-m68020 -m68881 -mcrt=nix20"}
CFLAGS="-O2 $CPU -fno-delete-null-pointer-checks -D_DEFAULT_SOURCE=1 -D_POSIX_TIMERS=1 -D_POSIX_REALTIME_SIGNALS=1 -fno-common"
mkdir -p "$OUT/include" "$OUT/lib" "$WORK"

# unpack NAME TARBALL SHA256: check the tarball and unpack it into $WORK
unpack() {
    t="$TARBALLS/$2"
    [ -f "$t" ] || { echo "missing $t (see SOURCES)"; exit 2; }
    echo "$3  $t" | sha256sum -c - >/dev/null || { echo "SHA-256 mismatch: $t"; exit 2; }
    rm -rf "$WORK/$1"; mkdir -p "$WORK/$1"
    case "$2" in
        *.zip) (cd "$WORK/$1" && unzip -q "$t") ;;
        *) tar xf "$t" -C "$WORK/$1" ;;
    esac
}

# archive NAME FILE...: compile into $OUT/lib/libNAME.a ($XFLAGS added)
archive() {
    name=$1; shift
    obj="$WORK/obj-$name"
    rm -rf "$obj"; mkdir -p "$obj"
    for f in "$@"; do
        o="$obj/$(echo "$f" | tr '/' '_' | sed 's/\.[a-z]*$//').o"
        case "$f" in
            *.cc|*.cpp) $CXX $CFLAGS ${XFLAGS:-} -c "$f" -o "$o" ;;
            *) $CC $CFLAGS ${XFLAGS:-} -c "$f" -o "$o" ;;
        esac
    done
    rm -f "$OUT/lib/lib$name.a"
    $AR rcs "$OUT/lib/lib$name.a" "$obj"/*.o
    echo "lib$name.a: $(wc -c < "$OUT/lib/lib$name.a") bytes"
}

FT=${FREETYPE_INCLUDE:?set FREETYPE_INCLUDE to the include/freetype2 folder of openamigafreetype}
ICU=${ICU_PREFIX:?set ICU_PREFIX to an ICU 78 build for AmigaOS 3}
unpack harfbuzz harfbuzz-14.5.1.tar.xz 7e2fa4e8c7c98e8d8140671f5772542afaaa6acccfbd746506886b6d85f7f8d6
cd "$WORK/harfbuzz/harfbuzz-14.5.1"
# The single-file build with FreeType support (hb-ft); hb-icu on its own.
XFLAGS="-Isrc -I$FT -DHAVE_FREETYPE=1 -DHAVE_FT_GET_VAR_BLEND_COORDINATES=1 -DHAVE_FT_SET_VAR_BLEND_COORDINATES=1 \
    -DHAVE_FT_DONE_MM_VAR=1 -DHAVE_FT_GET_TRANSFORM=1 -DHAVE_PTHREAD=1 -std=c++17 -fno-exceptions -fno-rtti \
    -fno-threadsafe-statics" archive harfbuzz src/harfbuzz.cc
XFLAGS="-Isrc -I$ICU/include -DHAVE_ICU=1 -std=c++17 -fno-exceptions -fno-rtti" archive harfbuzz-icu src/hb-icu.cc
mkdir -p "$OUT/include/harfbuzz"
for h in hb-aat-layout.h hb-aat.h hb-blob.h hb-buffer.h hb-common.h hb-deprecated.h hb-draw.h hb-paint.h \
    hb-face.h hb-font.h hb-map.h hb-ot-color.h hb-ot-deprecated.h hb-ot-fetch.h hb-ot-font.h hb-ot-layout.h \
    hb-ot-math.h hb-ot-meta.h hb-ot-metrics.h hb-ot-name.h hb-ot-shape.h hb-ot-var.h hb-ot.h hb-script-list.h \
    hb-set.h hb-shape-plan.h hb-shape.h hb-style.h hb-unicode.h hb.h hb-version.h hb-ft.h hb-icu.h; do
    cp "src/$h" "$OUT/include/harfbuzz/"
done
