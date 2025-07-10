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
	var code = args[0]
	var uniforms = get_uniforms_from_shader_code(code)
	var shader: ShaderMaterial = $Sprite2D.get_material()
	print("UNIFORMS: ", JSON.stringify(uniforms))
	for u: Dictionary in uniforms:
		if u.has("value"):
			shader.set_shader_parameter(u["name"], u["value"])
			
	shader.get_shader().set_code(code)
	
func _update_uniforms(args):
	var event = args[0]
	var update_data = JSON.parse_string(event)
	print("WOOOWWW: ", update_data)
	
	var shader: ShaderMaterial = $Sprite2D.get_material()
	if update_data["type"] in ["float", "int"]:
		print("WERE SO BACK")
		shader.set_shader_parameter(update_data["uniformName"], update_data["data"])
		
	if update_data["type"] == "sampler2D":
		var bytes = PackedByteArray(update_data["data"]["bytes"])
		var img = Image.new()
		var err = img.load_png_from_buffer(bytes)
		var img_tex = ImageTexture.create_from_image(img)
		shader.set_shader_parameter(update_data["uniformName"], img_tex)
		
		var test: ImageTexture = shader.get_shader_parameter(update_data["uniformName"])


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
		
		if result.get_string(3) != "":
			uniform_data["value"] = result.get_string(3).strip_edges()
		
		uniforms.append(uniform_data)
	
	return uniforms
