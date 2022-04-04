extends KinematicBody


export var max_speed = 350
export var steer_force = 0.1
export var look_ahead = 100
export var num_rays = 16

var ray_directions = {}
var interest = []
var danger = []

var chosen_dir = Vector3.ZERO
var acceleration = Vector3.ZERO
var velocity = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector3.RIGHT.rotated(angle)
		 
func _physics_process(delta):
	set_interest()
	set_danger()
	choose_direction()
	var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	velocity = velocity.linear_interpolate(desired_velocity, steer_force)
	rotation = velocity.angle()
	move_and_collide(velocity * delta)
	
func set_interest():
	if owner and owner.has_method("get_path_direction"):
		var path_direction = owner.get_path_direction(position)
		for i in num_rays:
			var d = ray_directions[i].rotated(rotation).dot(path_direction)
			interst[i] = max(0, d)
	else:
		set_default_interest()


func set_default_interest():
	for i in num_rays:
		var d = ray_directions[i].rotated(rotation).dot(transform.x)
		interet[i] = max(0, d)
		
func set_danger():
	var space_state = get_world_3d().direct_space_state
