extends Obstacle
@onready var rope = $Rope

var heights = [0,NAN,0,NAN]

func _ready():
	pass
	
func _physics_process(_delta):
	if rope.angular_velocity.x < 100:
		rope.apply_impulse(Vector3(3,0,0))		
	pass
