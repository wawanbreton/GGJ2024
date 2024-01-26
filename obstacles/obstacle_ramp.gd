extends StaticBody3D
@onready var collision_shape_3d = $CollisionShape3D

@onready var mesh_instance_3d = $MeshInstance3D
@export var ramp_angle: float = 15

func _ready():
	collision_shape_3d.scale.y = tan(deg_to_rad(ramp_angle))*collision_shape_3d.scale.z
	
