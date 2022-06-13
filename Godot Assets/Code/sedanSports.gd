extends "res://Godot Assets/Code/car_base.gd"

signal change_camera

var current_camera = 0
onready var num_cameras = $CameraPositions.get_child_count()

func _ready():
	emit_signal("change_camera", $CameraPositions.get_child(current_camera))

func _input(event):
	if event.is_action_pressed("change_camera"):
		current_camera = wrapi(current_camera + 1, 0, num_cameras)
		emit_signal("change_camera", $CameraPositions.get_child(current_camera))

func get_input():
	var turn = Input.get_action_strength("steer_left")/3
	turn -= Input.get_action_strength("steer_right") /3
	steer_angle = turn * deg2rad(steering_limit)
	$tmpParent/sedanSports/wheel_frontRight.rotation.y = steer_angle*2
	$tmpParent/sedanSports/wheel_frontLeft.rotation.y = steer_angle*2
	acceleration = Vector3.ZERO
	if Input.is_action_pressed("accelerate"):
		acceleration = -transform.basis.z * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = -transform.basis.z * braking

