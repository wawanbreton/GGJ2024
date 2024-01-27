extends Node3D


func _physics_process(delta):
    var acceleration = 0.5
    var target_speed = 20
    
    var node_left = get_node("RearLeftWheel/Joint")
    var left = lerp(node_left.get_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY), 
                    Input.get_action_strength("LeftMotor") * target_speed,
                    delta * acceleration)
    node_left.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, left)
    
    var node_right = get_node("RearRightWheel/Joint")
    var right = lerp(node_right.get_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY) , 
                     Input.get_action_strength("RightMotor") * target_speed,
                     delta * acceleration)
    node_right.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, right)
