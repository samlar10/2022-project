extends VehicleBody

export var max_rpm = 300
export var max_torque = 200

signal change_camera

var current_camera = 0
onready var num_cameras = $CameraPositions.get_child_count()

func _ready():
	emit_signal("change_camera", $CameraPositions.get_child(current_camera))

func _input(event):
	if event.is_action_pressed("change_camera"):
		current_camera = wrapi(current_camera + 1, 0, num_cameras)
		emit_signal("change_camera", $CameraPositions.get_child(current_camera))

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("steer_right","steer_left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("brake","accelerate")
	var rpm = $BL.get_rpm()
	$BL.engine_force = acceleration * max_torque * ( 1 - rpm / max_rpm )
	rpm = $BR.get_rpm()
	$BR.engine_force = acceleration * max_torque * ( 1 - rpm / max_rpm )


