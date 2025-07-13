class_name VecUniform
extends Object

static func glsl_to_gd(glsl: String) -> Variant:
	var dim: int = int(glsl[3])
	var value_str = glsl.substr(5, glsl.length() - 6)
	var val_strs: Array = Array(value_str.split(", "))
	return arr_to_gd(val_strs.map(func(e: String): float(e)))
	

static func arr_to_gd(arr: Array) -> Variant:
	var vec
	match arr.size():
		2:
			vec = Vector2(arr[0], arr[1])
		3:
			vec = Vector3(arr[0], arr[1], arr[2])
		4:
			vec = Vector4(arr[0], arr[1], arr[2], arr[3])
			
	return vec

static func empty_vec(type: String) -> Variant:
	match type:
		"vec2":
			return Vector2.ZERO
		"vec3":
			return Vector3.ZERO
		"vec4":
			return Vector4.ZERO
	return Vector2.ZERO
