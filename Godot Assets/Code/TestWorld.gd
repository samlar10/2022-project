extends Spatial
#
func get_path_direction(position):
#	var offset = $Basic_track/Path.curve.get_closest_offset(position)
#	$Basic_track/Path/PathFollow.offset = offset
#	return $Basic_track/Path/PathFollow.transform.basis.z
#
	var offset = $Highlands_track2/Path.curve.get_closest_offset(position)
	$Highlands_track2/Path/PathFollow.offset = offset
	return $Highlands_track2/Path/PathFollow.transform.basis.z

func _ready():
#	print($Basic_track["transform"])
	print($Highlands_track2["transform"])
