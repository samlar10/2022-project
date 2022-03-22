extends KinematicBody

export var gravity = -20.0
export var wheel_base = 0.6
export var steering_limit = 10.0
export var engine_power = 6.0
export var braking = -9.0
export var friction = -2.0
export var drag = -2.0
export var max_speed_reverse = 3.0
export var num_rays = 16

var ray_directions = {}
var interest = []
var danger = []

var chosen_dir = Vector3.ZERO
var acceleration = Vector3.ZERO
var velocity = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
