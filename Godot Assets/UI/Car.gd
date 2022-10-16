extends VehicleBody

var max_rpm = 1000
var max_torque = 400


func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("steer_right","steer_left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("brake","accelerate") 
	var rpm = $back_left_wheel.get_rpm()
	$back_left_wheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	rpm = $back_right_wheel.get_rpm()
	$back_right_wheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
