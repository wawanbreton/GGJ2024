extends Node3D

const _TEST_B_SCN = preload("res://levelblocks/test_block_b.tscn")  # use as marker

const _PRE_SCENES := [
	[preload("res://levelblocks/corner_wall.tscn"), []],
	[preload("res://levelblocks/double_wall.tscn"), []],
	[preload("res://levelblocks/single_wall.tscn"), []],
	[preload("res://obstacles/blocks/block_basic.tscn"), []],
	[preload("res://obstacles/blocks/block_bridge.tscn"), []],
	[preload("res://obstacles/blocks/block_ramp.tscn"), []],
	[preload("res://obstacles/blocks/block_spring.tscn"), []],
]
var _SCENES = []
var _SIDES = [
	Vector3(0,0,1),  # a
	Vector3(1,0,0),  # b
	Vector3(0,0,-1), # c
	Vector3(-1,0,0), # d
]
const _DIF_TO_DIR_MAP := {
	Vector3(1,0,0): 1,
	Vector3(0,0,1): 0,
	Vector3(-1,0,0): 3,
	Vector3(0,0,-1): 2,
}

const WIDTH := Vector2(-1,11)
const HEIGHT := Vector2(0,1)
const DEPTH := Vector2(-1,11)
const BLOCK_DIMENSIONS := Vector3(3.0, 3.0, 3.0)
const NUM_CHECKPOINTS := 3

var _blocks := {}   # Dictionary[Vector3, Node3D]
var _markers := []

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
	if scn.has_method("block_init"):
		scn.block_init()
	if  "heights" in scn:
		scn.heights = _SCENES[i][1]
	scn.rotate_y(_SCENES[i][2] * (TAU * -0.25))
	return scn

func _add_block_at(i, at_grid_pos):
	var level_block = self._instance_scene(i)
	level_block.position = at_grid_pos * BLOCK_DIMENSIONS
	_blocks[at_grid_pos] = level_block
	self.add_child(level_block)
	return level_block

func _set_any_correct_block(last_grid_pos, height, at_grid_pos):
	var pick_list = []
	var dir_idx = last_grid_pos - at_grid_pos
	if dir_idx.length_squared() == 0:
		pass
	else:
		for i in len(_SCENES):
			if _SCENES[i][1][_DIF_TO_DIR_MAP[dir_idx]] == height:
				pick_list.append(i)
	if len(pick_list) == 0:
		pick_list = [0]
	pick_list.shuffle()
	var level_block = self._add_block_at(pick_list.pop_front(), at_grid_pos)
	return level_block.heights if "heights" in level_block else [0,0,0,0]

func _remove_all():
	_checkpoints = _INIT_CHECKPOINTS
	for gp in _blocks.keys():
		_blocks[gp].queue_free()
		_blocks.erase(gp)
	_blocks = {}
	for m in _markers:
		m.queue_free()
	_markers = []

func _make_maze():
	var end_point = _checkpoints[-1]

	var visited_grid_pos = {}
	var next_block_list = [ [_checkpoints[0], _checkpoints[0], 0] ]    # grid-pos, prev-grid-pos, height
	# TODO?: 'solve' for first direction (will go mostly alright now)

	# Random depth-first-search to make paths (and at least one to the end).
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

	# Fill any remaining space with random scenes.
	for iz in range(HEIGHT.x, HEIGHT.y):
		for iy in range(DEPTH.x, DEPTH.y):
			for ix in range(WIDTH.x, WIDTH.y):
				var grid_pos = Vector3(ix, iz, iy)
				if grid_pos.x == 0 and grid_pos.z == 0:
					continue
				if not grid_pos in visited_grid_pos:
					self._add_block_at(randi_range(0, len(_SCENES)-1), grid_pos)

	# Backtrace to the beginning to get the(/one possible) path.
	var path_to_end = []
	var rev_path_grid_pos = end_point
	while rev_path_grid_pos in visited_grid_pos:
		path_to_end.append(rev_path_grid_pos)
		var last = rev_path_grid_pos
		rev_path_grid_pos = visited_grid_pos[rev_path_grid_pos]
		if last == rev_path_grid_pos:
			break
	path_to_end.reverse()

	if len(path_to_end) <= 0:
		return path_to_end

	# Set checkpoints.
	var next_check_when = len(path_to_end) / 4
	var check_pts = []
	var checkpt_strs = ["Checkpoint1", "Checkpoint2", "CheckpointFinal"]
	for i in range(1,4):  # '0' would be the start, which is a strange place for a checkpt.
		var check_node = self.get_parent().get_node(checkpt_strs[i - 1])
		if check_node:
			check_node.global_position = (path_to_end[i*next_check_when] + Vector3(0.0, 0.5, 0.0)) * Vector3(3, 3, 3)

	return path_to_end

func _mark_path(path_to_end):
	path_to_end.reverse() # hacky
	var fli = -1
	var next_pos = null
	for grid_pos in path_to_end:
		fli += 1
		var marker = _TEST_B_SCN.instantiate()
		marker.red = 1.0 - ((1.0 / len(path_to_end)) * fli)
		marker.position = grid_pos * BLOCK_DIMENSIONS
		if next_pos != null:
			marker.next_pos = next_pos
		self.add_child(marker)
		_markers.append(marker)
		next_pos = marker.position
	path_to_end.reverse() # un-hacky

func _rotate_array(arr):
	return [ arr[1], arr[2], arr[3], arr[0] ]

func reset():
	randomize()
	# TODO??: randomize start, finish
	var path_to_end = []
	while len(path_to_end) <= 0:
		self._remove_all()
		path_to_end = self._make_maze()
	self._mark_path(path_to_end)

func _ready():
	for scn in _PRE_SCENES:
		var hts = []
		if len(scn[1]) <= 0:
			var inst = scn[0].instantiate()
			hts = inst.heights
			inst.queue_free()
		else:
			hts = scn[1]
		_SCENES.append([scn[0],hts,0])
	var really_all_scenes = []
	for scn in _SCENES:
		really_all_scenes.append(scn)
		var next_heights = scn[1]
		for i in range(1, 4):  # already added the 0th one, so starting from '1'
			next_heights = self._rotate_array(next_heights)
			really_all_scenes.append([scn[0], next_heights, i])
	_SCENES = really_all_scenes

	reset()
