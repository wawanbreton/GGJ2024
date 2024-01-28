extends Node3D

@export var audioArray : Array[Resource]

signal test_block_points(points)
var red := 0.0
var next_pos := Vector3(99,99,99)
@onready var _pos := self.position
var points_recieved: bool = false

func _ready():
	if next_pos.y > 98:
		self.rotate_z(TAU*0.25)
		_pos.y += 0.8
	else:
		var diff = self.global_position - next_pos
		self.rotate_y(atan2(-diff.z, diff.x))

	$VisualShape.material_override = StandardMaterial3D.new()
	$VisualShape.material_override.albedo_color = Color(1.0-red, 1.0, red)

func _on_body_entered(body):
	if is_instance_valid(body) and body.name == "Wheelchair":
		$VisualShape.material_override.albedo_color = Color((1.0-red)/2.5, 0.4, red/2.5)
		if (!get_node("AudioStreamPlayer3D").playing) :
			randomize()
			get_node("AudioStreamPlayer3D").stream = audioArray[ randi_range(0,1) ]
			get_node("AudioStreamPlayer3D").play()
			if not points_recieved:
				var global_points_node = get_parent().get_parent().get_node("GlobalVariables")
				global_points_node.update_points(global_points_node.ARROW_POINT_AMOUNT)
				points_recieved = true
			

var time := 0.0
func _process(delta):
	time += delta
	self.position = _pos + Vector3(0,0.5,0) + Vector3(0,1,0) * 0.08 * sin(time + red * 15.0)
