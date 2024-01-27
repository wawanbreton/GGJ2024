extends RigidBody3D

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
