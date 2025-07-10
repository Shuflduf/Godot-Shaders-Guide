shader_type canvas_item;

uniform sampler2D new_tex;
uniform vec4 testing = vec4(69, 69, 69, 69);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
