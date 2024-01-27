extends Obstacle
@onready var rope = $Rope

var heights = [0,NAN,0,NAN]
var pulse_timer = 2

func _ready():
	rope.apply_impulse(Vector3(3,0,0))
	
func _physics_process(delta):
	pulse_timer -= delta
	if pulse_timer <= 0:
		var ball_direction: Vector3 = Vector3(rope.linear_velocity.x,rope.linear_velocity.y,rope.linear_velocity.z).normalized()
		pulse_timer = 2
		print(ball_direction)
		rope.apply_impulse(ball_direction*3)	
		print(pulse_timer)
	
