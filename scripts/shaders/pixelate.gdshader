shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_size : hint_range(1.0, 64.0, 1.0) = 1.0;
uniform int num_colors : hint_range(2, 256) = 16; // New parameter for number of colors

// 4x4 Bayer matrix
const mat4 bayer_matrix = mat4(
    vec4(0.0 / 16.0,  8.0 / 16.0,  2.0 / 16.0, 10.0 / 16.0),
    vec4(12.0 / 16.0, 4.0 / 16.0, 14.0 / 16.0,  6.0 / 16.0),
    vec4(3.0 / 16.0, 11.0 / 16.0,  1.0 / 16.0,  9.0 / 16.0),
    vec4(15.0 / 16.0, 7.0 / 16.0, 13.0 / 16.0,  5.0 / 16.0)
);

void fragment() {
    float x = FRAGCOORD.x - mod(FRAGCOORD.x, pixel_size);
    float y = FRAGCOORD.y - mod(FRAGCOORD.y, pixel_size);
    vec2 tex_coords = vec2(x, y) * SCREEN_PIXEL_SIZE;
    
    vec4 color = texture(SCREEN_TEXTURE, tex_coords);

    // Apply Bayer matrix dithering
    int bx = int(mod(FRAGCOORD.x, 4.0));
    int by = int(mod(FRAGCOORD.y, 4.0));
    float threshold = bayer_matrix[by][bx];
    
    // Quantize the color based on num_colors
    float levels = float(num_colors - 1);
    vec3 quantized_color = floor(color.rgb * levels + threshold) / levels;

    COLOR = vec4(quantized_color, color.a);
}
