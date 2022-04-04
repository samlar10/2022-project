extends KinematicBody

#onready var ball = $Ball
#onready var car_mesh = $CarMesh
onready var FWcast = $FrontWheelRay
onready var RWcast = $RearWheelRay
# mesh references
onready var right_wheel = $tmpParent/hatchbackSports/wheel_frontRight
onready var left_wheel = $tmpParent/hatchbackSports/wheel_frontLeft
onready var body_mesh = $tmpParent/hatchbackSports
onready var ContextRays = $ContextRays

export var gravity = -20.0
export var wheel_base = 0.6
export var steering_limit = 10.0
export var engine_power = 10.0
export var braking = -9.0
export var friction = -2.0
export var drag = -2.0
export var max_speed_reverse = 3.0

var acceleration = Vector3.ZERO
var velocity = Vector3.ZERO
var steer_angle = 0.0
var num_rays = 32
var look_ahead = 12.0
var brake_distance = 5.0
var interest = []
var danger = []
var chosen_dir = Vector3.ZERO
var forward_ray

#export (bool) var show_debug = false
#var sphere_offset = Vector3(0, -1.5, .5)
#var acceleration = 45
var steering = 40
#var turn_speed = 20
#var turn_stop_limit = 0.75
#var body_tilt = 35

var speed_input = 0
var rotate_input = 0

# ai


func _ready():
#	$Ball/DebugMesh.visible = show_debug
#	ground_ray.add_exception(ball)
#	randomize()
#	acceleration *= rand_range(0.9, 1.1)
	interest.resize(num_rays)
	danger.resize(num_rays)
	add_rays()

	
func add_rays():
	var angle = 2 * PI / num_rays
	for i in num_rays:
		var r = RayCast.new()
		ContextRays.add_child(r)
		r.cast_to = Vector3.FORWARD * look_ahead
		r.rotation.y = -angle * i
		r.enabled = true
	forward_ray = ContextRays.get_child(0)

func set_interest():
	if owner and owner.has_method("get_path_direction"):
		var path_direction = owner.get_path_direction(global_transform.origin)
		for i in num_rays:
			var d = -ContextRays.get_child(i).global_transform.basis.z
			d = d.dot(path_direction)
			interest[i] = max(0, d)

func set_danger():
	for i in num_rays:
		var ray = ContextRays.get_child(i)
		danger[i] = 1.0 if ray.is_colliding() else 0.0
		
func choose_direction():
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
	chosen_dir = Vector3.ZERO
	for i in num_rays:
		chosen_dir += -ContextRays.get_child(i).global_transform.basis.z * interest[i]
	chosen_dir = chosen_dir.normalized()

func angle_dir(fwd, target, up):
	# Returns how far "target" vector is to the left (negative)
	# or right (positive) of "fwd" vector.
	var p = fwd.cross(target)
	var dir = p.dot(up)
	return dir
	
func _process(delta):
	# Can't steer/accelerate when in the air
	if FWcast.is_colliding() or FWcast.is_colliding():
		return
	set_interest()
	set_danger()
	choose_direction()
	# f/b input
	speed_input = acceleration
	# steer input
#	rotate_target = lerp(rotate_target, rotate_input, 5 * delta)
	var a = angle_dir(-transform.basis.z, chosen_dir, transform.basis.y)
	rotate_input = a * deg2rad(steering)
	# rotate wheels for effect
	right_wheel.rotation.y = rotate_input*2
	left_wheel.rotation.y = rotate_input*2
	# brakes
	if forward_ray.is_colliding():
		var d = global_transform.origin.distance_to(forward_ray.get_collision_point())
		if d < brake_distance:
			speed_input -=  10 * acceleration * (1 - d/brake_distance)

	# align mesh with ground normal
	if FWcast.is_colliding() or FWcast.is_colliding():
		var nf = FWcast.get_collision_normal() if FWcast.is_colliding() else Vector3.UP
		var nr = FWcast.get_collision_normal() if FWcast.is_colliding() else Vector3.UP
		var n = ((nr + nf) / 2.0).normalized()
		var xform = align_with_y(global_transform, n)
		global_transform = global_transform.interpolate_with(xform, 0.1)
	
func _physics_process(delta):
	acceleration.y = gravity
	velocity += acceleration * delta
	velocity = move_and_slide_with_snap(velocity, -transform.basis.y, Vector3.UP, true)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
		
