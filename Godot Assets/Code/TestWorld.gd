#extends Spatial
#
#func get_path_direction(position):
#	var offset = $Highlands_track_walls/Path.curve.get_closest_offset(position)
#	$Highlands_track_walls/Path/PathFollow.offset = offset
#	return $Highlands_track_walls/Path/PathFollow.transform.basis.z
#
#func _ready():
#	print($Highlands_track_walls["transform"])
