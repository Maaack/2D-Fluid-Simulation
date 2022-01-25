extends Node

var velocity_source_next : bool = false

func _refresh_velocity():
	$VelocityViewport/Icon.hide()
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

func _switch_velocity():
	velocity_source_next = not velocity_source_next
	if velocity_source_next:
		$VelocityViewport/Icon.texture = $GradientSubtractionViewport.get_texture()
	else:
		$VelocityViewport/Icon.texture = $VelocityViewport.get_texture()
	

func _ready():
	$VelocityViewport/Icon.material.set_shader_param("velocity", $GradientSubtractionViewport.get_texture())
	_refresh_velocity()
	_refresh_dye()

func _process(delta):
	$DyeViewport/Icon.material.set_shader_param("deltaTime", delta)
	$VelocityViewport/Icon.material.set_shader_param("deltaTime", delta)
	$ViscosityViewport.set_shader_param("deltaTime", delta)

func _on_RefreshVelocityButton_pressed():
	_refresh_velocity()

func _on_SwitchVelocityButton_pressed():
	_switch_velocity()

func _on_RefreshDyeButton_pressed():
	_refresh_dye()

func _on_PressureLevelSpinBox_value_changed(value):
	$PressureViewport.levels = value

func _on_ViscosityLevelSpinBox_value_changed(value):
	$ViscosityViewport.levels = value

func _on_ViscosityMeasureSpinBox_value_changed(value):
	$ViscosityViewport.set_shader_param("viscosity", value)

func _on_VorticityMeasureSpinBox_value_changed(value):
	$VelocityForcesViewport/Sprite.material.set_shader_param("vorticity", value)

func _on_BordersOptionButton_toggled(button_pressed):
	$VelocityBorderViewport/Sprite.material.set_shader_param("active", button_pressed)
