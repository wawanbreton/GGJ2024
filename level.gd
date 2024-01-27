extends Node3D

#const level_block_scn = preload("res://level_block.tscn")

const _TEST_A_SCN = preload("res://levelblocks/test_block_a.tscn")

const _SCENES := [
	[_TEST_A_SCN, [0,0,0,0]],
	[_TEST_A_SCN, [0,0,0,NAN]],
	[_TEST_A_SCN, [0,NAN,0,NAN]],
	[_TEST_A_SCN, [0,0,NAN,NAN]],
	[_TEST_A_SCN, [NAN,NAN,NAN,0]],
	[_TEST_A_SCN, [NAN,0,NAN,0]],
	[_TEST_A_SCN, [NAN,NAN,0,0]],
	[preload("res://levelblocks/test_block_b.tscn"), []],
	#preload("res://obstacles/obstacle_movable_box.tscn"),
	#preload("res://obstacles/obstacle_poll.tscn"),
	##preload("res://obstacles/obstacle_poll_group.tscn"),
	#preload("res://obstacles/obstacle_ramp.tscn"),
	#preload("res://obstacles/obstacle_wall_1x1.tscn"),
]

const WIDTH := Vector2(-10,11)
const DEPTH := Vector2(-10,11)
const HEIGHT := Vector2(0,1)
const BLOCK_DIMENSIONS := Vector3(3.0, 3.0, 3.0)
const NUM_CHECKPOINTS := 3

var _blocks := {}   # Dictionary[Vector3, Node3D]

# first is start, last is finish, in between is the _actual_ checkpoints
var _checkpoints := [Vector3(0,0,0), Vector3(9,9,9)]

func get_start_pos() -> Vector3:
	return (_checkpoints[0] + Vector3(0.5, 0.5, 0.5)) * BLOCK_DIMENSIONS

func _instance_scene(i):
	var scn = _SCENES[i][0].instantiate()
	if  "heights" in scn:  #scn.has_method("init_args"):
		scn.heights = _SCENES[i][1]
	return scn

func _make_level_old():
	for iw in range(WIDTH.x, WIDTH.y):
		for id in range(DEPTH.x, DEPTH.y):
			for ih in range(HEIGHT.x, HEIGHT.y):
				if iw in [-1,0,1,] and id in [-1,0,1]:
					continue
				if randf() < 0.67:
					var grid_pos = Vector3(iw,ih,id)
					var level_block = self._instance_scene(randi_range(0, len(_SCENES)-1))
					level_block.position = grid_pos * BLOCK_DIMENSIONS
					_blocks[grid_pos] = level_block
					self.add_child(level_block)

func _make_maze():
	var end_point = _checkpoints[_checkpoints[-1]]

	var visited_blocks = {}
	var next_block_list = [_checkpoints[0]]
	var path_to_end = [_checkpoints[0]]
	
	while len(next_block_list) > 0:
		next_block_list.shuffle()  # a bit slow bit it should be OK
		var next_block = next_block_list.pop_front()
		if next_block in visited_blocks:
			continue


func _place_blocks():
	for iw in range(WIDTH.x, WIDTH.y):
		for id in range(DEPTH.x, DEPTH.y):
			for ih in range(HEIGHT.x, HEIGHT.y):
				if iw in [-3,-2,-1,0,1,2,3] and id in [-3,-2,-1,0,1,2,3]:
					continue
				if randf() < 0.34:
					var grid_pos = Vector3(iw,id,ih)
					#var level_block = level_block_scn.instantiate()
					#level_block.position = grid_pos * BLOCK_DIMENSIONS
					#_blocks[grid_pos] = level_block
					#self.add_child(level_block)

func _ready():
	randomize()
	## TODO: randomize start, finish
	#self._make_maze()
	## TODO: set (rest of) checkpoints
	#self._place_blocks()
	self._make_level_old()

#func _process(_delta):
#	pass
