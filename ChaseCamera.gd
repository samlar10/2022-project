extends Camera

export var lerp_speed = 50.0

var target = null

func _physics_process(delta):
	if !target:
		return
	global_transform = global_transform.interpolate_with(target.global_transform, lerp_speed * delta)

func _ready():
	pass



func _on_Impreza_change_camera(t):
	target = t
