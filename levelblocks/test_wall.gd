extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_color(col):
	$StaticBody3D/CSGBox3D.material_override = StandardMaterial3D.new()
	$StaticBody3D/CSGBox3D.material_override.albedo_color = col

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
