extends Node

func _ready():
	$VelocityViewport/Icon.material.set_shader_param("velocity", $GradientSubtractionViewport.get_texture())
	yield(get_tree().create_timer(1.0), "timeout")
	$VelocityViewport/Icon2.hide()
	$VelocityViewport/Icon.show()
	$DyeViewport/Icon2.hide()
	$DyeViewport/Icon.show()

func _process(delta):
	$DyeViewport/Icon.material.set_shader_param("deltaTime", delta)
	$VelocityViewport/Icon.material.set_shader_param("deltaTime", delta)
