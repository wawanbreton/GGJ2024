extends Block
@export_range(1.25, 3.00, 0.25) var bridge_width_diff: float = 1.25

func _init():
	heights = [height,NAN,height,NAN]

func _ready():
	mesh_instance.mesh.size.y = 2.0*height*BLOCK_MAX_HEIGHT  # x2 because of centering
	mesh_instance.mesh.size.x = bridge_width_diff
	mesh_instance.create_convex_collision(true, true)
	#printt(height*BLOCK_MAX_HEIGHT, bridge_width_diff)
