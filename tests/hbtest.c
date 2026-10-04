/* openamigaharfbuzz smoke test: shape text with a TrueType font, print glyphs. */
#include <stdio.h>
#include <hb.h>
#include <hb-ft.h>
#include <ft2build.h>
#include FT_FREETYPE_H
/* ROM mathieeesingbas.library leaves the FPU in single precision (FPCR $40)
 * in every task that opens it; doubles need FPCR 0. */
static void resetFPCR(void) { __asm__ volatile ("fmove.l %0,%%fpcr" : : "d" (0)); }

int main(int argc, char **argv)
{
    resetFPCR();
    FT_Library ft; FT_Face face; hb_font_t *font; hb_buffer_t *buf;
    const char *text = argc > 2 ? argv[2] : "Office AVWa fi \xc3\xa9";
    unsigned n, i; hb_glyph_info_t *info; hb_glyph_position_t *pos; long total = 0;
    if (argc < 2 || FT_Init_FreeType(&ft) || FT_New_Face(ft, argv[1], 0, &face)) { printf("FT_FAIL\n"); return 20; }
    FT_Set_Char_Size(face, 0, 16 * 64, 72, 72);
    font = hb_ft_font_create_referenced(face);
    buf = hb_buffer_create();
    hb_buffer_add_utf8(buf, text, -1, 0, -1);
    hb_buffer_guess_segment_properties(buf);
    hb_shape(font, buf, NULL, 0);
    info = hb_buffer_get_glyph_infos(buf, &n);
    pos = hb_buffer_get_glyph_positions(buf, &n);
    printf("HARFBUZZ %s glyphs=%u\n", hb_version_string(), n);
    for (i = 0; i < n; i++) {
        printf("%u:%d%s", info[i].codepoint, pos[i].x_advance, i + 1 < n ? " " : "\n");
        total += pos[i].x_advance;
    }
    printf("HB_DONE advance=%ld\n", total);
    hb_buffer_destroy(buf); hb_font_destroy(font);
    return 0;
}
