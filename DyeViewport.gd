extends Viewport

func _process(delta):
	$Icon.material.set_shader_param("deltaTime", delta)

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	$Icon2.hide()
	$Icon.show()

