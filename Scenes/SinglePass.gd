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

func _refresh_dye():
	$DyeViewport/Icon.hide()
	$DyeViewport/Icon2.show()
	yield(get_tree().create_timer(0.25), "timeout")
	$DyeViewport/Icon2.hide()
	$DyeViewport/Icon.show()

func _ready():
	_refresh_velocity()
	_refresh_dye()

func _process(delta):
	$DyeViewport/Icon.material.set_shader_param("deltaTime", delta)
	$VelocityViewport/Icon.material.set_shader_param("deltaTime", delta)

func _on_RefreshVelocityButton_pressed():
	_refresh_velocity()

func _on_RefreshDyeButton_pressed():
	_refresh_dye()

func _on_PressureScaleSpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("pressureScale", value)
	$PressureViewport/Sprite.material.set_shader_param("pressureScale", value)
	$PressureForceViewport/Sprite.material.set_shader_param("pressureScale", value)

func _on_PressureMinSpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("pressureMin", value)

func _on_PressureMaxSpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("pressureMax", value)

func _on_MouseControl_force_applied(position, vector):
	$VelocityViewport/Icon.material.set_shader_param("externalForceVector", vector)
	$VelocityViewport/Icon.material.set_shader_param("externalForceUV", position)

func _on_LaplacianSpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("laplacianScale", value)
	$LaplacianViewport/Sprite.material.set_shader_param("laplacianScale", value)

func _on_VorticitySpinBox_value_changed(value):
	$VelocityViewport/Icon.material.set_shader_param("vorticityScale", value)
	$VorticityViewport/Sprite.material.set_shader_param("vorticityScale", value)

func _on_AdvectionSpinBox_value_changed(value):
	$DyeViewport/Icon.material.set_shader_param("advectionScale", value)

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

