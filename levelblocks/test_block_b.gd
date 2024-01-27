extends Node3D

var red := 0.0

func _ready():
	$VisualShape.material_override = StandardMaterial3D.new()
	$VisualShape.material_override.albedo_color = Color(1.0-red, red, red)


func _on_body_entered(body):
	if is_instance_valid(body) and body.name == "Frame":
		self.queue_free()
