extends KinematicBody

onready var FWcast = $FrontWheelRay
onready var RWcast = $RearWheelRay


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


func set_interest():
	pass

func set_danger():
	pass

func choose_direction():
	pass
	
func _physics_process(delta):
	if is_on_floor():
#		get_input()
		apply_friction(delta)
		calculate_steering(delta)

	acceleration.y = gravity
	velocity += acceleration * delta
	velocity = move_and_slide_with_snap(velocity, -transform.basis.y, Vector3.UP, true)
	
	if FWcast.is_colliding() or FWcast.is_colliding():
		var nf = FWcast.get_collision_normal() if FWcast.is_colliding() else Vector3.UP
		var nr = FWcast.get_collision_normal() if FWcast.is_colliding() else Vector3.UP
		var n = ((nr + nf) / 2.0).normalized()
		var xform = align_with_y(global_transform, n)
		global_transform = global_transform.interpolate_with(xform, 0.1)

func apply_friction(delta):
	if velocity.length() < 0.2 and acceleration.length() == 0:
		velocity.x = 0
		velocity.z = 0
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

func calculate_steering(delta):
	var rear_wheel = transform.origin + transform.basis.z * wheel_base / 2.0
	var front_wheel = transform.origin - transform.basis.z * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(transform.basis.y, steer_angle) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)

	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	look_at(transform.origin + new_heading, transform.basis.y)
	
	
func _process(delta):
	set_interest()
	set_danger()
	choose_direction()
	
	
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

