extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (float) var acceleration = .15
export (int) var max_speed = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):

	$Path/PathFollow.offset += acceleration * delta
	acceleration += acceleration * delta
	acceleration = clamp(acceleration,0,max_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
