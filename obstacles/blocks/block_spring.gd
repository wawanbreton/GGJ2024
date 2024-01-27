extends Block
@onready var spring_timer = $Timer


@onready var block_spring_mesh = $MeshInstance3D

var block_moving: bool = false
var block_direction:Vector3 = Vector3(0,1,0)

func _init():
	height = BLOCK_MAX_HEIGHT
	heights = [height,height,height,height]


func _ready():
	spring_timer.timeout.connect(_on_timer_timeout)
	block_spring_mesh.mesh.size.z = BLOCK_DIMENSION
	block_spring_mesh.mesh.size.x = BLOCK_DIMENSION

	#block_spring_mesh.mesh.size.y = height*BLOCK_MAX_HEIGHT-block_spring_base_mesh.mesh.size.y
	block_spring_mesh.create_convex_collision(true, true)


func _physics_process(delta):
	#print(block_moving)
	#print(spring_timer.time_left)
	if block_moving:
		position += 0.05*block_direction
		

func _on_timer_timeout():
	if block_moving:
		spring_timer.wait_time = 1
		block_moving = false
		block_direction = block_direction*(-1)
		
		
	else:
		spring_timer.wait_time = 4
		block_moving = true
		
	
	pass # Replace with function body.
