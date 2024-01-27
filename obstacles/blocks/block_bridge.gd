extends Block
@export_range(1.25, 3.00, 0.25) var bridge_width_diff: float = 1.25

func _ready():
	heights = [height,NAN,height,NAN]
	mesh_instance.mesh.size.y = height*BLOCK_MAX_HEIGHT
	mesh_instance.mesh.size.x = bridge_width_diff
	mesh_instance.create_convex_collision(true, true)
	#printt(height*BLOCK_MAX_HEIGHT, bridge_width_diff)
