extends Block

@export var mesh_instance: MeshInstance3D


@onready var mesh_instance_3d = $MeshInstance3D
#@export var ramp_angle: float = 15



func _ready():
	print(height)
	heights = [0,NAN,NAN,height]
	mesh_instance.scale.y = BLOCK_DIMENSION*height
	mesh_instance.create_convex_collision(true, true)
	
	#only needed if we generate the scale based on the height
	#collision_shape_3d.scale.y = tan(deg_to_rad(ramp_angle))*collision_shape_3d.scale.z
	
