extends Node3D

var red := 0.0

func _ready():
	$VisualShape.material_override = StandardMaterial3D.new()
	$VisualShape.material_override.albedo_color = Color(red, 0, 0)
