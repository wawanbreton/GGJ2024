extends Block
@onready var timer = $Timer

func _init():
	heights = [height,height,height,height]

func _ready():
	mesh_instance.mesh.size.y = height*BLOCK_MAX_HEIGHT
	mesh_instance.create_convex_collision(true, true)
	

func _on_timer_timeout():
	
	pass # Replace with function body.
