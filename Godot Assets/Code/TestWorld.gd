extends Spatial

func get_path_direction(position):
	var offset = $Basic_track/Path.curve.get_closest_offset(position)
	$Basic_track/Path/PathFollow.offset = offset
	return $Basic_track/Path/PathFollow.transform.basis.z
	
func _ready():
	print($Basic_track["transform"])
