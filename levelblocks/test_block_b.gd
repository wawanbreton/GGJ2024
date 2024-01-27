extends StaticBody3D

var red := 0.0

func _ready():
	$CollisionShape3D/VisualShape.material_override = StandardMaterial3D.new()
	$CollisionShape3D/VisualShape.material_override.albedo_color = Color(red, 0, 0)
