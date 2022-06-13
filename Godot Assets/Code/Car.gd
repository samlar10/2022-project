extends VehicleBody

export var max_rpm = 300
export var max_torque = 50

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
	var rpm = $back_left_wheel.get_rpm()
	$back_left_wheel.engine_force = acceleration * max_torque * ( 1 - rpm / max_rpm )
	rpm = $back_right_wheel.get_rpm()
	$back_right_wheel.engine_force = acceleration * max_torque * ( 1 - rpm / max_rpm )


