extends Node3D

const _WALL_SCN := preload("res://levelblocks/test_wall.tscn")

var _sides = [
	Vector3(1,0,0),
	Vector3(0,0,1),
	Vector3(-1,0,0),
	Vector3(0,0,-1),
]
var _rotations = [
	TAU * 0.25,
	0,
	TAU * 0.75,
	TAU * 0.50,
]

var heights = [0,0,0,0]

func _ready():
	var rand_col = Color(randf(), randf(), randf())
	for i in len(heights):
		if is_nan(heights[i]):
			var wall = _WALL_SCN.instantiate()
			wall.set_color(rand_col)
			wall.rotate_y(_rotations[i])
			wall.position += 1.35 * _sides[i]  #  should be nearly 1.5 x
			self.add_child(wall)
