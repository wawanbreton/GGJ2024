extends Node3D


func _physics_process(delta):
    get_node("RearLeftWheel/PinJoint3D").set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY,
                                                   Input.get_action_strength("LeftMotor") * 3)
    get_node("RearRightWheel/PinJoint3D").set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, 
                                                    Input.get_action_strength("RightMotor") * 3)
