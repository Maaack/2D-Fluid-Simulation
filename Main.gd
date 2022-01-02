extends Node2D

func _ready():
	var dye_texture = $DyeViewport.get_texture()
	var velocity_texture = $VelocityViewport.get_texture()
	$DyeViewport/Icon.material.set_shader_param("velocity", velocity_texture)
	$DyeViewport/Icon.material.set_shader_param("advected", dye_texture)
	$VelocityViewport/Icon.material.set_shader_param("velocity", velocity_texture)
	$VelocityViewport/Icon.material.set_shader_param("advected", velocity_texture)
