extends StaticBody3D
class_name Block

@onready var mesh_instance = $MeshInstance3D
@export_range(0.00, 1.00, 0.25) var height: float = 0.25

var BLOCK_DIMENSION: float = 3.0
var BLOCK_MAX_HEIGHT: float = 1.0
var heights = [0,0,0,0]



func _ready():
	mesh_instance.mesh.size.z = BLOCK_DIMENSION
	mesh_instance.mesh.size.x = BLOCK_DIMENSION

