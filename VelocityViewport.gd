extends Viewport

func _process(delta):
	$Icon.material.set_shader_param("deltaTime", delta)

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	$Icon2.hide()
	$Icon.show()
	while true:
		yield(get_tree().create_timer(5.0), "timeout")
		$Icon.hide()
		$Icon2.show()
		yield(get_tree().create_timer(0.5), "timeout")
		$Icon2.hide()
		$Icon.show()

