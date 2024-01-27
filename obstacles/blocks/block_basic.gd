extends Block

func _init():
	heights = [height,height,height,height]

func _ready():
	mesh_instance.mesh.size.y = 2.0*height*BLOCK_MAX_HEIGHT  # x2 because of centering
	mesh_instance.create_convex_collision(true, true)
