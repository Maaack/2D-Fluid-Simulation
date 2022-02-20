extends CommonBase

enum Options{
	DYE,
	DIVERGENCE,
	PRESSURE,
	PRESSURE_FORCE,
	LAPLACIAN,
	CURL,
	VORTICITY,
	}

var scale_brush_force : float = 0.5
onready var brushes_linked : bool = $UIControl/LinkBrushCheckbox.pressed

func _refresh_velocity():
	$VelocityViewport/Icon2.show()
	yield(get_tree().create_timer(0.25), "timeout")
	$VelocityViewport/Icon2.hide()

func _refresh_icon():
	$DyeViewport/Icon.show()
	yield(get_tree().create_timer(0.25), "timeout")
	$DyeViewport/Icon.hide()

func _refresh_clear():
	$DyeViewport/Sprite.hide()
	yield(get_tree().create_timer(0.25), "timeout")
	$DyeViewport/Sprite.show()

func _ready():
	var velocity_texture = $VelocityBackBufferViewport.get_texture()
	$VelocityViewport/Sprite.texture = velocity_texture
	var dye_texture = $BackBufferViewport.get_texture()
	$DyeViewport/Sprite.texture = dye_texture
	$DyeViewport/Sprite.material.set_shader_param("brushColor", $UIControl/ColorPickerButton.color)
	yield(get_tree().create_timer(0.1), "timeout")
	_set_resolution($UIControl/ResolutionButton.selected)
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

func _on_PressureScaleSpinBox_value_changed(value):
	$VelocityViewport/Sprite.material.set_shader_param("pressureScale", value)
	$PressureViewport/Sprite.material.set_shader_param("pressureScale", value)
	$PressureForceViewport/Sprite.material.set_shader_param("pressureScale", value)

func _on_PressureMinSpinBox_value_changed(value):
	$VelocityViewport/Sprite.material.set_shader_param("pressureMin", value)

func _on_PressureMaxSpinBox_value_changed(value):
	$VelocityViewport/Sprite.material.set_shader_param("pressureMax", value)

func _on_LaplacianSpinBox_value_changed(value):
	$VelocityViewport/Sprite.material.set_shader_param("laplacianScale", value)
	$LaplacianViewport/Sprite.material.set_shader_param("laplacianScale", value)

func _on_VorticitySpinBox_value_changed(value):
	$VelocityViewport/Sprite.material.set_shader_param("vorticityScale", value)
	$VorticityViewport/Sprite.material.set_shader_param("vorticityScale", value)

func _on_BordersOptionButton_toggled(button_pressed):
	$VelocityViewport/Sprite.material.set_shader_param("borderOn", button_pressed)

func _on_LinkBrushCheckbox_toggled(button_pressed):
	brushes_linked = button_pressed

func _apply_velocity_force(position, vector, cascade : bool = false):
	vector *= scale_brush_force
	$VelocityViewport/Sprite.material.set_shader_param("externalForceUV", position)
	$VelocityViewport/Sprite.material.set_shader_param("externalForceVector", vector)
	$VelocityViewport/Sprite.material.set_shader_param("externalForceOn", true)
	if (cascade):
		_apply_dye_paint(position, vector)

func _release_velocity_force(position, cascade : bool = false):
	$VelocityViewport/Sprite.material.set_shader_param("externalForceOn", false)
	$VelocityViewport/Sprite.material.set_shader_param("externalForceVector", Vector2.ZERO)
	if (cascade):
		_release_dye_paint(position)

func _apply_dye_paint(position, vector, cascade : bool = false):
	$DyeViewport/Sprite.material.set_shader_param("brushCenterUV", position)
	$DyeViewport/Sprite.material.set_shader_param("brushOn", true)
	if (cascade):
		_apply_velocity_force(position, vector)

func _release_dye_paint(position, cascade : bool = false):
	$DyeViewport/Sprite.material.set_shader_param("brushOn", false)
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
	$VelocityViewport/Sprite.material.set_shader_param("brushScale", scale)
	$DyeViewport/Sprite.material.set_shader_param("brushScale", scale)

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
	$VelocityViewport/Sprite.material.set_shader_param("externalForceBrush", brush_texture)
	$DyeViewport/Sprite.material.set_shader_param("brushTexture", brush_texture)

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
		Options.DIVERGENCE:
			$FinalViewportSprite.texture = $DivergenceViewport.get_texture()
		Options.PRESSURE:
			$FinalViewportSprite.texture = $PressureViewport.get_texture()
		Options.PRESSURE_FORCE:
			$FinalViewportSprite.texture = $PressureForceViewport.get_texture()
		Options.LAPLACIAN:
			$FinalViewportSprite.texture = $LaplacianViewport.get_texture()
		Options.CURL:
			$FinalViewportSprite.texture = $CurlViewport.get_texture()
		Options.VORTICITY:
			$FinalViewportSprite.texture = $VorticityViewport.get_texture()

func _on_ResolutionButton_item_selected(index):
	_set_resolution(index)

func _on_BrushTypeButton_item_selected(index):
	_set_brush_texture(index)

func _on_BrushSizeHSlider_value_changed(value):
	_set_brush_scale(value)
