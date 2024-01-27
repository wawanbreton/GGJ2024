extends Node3D

@export var active: bool : set = set_active, get = get_active

signal start_game
signal tilt

func _ready():
	set_active(false)

func get_active():
	return get_node("RearLeftWheel/Joint").get_flag(HingeJoint3D.FLAG_ENABLE_MOTOR)

func set_active(new_active):
	get_node("RearLeftWheel/Joint").set_flag(HingeJoint3D.FLAG_ENABLE_MOTOR, new_active)
	get_node("RearRightWheel/Joint").set_flag(HingeJoint3D.FLAG_ENABLE_MOTOR, new_active)

func _physics_process(delta):
	var euler = self.global_transform.basis.get_euler()
	if self.active and (absf(euler.x) > PI / 3 or absf(euler.z) > PI / 3):
		emit_signal("tilt")

	var acceleration = 5
	var target_speed = 5
	
	var left_up = Input.get_action_strength("LeftMotorUp")
	var left_down = Input.get_action_strength("LeftMotorDown")
	var left = left_up - left_down
	var right_up = Input.get_action_strength("RightMotorUp")
	var right_down = Input.get_action_strength("RightMotorDown")
	var right = right_up - right_down
	
	var node_left = get_node("RearLeftWheel/Joint")
	left = lerp(node_left.get_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY), 
				left * target_speed,
				delta * acceleration)
	node_left.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, left)
	
	var node_right = get_node("RearRightWheel/Joint")
	right = lerp(node_right.get_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY) , 
				 right * target_speed,
				 delta * acceleration)
	node_right.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, right)
