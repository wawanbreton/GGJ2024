extends Block

#@export var ramp_angle: float = 15



func _ready():
	print(height)
	heights = [0,NAN,height,NAN]
	mesh_instance.mesh.size.y = height*BLOCK_MAX_HEIGHT
	mesh_instance.create_convex_collision(true, true)
	
	#only needed if we generate the scale based on the height
	#collision_shape_3d.scale.y = tan(deg_to_rad(ramp_angle))*collision_shape_3d.scale.z
	
