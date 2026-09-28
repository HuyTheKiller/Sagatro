#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define PRECISION highp
#else
    #define PRECISION mediump
#endif

extern PRECISION vec2 enchanted_ui_glint;
extern PRECISION vec4 uie_details;
extern PRECISION number uie_scale;
extern PRECISION number uie_rot;

// Ported from https://godotshaders.com/shader/minecraft-looking-enchantment-glint/
extern PRECISION Image overlay_texture;
extern PRECISION number zoom_factor;
extern PRECISION number move_speed;
extern PRECISION number transparency;

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec2 uv = (screen_coords - uie_details.xy) / uie_details.ga;
    vec4 tex = colour;

    if (uie_scale < 0.00001) {
        uv.x = uv.x + 0.0001;
    }
    if (uie_rot < 0.00001) {
        uv.x = uv.x + 0.0001;
    }

    float t = enchanted_ui_glint.y;

    float offset_x = sin(t * move_speed * 1.3 + sin(2 * t * move_speed * 0.7)) * 0.05;
    float offset_y = cos(2 * t * move_speed * 0.9 + cos(t * move_speed * 0.5)) * 0.05;

    vec2 zoomed_uv = (uv - 0.5) / zoom_factor + 0.5 + vec2(offset_x, offset_y);

    vec4 overlay_tex = Texel(overlay_texture, zoomed_uv);

    float blend = (tex.a > 0.0) ? (transparency * overlay_tex.a) : 0.0;

    tex = mix(tex, overlay_tex, blend);

    return tex;
}