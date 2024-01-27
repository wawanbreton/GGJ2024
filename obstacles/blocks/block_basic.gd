extends Block

func _ready():
	heights = [height,height,height,height]
	mesh_instance.mesh.size.y = height*BLOCK_MAX_HEIGHT
	mesh_instance.create_convex_collision(true, true)
