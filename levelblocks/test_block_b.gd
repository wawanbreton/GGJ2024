extends Node3D

@export var audioArray : Array[Resource]

var red := 0.0

func _ready():
	$VisualShape.material_override = StandardMaterial3D.new()
	$VisualShape.material_override.albedo_color = Color(1.0-red, red, red)

func _on_body_entered(body):
	if is_instance_valid(body) and body.name == "Wheelchair":
		#self.queue_free()
		$VisualShape.material_override.albedo_color = Color(0.5, 0.5, 0.5)
		if (!get_node("AudioStreamPlayer3D").playing) :
			randomize()
			get_node("AudioStreamPlayer3D").stream = audioArray[ randi_range(0,1) ]
			get_node("AudioStreamPlayer3D").play()
