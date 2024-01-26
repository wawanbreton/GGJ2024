extends Node3D

const level_block_scn = preload("res://level_block.tscn")

const WIDTH := Vector2(-10,11)
const DEPTH := Vector2(-10,11)
const HEIGHT := Vector2(-3,4)

const BLOCK_DIMENSIONS := Vector3(2.0, 2.0, 2.0)

#var _blocks: Dictionary[Vector3, Node3D] = {}
var _blocks := {}

func _make_maze():
	randomize()
	for iw in range(WIDTH.x, WIDTH.y):
		for id in range(DEPTH.x, DEPTH.y):
			for ih in range(HEIGHT.x, HEIGHT.y):
				if iw in [-1,0,1] and id in [-1,0,1] and ih in [-1,0,1]:
					continue
				if randf() < 0.34:
					var grid_pos = Vector3(iw,id,ih)
					var level_block = level_block_scn.instantiate()
					level_block.position = grid_pos * BLOCK_DIMENSIONS
					_blocks[grid_pos] = level_block
					self.add_child(level_block)

func _ready():
	self._make_maze()

#func _process(_delta):
#	pass
