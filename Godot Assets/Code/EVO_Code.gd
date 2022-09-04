extends "res://Godot Assets/Code/car_base.gd"

onready var EVO = $EVO_Body
onready var ground_ray = $RayCast

onready var right_wheel = $EVO_Body/FR
onready var left_wheel = $EVO_Body/FL

var num_rays = 32
var look_ahead = 12.0
var brake_distance = 2.0
var interest = []
var danger = []
var chosen_dir = Vector3.ZERO
var forward_ray

func _ready():
	ground_ray.add_exception(EVO)
	randomize()
	acceleration *= rand_range(0.9, 1.1)
	interest.resize(num_rays)
	danger.resize(num_rays)
	add_rays()

func get_input():
#	var turn = Input.get_action_strength("steer_left")/3
#	turn -= Input.get_action_strength("steer_right") /3
#	steer_angle = turn * deg2rad(steering_limit)
#	$tmpParent/sedanSports/wheel_frontRight.rotation.y = steer_angle*2
#	$tmpParent/sedanSports/wheel_frontLeft.rotation.y = steer_angle*2
#	acceleration = Vector3.ZERO
#	if Input.is_action_pressed("accelerate"):
#		acceleration = -transform.basis.z * engine_power
#	if Input.is_action_pressed("brake"):
#		acceleration = -transform.basis.z * braking
	pass

func add_rays():
	var angle = 2 * PI / num_rays
	for i in num_rays:
		var r = RayCast.new()
		$ContextRays.add_child(r)
		r.cast_to = Vector3.FORWARD * look_ahead
		r.rotation.y = -angle * i
		r.enabled = true
	forward_ray = $ContextRays.get_child(0)

func set_interest():
	var path_direction = -EVO.transform.basis.z
	if owner and owner.has_method("get_path_direction"):
		path_direction = owner.get_path_direction(EVO.global_transform.origin)
	for i in num_rays:
		var d = -$ContextRays.get_child(i).global_transform.basis.z
		d = d.dot(path_direction)
		interest[i] = max(0, d)

func set_danger():
	for i in num_rays:
		var ray = $ContextRays.get_child(i)
		danger[i] = 1.0 if ray.is_colliding() else 0.0
		
func choose_direction():
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
	chosen_dir = Vector3.ZERO
	for i in num_rays:
		chosen_dir += -$ContextRays.get_child(i).global_transform.basis.z * interest[i]
	chosen_dir = chosen_dir.normalized()

func angle_dir(fwd, target, up):
	# Returns how far "target" vector is to the left (negative)
	# or right (positive) of "fwd" vector.
	var p = fwd.cross(target)
	var dir = p.dot(up)
	return dir
