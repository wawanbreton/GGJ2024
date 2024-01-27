extends StaticBody3D

func _ready():
	$CollisionShape3D/VisualShape.material_override = StandardMaterial3D.new()
	$CollisionShape3D/VisualShape.material_override.albedo_color = Color(randf(), randf(), randf())

func _process(_delta):
	pass

func get_connect_heights() -> Array[float]:
	return [NAN, NAN, NAN, NAN]
