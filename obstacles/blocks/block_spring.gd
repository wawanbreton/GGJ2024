extends Node3D
@onready var timer = $Timer
@onready var block_spring = $BlockSpring
@onready var block_spring_base = $BlockSpringBase
@onready var block_spring_mesh = $BlockSpring/MeshInstance3D
@onready var block_spring_base_mesh = $BlockSpringBase/MeshInstance3D


#@onready var mesh_instance = $MeshInstance3D
@export_range(0.00, 1.00, 0.25) var height: float = 0.25

var BLOCK_DIMENSION: float = 3.0
var BLOCK_MAX_HEIGHT: float = 1.0
var heights = [0,0,0,0]
var block_moving: bool = false
var block_direction:Vector3 = Vector3(0,1,0)

func _init():
	heights = [height,height,height,height]
	#heights = []


func _ready():
	block_spring_mesh.mesh.size.z = BLOCK_DIMENSION
	block_spring_mesh.mesh.size.x = BLOCK_DIMENSION
	block_spring_base_mesh.mesh.size.z = BLOCK_DIMENSION
	block_spring_base_mesh.mesh.size.x = BLOCK_DIMENSION
	
	#block_spring_mesh.mesh.size.y = height*BLOCK_MAX_HEIGHT-block_spring_base_mesh.mesh.size.y
	
	block_spring_mesh.create_convex_collision(true, true)
	block_spring_base_mesh.create_convex_collision(true, true)

func _physics_process(delta):
	if block_moving:
		block_spring.position += 0.05*block_direction
		

func _on_timer_timeout():
	
	if block_moving:
		timer.wait_time = 1
		block_moving = false
		block_direction = block_direction*(-1)
		
		
	else:
		timer.wait_time = 4
		block_moving = true
		print(block_moving, timer.wait_time)
		
	
	pass # Replace with function body.
