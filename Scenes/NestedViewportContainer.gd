extends ViewportContainer

var viewport_child : Node

func add_level():
	if is_instance_valid(viewport_child):
		if viewport_child is ViewportContainer:
			return viewport_child
		else:
			viewport_child.queue_free()
	var instance = load("res://Scenes/NestedViewportContainer.tscn").instance()
	$Viewport.add_child(instance)
	viewport_child = instance
	return instance

func add_icon():
	if is_instance_valid(viewport_child):
		if viewport_child is Sprite:
			return viewport_child
		else:
			viewport_child.queue_free()
	var instance = Sprite.new()
	$Viewport.add_child(instance)
	viewport_child = instance
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
	if is_instance_valid(material):
		material.set_shader_param("deltaTime", delta)
