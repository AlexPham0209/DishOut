shader_type canvas_item;
uniform sampler2D gradient : hint_default_black;


void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color.a != 0.0f) {
		float value = dot(color.rgb, vec3(0.299, 0.587, 0.114));
		vec4 sampled = texture(gradient, vec2(value, 0));
		COLOR = sampled;
	}
}

