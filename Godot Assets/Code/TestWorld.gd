extends Spatial

func get_path_direction(position):
	var offset = $Highlands_track/Path.curve.get_closest_offset(position)
	$Highlands_track/Path/PathFollow.offset = offset
	return $Highlands_track/Path/PathFollow.transform.basis.z

func _ready():
	print($Highlands_track["transform"])

func _on_pause_pressed():
	load("res://Godot Assets/UI/PauseMenu.tscn")
