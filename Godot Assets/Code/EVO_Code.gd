extends KinematicBody

onready var EVO = $EVO_Body
onready var ground_ray = $RayCast

onready var right_wheel = $EVO_Body/FR
onready var left_wheel = $EVO_Body/FL

 
export var gravity = -20.0
export var wheel_base = 0.6
export var steering_limit = 10.0
export var engine_power = 6.0
export var braking = -9.0
export var friction = -2.0
export var drag = -2.0
export var max_speed_reverse = 3.0

var acceleration = Vector3.ZERO
var velocity = Vector3.ZERO
var steer_angle = 0.0
 
var num_rays = 32.0
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

func add_rays():
	var angle = 2 * PI / num_rays
	for i in num_rays:
		var r = RayCast.new()
		$ContextRays.add_child(r)
		r.cast_to = Vector3.FORWARD * look_ahead
		r.rotation.y = -angle * i
		r.enabled = true
	forward_ray = $ContextRays.get_child(0)

#func set_interest():
#	var path_direction = -car_mesh.transform.basis.z
#	if owner and owner.has_method("get_path_direction"):
#		path_direction = owner.get_path_direction(ball.global_transform.origin)
#	for i in num_rays:
#		var d = -$ContextRays.get_child(i).global_transform.basis.z
#		d = d.dot(path_direction)
#		interest[i] = max(0, d)

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
	var p = fwd.cross(target)
	var dir = p.dot(up)
	return dir



func _physics_process(delta):
	if is_on_floor():
		set_interest()
		set_danger()
		choose_direction()
	acceleration.y = gravity
	velocity += acceleration * delta
	velocity = move_and_slide_with_snap(velocity, -transform.basis.y, Vector3.UP, true)
	
	speed_input = acceleration
