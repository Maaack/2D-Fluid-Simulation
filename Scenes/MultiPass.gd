extends Node


enum Options{
	DYE,
	VISCOSITY,
	DIVERGENCE,
	PRESSURE,
	PRESSURE_FORCE,
	}

enum Resolutions{
	_64,
	_128,
	_256,
	_512
}
const MIN_RESOLUTION : int = 64;
const MAX_RESOLUTION : int = 512;

var velocity_source_next : bool = false
var scale_brush_force : float = 0.1;

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

func _switch_velocity():
	velocity_source_next = not velocity_source_next
	if velocity_source_next:
		$VelocityViewport/Sprite.texture = $GradientSubtractionViewport.get_texture()
	else:
		$VelocityViewport/Sprite.texture = $ViscosityViewport.get_texture()

func _ready():
	var velocity_texture = $ViscosityViewport.get_texture()
	$VelocityViewport/Sprite.texture = velocity_texture
	$VelocityViewport/Sprite.material.set_shader_param("velocity", $GradientSubtractionViewport.get_texture())
	var dye_texture = $BackBufferViewport.get_texture()
	$DyeViewport/Sprite.texture = dye_texture
	$DyeViewport/Sprite.material.set_shader_param("brushColor", $ColorPickerButton.color)
	yield(get_tree().create_timer(0.1), "timeout")
	_set_resolution($ResolutionButton.selected)
	_set_brush_scale($BrushSizeHSlider.value)

func _process(delta):
	$DyeViewport/Sprite.material.set_shader_param("deltaTime", delta)
	$VelocityViewport/Sprite.material.set_shader_param("deltaTime", delta)

func _on_RefreshVelocityButton_pressed():
	_refresh_velocity()

func _on_SwitchVelocityButton_pressed():
	_switch_velocity()

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

func _on_BordersOptionButton_toggled(button_pressed):
	$VelocityBorderViewport/Sprite.material.set_shader_param("active", button_pressed)

func _on_MouseControl_force_applied(position, vector):
	vector *= scale_brush_force
	$VelocityViewport/Sprite.material.set_shader_param("brushCenterUV", position)
	$VelocityViewport/Sprite.material.set_shader_param("brushColor", Color(vector.x, vector.y, 0.0, 1.0))
	$VelocityViewport/Sprite.material.set_shader_param("brushOn", true)
	$DyeViewport/Sprite.material.set_shader_param("brushCenterUV", position)
	$DyeViewport/Sprite.material.set_shader_param("brushOn", true)

func _on_MouseControl_force_released(position):
	$VelocityViewport/Sprite.material.set_shader_param("brushColor", Color.black)
	$VelocityViewport/Sprite.material.set_shader_param("brushOn", false)
	$DyeViewport/Sprite.material.set_shader_param("brushOn", false)

func _on_ColorPickerButton_color_changed(color):
	$DyeViewport/Sprite.material.set_shader_param("brushColor", color)

func _set_brush_scale(scale : float):
	$VelocityViewport/Sprite.material.set_shader_param("brushScale", scale)
	$DyeViewport/Sprite.material.set_shader_param("brushScale", scale)

func _set_resolution(setting : int):
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

func _on_ResolutionButton_item_selected(index):
	_set_resolution(index)

func _on_BrushSizeHSlider_value_changed(value):
	_set_brush_scale(value)
