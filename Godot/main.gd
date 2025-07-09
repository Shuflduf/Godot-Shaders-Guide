extends Node2D

var _update_shader_ref = JavaScriptBridge.create_callback(_update_shader)
var _update_uniforms_ref = JavaScriptBridge.create_callback(_update_uniforms)
var console = JavaScriptBridge.get_interface("console")

func _ready() -> void:
	var window = JavaScriptBridge.get_interface("window")
	window.updateShader = _update_shader_ref
	window.updateUniforms = _update_uniforms_ref
	#console.log(window.updateShader)

func _update_shader(args):
	var event = args[0]
	var uniforms = get_uniforms_from_shader_code(event)
	var shader: ShaderMaterial = $Sprite2D.get_material()
	print("UNIFORMS: ", JSON.stringify(uniforms))
	for u in uniforms:
		if u["value"]:
			shader.set_shader_parameter(u["name"], u["value"])
			
	shader.get_shader().set_code(event)
	
func _update_uniforms(args):
	var event = args[0]
	var data = JSON.parse_string(event)
	var shader: ShaderMaterial = $Sprite2D.get_material()
	for key in data:
		print("setting: ", key, data[key])
		shader.set_shader_parameter(key, data[key])
	
	print("WOOOWWW: ", data)

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
