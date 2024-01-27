extends Node3D


@export var wallImages : Array[Resource];

var rng : RandomNumberGenerator;
var rndInt : int;

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new();
	rndInt = rng.randi_range(0,wallImages.size() -1);
	var stdMat3d = StandardMaterial3D.new();
	stdMat3d.albedo_texture = wallImages[rndInt];
#	$StaticBody3D/CSGBox3D.material_override.albedo_color = col
	$StaticBody3D/CSGBox3D.material_override = stdMat3d;

func set_color(col):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_crash_sound_area_body_entered(body):
	$AudioStreamCrashes.play_random()
