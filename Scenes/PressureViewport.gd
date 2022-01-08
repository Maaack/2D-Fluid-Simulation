extends Viewport


export(int) var levels : int = 1
export(Material) var shader_material : Material

var nested_viewport_scene : PackedScene = preload("res://Scenes/NestedViewportContainer.tscn")

func _ready():
	if levels > 0:
		var instance = nested_viewport_scene.instance()
		add_child(instance)
		instance.set_viewport_size(size)
		instance.material = shader_material
		var sprite_node = instance.add_levels(levels - 1)
		sprite_node.centered = false
