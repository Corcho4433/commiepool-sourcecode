shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform vec2 scroll = vec2(0.05, 0.05);
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform float alpha_control : hint_range(0, 1) = 1.0;

void fragment() {
    vec4 noise_col = texture(noise, UV + scroll * TIME);
    vec4 tex_col = texture(SCREEN_TEXTURE, UV);

	if (noise_col.x >= alpha_control)
		tex_col.rgb = vec3(0.0); // Set color to black
		tex_col.a = 1.0;
    
    COLOR = tex_col;
}
