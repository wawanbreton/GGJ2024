extends Node3D

const _TEST_A_SCN = preload("res://levelblocks/test_block_a.tscn")
const _TEST_B_SCN = preload("res://levelblocks/test_block_b.tscn")  # use as marker

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
const _DIF_TO_DIR_MAP := {
	Vector3(1,0,0): 0,
	Vector3(0,0,1): 1,
	Vector3(-1,0,0): 2,
	Vector3(0,0,-1): 3,
}

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

func _set_any_correct_block(last_grid_pos, height, at_grid_pos):
	var rot = 0  # TODO: take into account rotations
	var pick_list = []
	var dir_idx = last_grid_pos - at_grid_pos
	if dir_idx.length_squared() == 0:
		pass
	else:
		for i in len(_SCENES):
			if _SCENES[i][1][_DIF_TO_DIR_MAP[dir_idx]] == height:   # TODO?: go on _approximate_ heights
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
		_blocks[gp].queue_free()
		_blocks.erase(gp)
	_blocks = {}

func _make_maze():
	var end_point = _checkpoints[-1]

	var visited_grid_pos = {}
	var next_block_list = [ [_checkpoints[0], _checkpoints[0], 0] ]    # grid-pos, prev-grid-pos, height
	# TODO?: 'solve' for first direction (will go mostly alright now)

	while len(next_block_list) > 0:
		next_block_list.shuffle()  # a bit slow bit it should be OK
		var current_block = next_block_list.pop_front()
		var grid_pos = current_block[0]
		if grid_pos in visited_grid_pos.keys():
			continue
		var heights = self._set_any_correct_block(current_block[1], current_block[2], grid_pos)
		visited_grid_pos[grid_pos] = current_block[1]
		if grid_pos == end_point:
			break
		for j in range(0, 4):
			var next_grid_pos = grid_pos + _SIDES[j]
			if self._within_grid_bounds(next_grid_pos) and not is_nan(heights[j]):
				next_block_list.append( [next_grid_pos, current_block[0], heights[j]] )

	var path_to_end = []
	var rev_path_grid_pos = end_point
	while rev_path_grid_pos in visited_grid_pos:
		path_to_end.append(rev_path_grid_pos)
		var last = rev_path_grid_pos
		rev_path_grid_pos = visited_grid_pos[rev_path_grid_pos]
		if last == rev_path_grid_pos:
			break
	path_to_end.reverse()

	return path_to_end

func _debug_mark_path(path_to_end):
	for grid_pos in path_to_end:
		var marker = _TEST_B_SCN.instantiate()
		marker.position = grid_pos * BLOCK_DIMENSIONS
		self.add_child(marker)

func _ready():
	randomize()
	## TODO: randomize start, finish
	var path_to_end = []
	while len(path_to_end) <= 0:
		self._remove_all()
		path_to_end = self._make_maze()
	#self._debug_mark_path(path_to_end)
	## TODO: set (rest of) checkpoints
