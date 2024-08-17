shader_type canvas_item;
uniform vec4 color;
uniform float a;

void fragment() {
	COLOR = COLOR.a >= 0.05 ? (1.0 - a) * COLOR + a * color : COLOR;
}