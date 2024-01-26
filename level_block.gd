extends Node3D

const _SCENES := [
	preload("res://levelblocks/test_block_a.tscn"),
	preload("res://levelblocks/test_block_b.tscn"),
]

var _obj = null

func _pick_scene():
	var pick = randi_range(0, len(_SCENES)-1)
	_obj = _SCENES[pick].instantiate()
	self.add_child(_obj)

func _ready():
	self._pick_scene()

func get_heights():
	# TODO: We can maybe rotate the object, so a ramp doesn't have to be drawn 4x
	return _obj.get_heights()

func _process(_delta):
	pass
