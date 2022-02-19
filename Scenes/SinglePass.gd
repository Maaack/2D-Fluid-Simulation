extends Node

enum Options{
	DYE,
	DIVERGENCE,
	PRESSURE,
	PRESSURE_FORCE,
	LAPLACIAN,
	CURL,
	VORTICITY,
	}

var velocity_source_next : bool = false
var scale_brush_force : float = 0.5;

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
	_refresh_velocity()
	_refresh_icon()

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

func _on_MouseVelocityControl_force_applied(position, vector):
	vector *= scale_brush_force
	$VelocityViewport/Sprite.material.set_shader_param("externalForceVector", vector)
	$VelocityViewport/Sprite.material.set_shader_param("externalForceUV", position)
	$VelocityViewport/Sprite.material.set_shader_param("externalForceOn", true)

func _on_MouseVelocityControl_force_released(position):
	$VelocityViewport/Sprite.material.set_shader_param("externalForceUV", Color.black)
	$VelocityViewport/Sprite.material.set_shader_param("externalForceOn", false)

func _on_MouseDyeControl_force_applied(position, vector):
	$DyeViewport/Sprite.material.set_shader_param("brushCenterUV", position)
	$DyeViewport/Sprite.material.set_shader_param("brushOn", true)

func _on_MouseDyeControl_force_released(position):
	$DyeViewport/Sprite.material.set_shader_param("brushOn", false)

func _on_LaplacianSpinBox_value_changed(value):
	$VelocityViewport/Sprite.material.set_shader_param("laplacianScale", value)
	$LaplacianViewport/Sprite.material.set_shader_param("laplacianScale", value)

func _on_VorticitySpinBox_value_changed(value):
	$VelocityViewport/Sprite.material.set_shader_param("vorticityScale", value)
	$VorticityViewport/Sprite.material.set_shader_param("vorticityScale", value)

func _on_BordersOptionButton_toggled(button_pressed):
	$VelocityViewport/Sprite.material.set_shader_param("borderOn", button_pressed)

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
