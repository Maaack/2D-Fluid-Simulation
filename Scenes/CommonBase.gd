class_name CommonBase
extends Node

enum BrushTypes{
	SOFTEST,
	SOFT,
	HARD,
	HARDEST,
	BRISTLES
}
enum Resolutions{
	_64,
	_128,
	_256,
	_512
}
enum Scenes{
	MINIMAL,
	MULTI_PASS,
	SINGLE_PASS
}
const MIN_RESOLUTION : int = 64;
const MAX_RESOLUTION : int = 512;

var colors_array : Array = [
	Color("5059ff00"),
	Color("5000ff76"),
	Color("5000ffff"),
	Color("502b3dff"),
	Color("507619ff"),
	Color("50ff00ad"),
	Color("50ff2116"),
	Color("50ff8300"),
	Color("50fff500"),
	Color("50c7ff00"),
]
var current_color_counter : int = 0;

func _is_rotating_color() -> bool:
	return false

func _apply_rotated_color() -> void:
	pass

func _rotate_color() -> void:
	if _is_rotating_color():
		current_color_counter += 1
		current_color_counter %= colors_array.size()
		_apply_rotated_color()

func _get_current_array_color() -> Color:
	return colors_array[current_color_counter]
