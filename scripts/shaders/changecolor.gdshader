shader_type canvas_item;

uniform vec4 border_color = vec4(1.0, 0.0, 0.0, 1.0);  // Border color
uniform vec2 border_threshold = vec2(0.01, 0.01);      // Threshold for border detection
uniform float border_size = 5.0;                       // Size of the border in pixels
uniform float blend_factor : hint_range(0.0, 1.0) = 0.5; // Blending between border and texture

// Function to check if the current pixel is on the border
bool is_on_border(sampler2D texture, vec2 uv) {
    // Loop to check several pixels around the current one (in a radius defined by border_size)
    for (float x = -border_size; x <= border_size; x++) {
        for (float y = -border_size; y <= border_size; y++) {
            vec2 offset = vec2(x, y) * border_threshold; // Multiply by threshold for proper scaling
            vec4 neighbor_color = texture(texture, uv + offset);
            
            // Check if there's a transition between solid and transparent pixels
            if ((neighbor_color.a < 1.0 && texture(texture, uv).a == 1.0) || 
                (neighbor_color.a == 1.0 && texture(texture, uv).a < 1.0)) {
                return true; // If transition is found, it's part of the border
            }
        }
    }
    return false; // If no border transition is found, return false
}

void fragment() {
    vec4 pixelColor = texture(TEXTURE, UV);

    // Check if the pixel is on the border
    if (is_on_border(TEXTURE, UV)) {
        // Blend the border color with the texture color
        COLOR = border_color;
    } else {
        // Use the original pixel color if not on the border
        COLOR = pixelColor;
    }
}
