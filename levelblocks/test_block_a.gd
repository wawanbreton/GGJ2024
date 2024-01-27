extends Node3D

const _WALL_SCN := preload("res://levelblocks/test_wall.tscn")

var _sides = [
	Vector3(1,0,0),
	Vector3(0,0,1),
	Vector3(-1,0,0),
	Vector3(0,0,-1),
]
var _rotations = [
	0,
	TAU * 0.25,
	TAU * 0.50,
	TAU * 0.75,
]

var heights = [0,0,0,0]

func _ready():
	for i in len(heights):
		#print(i)
		if is_nan(heights[i]):
			var wall = _WALL_SCN.instantiate()
			wall.position += 1.45 * _sides[i]
			wall.rotate_y(_rotations[i])
			self.add_child(wall)
