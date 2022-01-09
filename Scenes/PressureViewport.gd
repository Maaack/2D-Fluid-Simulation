extends Viewport

export(int) var levels : int = 1 setget set_levels
export(Material) var shader_material : Material

var allow_edits : bool = false
var nested_viewport_scene : PackedScene = preload("res://Scenes/NestedViewportContainer.tscn")
var nested_viewport_instance : ViewportContainer

func _add_level():
	if is_instance_valid(nested_viewport_instance):
		return nested_viewport_instance
	nested_viewport_instance = nested_viewport_scene.instance()
	add_child(nested_viewport_instance)
	nested_viewport_instance.set_viewport_size(size)
	nested_viewport_instance.material = shader_material
	return nested_viewport_instance

func _reset_levels():
	if not allow_edits:
		return
	if levels < 1:
		return
	var instance = _add_level()
	var sprite_node = instance.add_levels(levels - 1)
	sprite_node.centered = false
	return sprite_node
	
func set_levels(value : int) -> void:
	levels = value
	_reset_levels()

func _ready():
	allow_edits = true
	_reset_levels()

func set_shader_param(key : String, value) -> void:
	if not is_instance_valid(nested_viewport_instance):
		return
	nested_viewport_instance.set_shader_param(key, value)
