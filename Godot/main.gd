extends Node2D

var _callback_ref = JavaScriptBridge.create_callback(_update_shader)
var console = JavaScriptBridge.get_interface("console")

func _ready() -> void:
	var window = JavaScriptBridge.get_interface("window")
	window.updateShader = _callback_ref
	console.log(window.updateShader)

func _update_shader(args):
	var event = args[0]
	event.preventDefault()
	event.returnValue = "BBBBBBBBBB"
	console.log("GD", args)
