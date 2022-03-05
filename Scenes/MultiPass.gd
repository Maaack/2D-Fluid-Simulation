extends CommonBase

enum Options{
	DYE,
	VISCOSITY,
	DIVERGENCE,
	PRESSURE,
	PRESSURE_FORCE,
	}

enum VelocitySource{
	VISCOSITY,
	FINAL
}

var scale_brush_force : float = 0.1

onready var auto_color : bool = $UIControl/AutoColorCheckBox.pressed
onready var brushes_linked : bool = $UIControl/LinkBrushCheckbox.pressed

func _refresh_velocity():
	$VelocityViewport/Sprite.hide()
	yield(get_tree().create_timer(0.3), "timeout")
	$VelocityViewport/Sprite.show()

func _refresh_icon():
	$DyeViewport/Icon.show()
	yield(get_tree().create_timer(0.3), "timeout")
	$DyeViewport/Icon.hide()

func _refresh_clear():
	$DyeViewport/Sprite.hide()
	yield(get_tree().create_timer(0.3), "timeout")
	$DyeViewport/Sprite.show()

func _set_velocity_source(setting : int):
	var velocity_texture : Texture
	match(setting):
		VelocitySource.VISCOSITY:
			velocity_texture = $ViscosityViewport.get_texture()
		VelocitySource.FINAL:
			velocity_texture = $GradientSubtractionViewport.get_texture()
	$VelocityViewport/Sprite.texture = velocity_texture

func _is_rotating_color() -> bool:
	return auto_color

func _apply_rotated_color():
	var current_color = _get_current_array_color()
	$UIControl/ColorPickerButton.color = current_color
	$DyeViewport/Sprite.material.set_shader_param("brushColor", current_color)

func _ready():
	_set_velocity_source(VelocitySource.VISCOSITY)
	$VelocityViewport/Sprite.material.set_shader_param("velocity", $GradientSubtractionViewport.get_texture())
	var dye_texture = $BackBufferViewport.get_texture()
	$DyeViewport/Sprite.texture = dye_texture
	$DyeViewport/Sprite.material.set_shader_param("brushColor", $UIControl/ColorPickerButton.color)
	yield(get_tree().create_timer(0.1), "timeout")
	_set_resolution_setting($UIControl/ResolutionButton.selected)
	_set_brush_texture($UIControl/BrushTypeButton.selected)
	_set_brush_scale($UIControl/BrushSizeHSlider.value)

func _process(delta):
	$DyeViewport/Sprite.material.set_shader_param("deltaTime", delta)
	$VelocityViewport/Sprite.material.set_shader_param("deltaTime", delta)

func _on_RefreshVelocityButton_pressed():
	_refresh_velocity()

func _on_RefreshIconButton_pressed():
	_refresh_icon()

func _on_RefreshClearButton_pressed():
	_refresh_clear()

func _on_PressureLevelSpinBox_value_changed(value):
	$PressureViewport.levels = value

func _on_ViscosityLevelSpinBox_value_changed(value):
	$ViscosityViewport.levels = value

func _on_ViscosityScaleSpinBox_value_changed(value):
	$ViscosityViewport.set_shader_param("viscosityScale", value)

func _on_VorticityMeasureSpinBox_value_changed(value):
	$VelocityForcesViewport/Sprite.material.set_shader_param("vorticityScale", value)

func _on_BordersCheckbox_toggled(button_pressed):
	$VelocityBorderViewport/Sprite.material.set_shader_param("borderActive", button_pressed)
	$PressureBorderViewport/Sprite.material.set_shader_param("borderActive", button_pressed)

func _on_LinkBrushCheckbox_toggled(button_pressed):
	brushes_linked = button_pressed

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

func _on_MouseDyeControl_force_applied(position, vector):
	_apply_dye_paint(position, vector, brushes_linked)

func _on_MouseDyeControl_force_released(position):
	_release_dye_paint(position, brushes_linked)

func _on_ColorPickerButton_color_changed(color):
	$DyeViewport/Sprite.material.set_shader_param("brushColor", color)

func _set_brush_scale(scale : float):
	$VelocityViewport/Sprite.material.set_shader_param("brushScale", Vector2(scale, scale))
	$DyeViewport/Sprite.material.set_shader_param("brushScale", Vector2(scale, scale))

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

func _set_resolution_setting(setting : int):
	var resolution : int
	match(setting):
		Resolutions._64:
			resolution = 64;
		Resolutions._128:
			resolution = 128;
		Resolutions._256:
			resolution = 256;
		Resolutions._512:
			resolution = 512;
	var size = Vector2(resolution, resolution)
	var sprite_scale = Vector2(MAX_RESOLUTION/float(resolution), MAX_RESOLUTION/float(resolution))
	var icon_scale = Vector2(resolution/float(MIN_RESOLUTION), resolution/float(MIN_RESOLUTION))
	for child in get_children():
		if child is Viewport:
			child.size = size
		elif child is Sprite:
			child.scale = sprite_scale
			child.region_enabled = true
			child.region_enabled = false
	$DyeViewport/Icon.scale = icon_scale
	$DyeViewport/Icon.region_enabled = true
	$DyeViewport/Icon.region_enabled = false
	_refresh_velocity()
	_refresh_icon()

func _on_FinalViewButton_item_selected(index):
	match(index):
		Options.DYE:
			$FinalViewportSprite.texture = $DyeViewport.get_texture()
		Options.VISCOSITY:
			$FinalViewportSprite.texture = $VelocityBorderViewport.get_texture()
		Options.DIVERGENCE:
			$FinalViewportSprite.texture = $DivergenceViewport.get_texture()
		Options.PRESSURE:
			$FinalViewportSprite.texture = $PressureBorderViewport.get_texture()
		Options.PRESSURE_FORCE:
			$FinalViewportSprite.texture = $GradientSubtractionViewport.get_texture()
	if index == Options.DYE:
		$UIControl/RefreshClearButton.show()
		$UIControl/RefreshIconButton.show()
	else:
		$UIControl/RefreshClearButton.hide()
		$UIControl/RefreshIconButton.hide()

func _on_ResolutionButton_item_selected(index):
	_set_resolution_setting(index)

func _on_BrushTypeButton_item_selected(index):
	_set_brush_texture(index)

func _on_BrushSizeHSlider_value_changed(value):
	_set_brush_scale(value)

func _on_SceneButton_item_selected(index):
	match(index):
		Scenes.MINIMAL:
			get_tree().change_scene("res://Scenes/Main.tscn")
		Scenes.SINGLE_PASS:
			get_tree().change_scene("res://Scenes/SinglePass.tscn")

func _on_VelocitySourceButton_item_selected(index):
	_set_velocity_source(index)

func _on_AutoColorCheckBox_toggled(button_pressed):
	auto_color = button_pressed
