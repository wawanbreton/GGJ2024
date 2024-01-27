extends Node3D

@export var poll_scene: PackedScene
@export var number_of_polls: int = 3
@export var poll_group_width: float = 1.0
@export_enum("Easy", "Medium", "Hard") var difficulty: String

var hyp: float
var poll_position: Vector3

func _ready():
	match difficulty:
		"Easy":
			hyp = 2
		"Medium":
			hyp = 1.6
		"Hard":
			hyp = 1.3
	
	for n in number_of_polls:
		
		var sign
		if n % 2 == 1: sign = 1# odd
		elif n % 2 == 0: sign = -1 #even 
		
		var x: float = sign*poll_group_width/2
		var y: float = position.y
		var z: float = (sqrt(pow(hyp,2)-pow(poll_group_width,2)))*n*sign
		poll_position = Vector3(x,y,z)
		print(poll_position)
		create_poll(poll_position)


func create_poll(poll_position):
	var poll_instance: Node3D = poll_scene.instantiate()
	add_child(poll_instance)
	poll_instance.position = poll_position
