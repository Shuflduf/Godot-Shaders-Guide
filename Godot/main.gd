extends Node2D

var _callback_ref = JavaScriptBridge.create_callback(_update_shader)
var console = JavaScriptBridge.get_interface("console")

func _ready() -> void:
	var window = JavaScriptBridge.get_interface("window")
	window.updateShader = _callback_ref
	console.log(window.updateShader)

func _update_shader(args):
	
	var event = args[0]
	print("UNIFORMS: ", JSON.stringify(get_uniforms_from_shader_code(event)))
	$Sprite2D.get_material().get_shader().set_code(event)

static func get_uniforms_from_shader_code(shader_code: String) -> Array:
	var uniforms = []
	var regex = RegEx.new()
	
	regex.compile(r"uniform\s+(\w+)\s+(\w+)(?:\s*=\s*([^;]+))?\s*;")
	
	var results = regex.search_all(shader_code)
	
	for result in results:
		var uniform_data = {
			"type": result.get_string(1),
			"name": result.get_string(2)
		}
		
		# Add value field if a default value exists
		if result.get_string(3) != "":
			uniform_data["value"] = result.get_string(3).strip_edges()
		
		uniforms.append(uniform_data)
	
	return uniforms
