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

const MIN_RESOLUTION : int = 64;
const MAX_RESOLUTION : int = 512;

var scenes_array : Array = [
	"res://Scenes/Main.tscn",
	"res://Scenes/MultiPass.tscn",
	"res://Scenes/SinglePass.tscn"
]

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

var current_scene_counter : int = 0;
var current_color_counter : int = 0;

func _change_scene_to(scene_counter : int):
	var packed_scene : PackedScene
	if scene_counter >= scenes_array.size() or scene_counter < 0:
		scene_counter = 0
	if current_scene_counter == scene_counter:
		return
	current_scene_counter = scene_counter
	packed_scene = load(scenes_array[current_scene_counter])
	get_tree().change_scene_to(packed_scene)

func _refresh_sprite(sprite_node : Sprite, hide : bool = true) -> void:
	sprite_node.visible = not hide
	yield(get_tree().create_timer(0.3), "timeout")
	sprite_node.visible = hide

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
