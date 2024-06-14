shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform vec2 scroll = vec2(0.05, 0.05);
uniform float alpha_control : hint_range(0, 1) = 1.0;

void fragment() {
    vec4 noise_col = texture(noise, UV + scroll * TIME);
    vec4 tex_col = texture(TEXTURE, UV);
	vec4 combined_col = tex_col ;
	float dynamic_alpha_control = sin(TIME) * 0.5 + 0.5;
	if (noise_col.x >= alpha_control)
		combined_col.a = .0;
    
    COLOR = combined_col;
}
