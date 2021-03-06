extends CommonBase


enum Options{
	DYE,
	VELOCITY,
	VISCOSITY,
	DIVERGENCE,
	PRESSURE,
	PRESSURE_FORCE,
	}

enum ResolutionSettings{
	LOWEST,
	LOW,
	HIGH,
	HIGHEST,
}

var scale_brush_force : float = 0.1

onready var auto_color : bool = $UIControl/AutoColorCheckBox.pressed
onready var screen_size = get_viewport().get_visible_rect().size

var brushes_linked : bool = true

func _refresh_velocity():
	_refresh_sprite($VelocityViewport/Sprite)

func _refresh_clear():
	_refresh_sprite($DyeViewport/Sprite)

func _is_rotating_color() -> bool:
	return auto_color

func _apply_rotated_color():
	var current_color = _get_current_array_color()
	$UIControl/ColorPickerButton.color = current_color
	$DyeViewport/Sprite.material.set_shader_param("brushColor", current_color)

func _ready():
	var velocity_texture = $ViscosityViewport.get_texture()
	$VelocityViewport/Sprite.texture = velocity_texture
	$VelocityViewport/Sprite.material.set_shader_param("velocity", $BorderAndGradientSubtractionViewport.get_texture())
	var dye_texture = $BackBufferViewport.get_texture()
	$DyeViewport/Sprite.texture = dye_texture
	$DyeViewport/Sprite.material.set_shader_param("brushColor", $UIControl/ColorPickerButton.color)
	_set_brush_texture($UIControl/BrushTypeButton.selected)
	_set_brush_scale($UIControl/BrushSizeHSlider.value)
	yield(get_tree().create_timer(0.1), "timeout")
	_set_resolution_setting($UIControl/ResolutionButton.selected)
	current_scene_counter = $UIControl/SceneButton.selected

func _process(delta):
	$DyeViewport/Sprite.material.set_shader_param("deltaTime", delta)
	$VelocityViewport/Sprite.material.set_shader_param("deltaTime", delta)

func _on_RefreshVelocityButton_pressed():
	_refresh_velocity()

func _on_RefreshClearButton_pressed():
	_refresh_clear()

func _apply_velocity_force(position, vector, cascade : bool = false):
	vector *= scale_brush_force
	$VelocityViewport/Sprite.material.set_shader_param("brushCenterUV", position)
	$VelocityViewport/Sprite.material.set_shader_param("brushColor", Color(vector.x, vector.y, 0.0, 1.0))
	$VelocityViewport/Sprite.material.set_shader_param("brushOn", true)
	if (cascade):
		_apply_dye_paint(position, vector)

func _release_velocity_force(position, cascade : bool = false):
	$VelocityViewport/Sprite.material.set_shader_param("brushOn", false)
	$VelocityViewport/Sprite.material.set_shader_param("brushColor", Color.black)
	if (cascade):
		_release_dye_paint(position)

func _apply_dye_paint(position, vector, cascade : bool = false):
	$DyeViewport/Sprite.material.set_shader_param("brushCenterUV", position)
	$DyeViewport/Sprite.material.set_shader_param("brushOn", true)
	if (cascade):
		_apply_velocity_force(position, vector)

func _release_dye_paint(position, cascade : bool = false):
	$DyeViewport/Sprite.material.set_shader_param("brushOn", false)
	_rotate_color()
	if (cascade):
		_release_velocity_force(position)

func _on_MouseVelocityControl_force_applied(position, vector):
	_apply_velocity_force(position, vector, brushes_linked)

func _on_MouseVelocityControl_force_released(position):
	_release_velocity_force(position, brushes_linked)

func _on_ColorPickerButton_color_changed(color):
	$DyeViewport/Sprite.material.set_shader_param("brushColor", color)

func _set_brush_scale(scale : float):
	var screen_ratio : float = screen_size.x / screen_size.y
	var new_scale : Vector2 = Vector2(scale / screen_ratio, scale)
	$VelocityViewport/Sprite.material.set_shader_param("brushScale", new_scale)
	$DyeViewport/Sprite.material.set_shader_param("brushScale", new_scale)

func _set_brush_texture(texture : int):
	var brush_texture : Texture
	match(texture):
		BrushTypes.SOFTEST:
			brush_texture = preload("res://Assets/Brushes/SofterBrush.png");
		BrushTypes.SOFT:
			brush_texture = preload("res://Assets/Brushes/SoftBrush.png");
		BrushTypes.HARD:
			brush_texture = preload("res://Assets/Brushes/HardBrush.png");
		BrushTypes.HARDEST:
			brush_texture = preload("res://Assets/Brushes/HarderBrush.png");
		BrushTypes.BRISTLES:
			brush_texture = preload("res://Assets/Brushes/BristlesBrush.png");
	$VelocityViewport/Sprite.material.set_shader_param("brushTexture", brush_texture)
	$DyeViewport/Sprite.material.set_shader_param("brushTexture", brush_texture)

func _set_resolution(resolution_size : Vector2):
	for child in get_children():
		if child is Viewport:
			child.size = resolution_size
	_refresh_velocity()
	_refresh_clear()

func _set_resolution_setting(setting : int):
	var modifier : float
	match(setting):
		ResolutionSettings.LOWEST:
			modifier = pow(0.5, 3)
		ResolutionSettings.LOW:
			modifier = pow(0.5, 2)
		ResolutionSettings.HIGH:
			modifier = pow(0.5, 1)
		ResolutionSettings.HIGHEST:
			modifier = pow(0.5, 0)
	_set_resolution(screen_size * modifier)

func _on_FinalViewButton_item_selected(index):
	match(index):
		Options.DYE:
			$TextureRect.texture = $DyeViewport.get_texture()
		Options.VELOCITY:
			$TextureRect.texture = $VelocityViewport.get_texture()
		Options.VISCOSITY:
			$TextureRect.texture = $ViscosityViewport.get_texture()
		Options.DIVERGENCE:
			$TextureRect.texture = $DivergenceViewport.get_texture()
		Options.PRESSURE:
			$TextureRect.texture = $PressureViewport.get_texture()
		Options.PRESSURE_FORCE:
			$TextureRect.texture = $BorderAndGradientSubtractionViewport.get_texture()
	if index == Options.DYE:
		$UIControl/RefreshClearButton.show()
	else:
		$UIControl/RefreshClearButton.hide()

func _on_ResolutionButton_item_selected(index):
	_set_resolution_setting(index)

func _on_BrushTypeButton_item_selected(index):
	_set_brush_texture(index)

func _on_BrushSizeHSlider_value_changed(value):
	_set_brush_scale(value)

func _on_SceneButton_item_selected(index):
	_change_scene_to(index)

func _on_AutoColorCheckBox_toggled(button_pressed):
	auto_color = button_pressed
