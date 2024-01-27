extends Node3D

const _TEST_A_SCN = preload("res://levelblocks/test_block_a.tscn")

const _SCENES := [
	[_TEST_A_SCN, [0,0,0,0]],
	[_TEST_A_SCN, [0,0,0,NAN]],
	[_TEST_A_SCN, [0,NAN,0,NAN]],
	[_TEST_A_SCN, [0,0,NAN,NAN]],
	[_TEST_A_SCN, [NAN,NAN,NAN,0]],
	[_TEST_A_SCN, [NAN,0,NAN,0]],
	[_TEST_A_SCN, [NAN,NAN,0,0]],
	#[preload("res://levelblocks/test_block_b.tscn"), [0,0,0,0]],

	#preload("res://obstacles/obstacle_movable_box.tscn"),
	#preload("res://obstacles/obstacle_poll.tscn"),
	##preload("res://obstacles/obstacle_poll_group.tscn"),
	#preload("res://obstacles/obstacle_ramp.tscn"),
	#preload("res://obstacles/obstacle_wall_1x1.tscn"),
]
var _SIDES = [
	Vector3(1,0,0),
	Vector3(0,0,1),
	Vector3(-1,0,0),
	Vector3(0,0,-1),
]
const _OPPOSITES_MAP := [
	2,
	3,
	0,
	1,
	-1,  # four directions, plus '-1' which should map to itself
]

const WIDTH := Vector2(-1,11)
const HEIGHT := Vector2(0,1)
const DEPTH := Vector2(-1,11)
const BLOCK_DIMENSIONS := Vector3(3.0, 3.0, 3.0)
const NUM_CHECKPOINTS := 3

var _blocks := {}   # Dictionary[Vector3, Node3D]

# first is start, last is finish, in between is the _actual_ checkpoints
const _INIT_CHECKPOINTS := [Vector3(0,0,0), Vector3(9,0,9)]
var _checkpoints := _INIT_CHECKPOINTS

func get_start_pos() -> Vector3:
	return (_checkpoints[0] + Vector3(0.5, 0.1, 0.5)) * BLOCK_DIMENSIONS

func _within_grid_bounds(q):
	if q.x < WIDTH.x or q.x >= WIDTH.y:
		return false
	if q.y < HEIGHT.x or q.y >= HEIGHT.y:
		return false
	if q.z < DEPTH.x or q.z >= DEPTH.y:
		return false
	return true

func _instance_scene(i):
	var scn = _SCENES[i][0].instantiate()
	if  "heights" in scn:
		scn.heights = _SCENES[i][1]
	return scn

func _set_any_correct_block(dir_idx, height, at_grid_pos):
	#var index = -1
	var rot = 0  # TODO: take unto account rotations
	var pick_list = []
	for i in len(_SCENES):
		if _SCENES[i][1][dir_idx] == height:
			pick_list.append(i)
	if len(pick_list) == 0:
		pick_list = [0]
	pick_list.shuffle()
	var level_block = self._instance_scene(pick_list.pop_front())
	level_block.position = at_grid_pos * BLOCK_DIMENSIONS
	_blocks[at_grid_pos] = level_block
	self.add_child(level_block)
	return level_block.heights if "heights" in level_block else [0,0,0,0]

func _remove_all():
	_checkpoints = _INIT_CHECKPOINTS
	for gp in _blocks.keys():
		#self.remove_child(_blocks[gp])
		_blocks[gp].queue_free()
		_blocks.erase(gp)
	_blocks = {}

func _make_maze():
	var end_point = _checkpoints[-1]

	var visited_grid_pos = {}
	var next_block_list = [ [_checkpoints[0], -1, 0] ]    # grid-pos, last-dir, height

	while len(next_block_list) > 0:
		next_block_list.shuffle()  # a bit slow bit it should be OK
		var current_block = next_block_list.pop_front()
		var grid_pos = current_block[0]
		if grid_pos in visited_grid_pos.keys():
			continue
		var heights = self._set_any_correct_block(current_block[1], current_block[2], grid_pos)
		visited_grid_pos[grid_pos] = _OPPOSITES_MAP[current_block[1]]
		if grid_pos == end_point:
			break
		for j in range(0, 4):
			var next_grid_pos = grid_pos + _SIDES[j]
			if self._within_grid_bounds(next_grid_pos) and not is_nan(heights[j]):
				next_block_list.append( [next_grid_pos, _OPPOSITES_MAP[j], heights[j]] )

	var path_to_end = []

	var rev_path_grid_pos = end_point
	while rev_path_grid_pos in visited_grid_pos:
		path_to_end.append(rev_path_grid_pos)
		
		print(rev_path_grid_pos)
		
		var dir = visited_grid_pos[rev_path_grid_pos]
		if dir < 0 or dir >= 4:
			break
		rev_path_grid_pos += _SIDES[_OPPOSITES_MAP[dir]]
	
	path_to_end.reverse()
	
	return len(path_to_end) > 0

func _ready():
	randomize()
	## TODO: randomize start, finish
	while not self._make_maze():
		self._remove_all()
	## TODO: set (rest of) checkpoints
