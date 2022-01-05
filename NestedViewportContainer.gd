extends ViewportContainer

func add_level():
	var instance = load("res://NestedViewportContainer.tscn").instance()
	$Viewport.add_child(instance)
	return instance

func add_icon():
	var instance = Sprite.new()
	$Viewport.add_child(instance)
	return instance

func add_levels(levels: int):
	if levels > 1:
		var container = add_level()
		container.material = self.material
		container.set_viewport_size($Viewport.size)
		return container.add_levels(levels - 1)
	else:
		return add_icon()

func set_viewport_size(size : Vector2) -> void:
	$Viewport.size = size

func _process(delta):
	material.set_shader_param("deltaTime", delta)
