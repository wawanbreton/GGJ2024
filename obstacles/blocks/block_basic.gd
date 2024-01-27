extends Block

const _OBSTACLE_SCENES = [
	null,
	null,
	null,
	null,
	null,
	#preload("res://obstacles/obstacles/obstacle_double_doors.tscn"),
	preload("res://obstacles/obstacles/obstacle_movable_box.tscn"),
	preload("res://obstacles/obstacles/obstacle_pole.tscn"),
	preload("res://obstacles/obstacles/obstacle_wall_1x1.tscn"),
]

func _init():
	heights = [height,height,height,height]

func _ready():
	mesh_instance.mesh.size.y = 2.0*height*BLOCK_MAX_HEIGHT  # x2 because of centering
	mesh_instance.create_convex_collision(true, true)
	
	var maybe_thing = _OBSTACLE_SCENES[randi_range(0,len(_OBSTACLE_SCENES)-1)]
	if maybe_thing != null:
		var obs = maybe_thing.instantiate()
		obs.position.y += 1.501
		self.add_child(obs)
