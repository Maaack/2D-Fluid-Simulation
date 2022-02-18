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


func _refresh_velocity():
	$VelocityViewport/Icon.hide()
	yield(get_tree().create_timer(0.25), "timeout")
	$VelocityViewport/Icon2.show()
	yield(get_tree().create_timer(0.25), "timeout")
	$VelocityViewport/Icon2.hide()
	$VelocityViewport/Icon.show()

func _refresh_icon():
	$DyeViewport/Sprite.hide()
	$DyeViewport/Icon.show()
	yield(get_tree().create_timer(0.25), "timeout")
	$DyeViewport/Icon.hide()
	$DyeViewport/Sprite.show()

func _refresh_clear():
	$DyeViewport/Sprite.hide()
	yield(get_tree().create_timer(0.25), "timeout")
	$DyeViewport/Sprite.show()

func _ready():
	_refresh_velocity()
	_refresh_icon()
	var velocity_texture = $VelocityBackBufferViewport.get_texture()
	$VelocityViewport/Icon.texture = velocity_texture
	var dye_texture = $BackBufferViewport.get_texture()
	$DyeViewport/Sprite.texture = dye_texture

func _process(delta):
	$DyeViewport/Sprite.material.set_shader_param("deltaTime", delta)
	$VelocityViewport/Icon.material.set_shader_param("deltaTime", delta)

func _on_RefreshVelocityButton_pressed():
	_refresh_velocity()

func _on_RefreshIconButton_pressed():
	_refresh_icon()

func _on_RefreshClearButton_pressed():
	_refresh_clear()

func _on_PressureScaleSpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("pressureScale", value)
	$PressureViewport/Sprite.material.set_shader_param("pressureScale", value)
	$PressureForceViewport/Sprite.material.set_shader_param("pressureScale", value)

func _on_PressureMinSpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("pressureMin", value)

func _on_PressureMaxSpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("pressureMax", value)

func _on_MouseVelocityControl_force_applied(position, vector):
	$VelocityViewport/Icon.material.set_shader_param("externalForceVector", vector)
	$VelocityViewport/Icon.material.set_shader_param("externalForceUV", position)
	$VelocityViewport/Icon.material.set_shader_param("externalForceOn", true)

func _on_MouseVelocityControl_force_released(position):
	$VelocityViewport/Icon.material.set_shader_param("externalForceOn", false)

func _on_MouseDyeControl_force_applied(position, vector):
	$DyeViewport/Sprite.material.set_shader_param("brushCenterUV", position)
	$DyeViewport/Sprite.material.set_shader_param("brushOn", true)

func _on_MouseDyeControl_force_released(position):
	$DyeViewport/Sprite.material.set_shader_param("brushOn", false)

func _on_LaplacianSpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("laplacianScale", value)
	$LaplacianViewport/Sprite.material.set_shader_param("laplacianScale", value)

func _on_VorticitySpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("vorticityScale", value)
	$VorticityViewport/Sprite.material.set_shader_param("vorticityScale", value)

func _on_BordersOptionButton_toggled(button_pressed):
	$VelocityViewport/Icon.material.set_shader_param("borderOn", button_pressed)

func _on_FinalViewButton_item_selected(index):
	match(index):
		Options.DYE:
			$FinalViewportIcon.texture = $DyeViewport.get_texture()
		Options.DIVERGENCE:
			$FinalViewportIcon.texture = $DivergenceViewport.get_texture()
		Options.PRESSURE:
			$FinalViewportIcon.texture = $PressureViewport.get_texture()
		Options.PRESSURE_FORCE:
			$FinalViewportIcon.texture = $PressureForceViewport.get_texture()
		Options.LAPLACIAN:
			$FinalViewportIcon.texture = $LaplacianViewport.get_texture()
		Options.CURL:
			$FinalViewportIcon.texture = $CurlViewport.get_texture()
		Options.VORTICITY:
			$FinalViewportIcon.texture = $VorticityViewport.get_texture()
