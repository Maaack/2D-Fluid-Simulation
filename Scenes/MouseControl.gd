extends Control

signal force_applied(position, vector)
signal force_released(position)

var mouse_position : Vector2
var mouse_vector : Vector2

func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.position
		mouse_vector = event.relative
	if event is InputEventMouseButton:
		if not event.is_pressed():
			emit_signal("force_released", mouse_position / rect_size)

func _process(delta):
	if Input.is_mouse_button_pressed(1):
		var relative_mouse_position : Vector2 = mouse_position / rect_size
		emit_signal("force_applied", relative_mouse_position, mouse_vector)
