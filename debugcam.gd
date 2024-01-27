extends Camera3D


var input_dir = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_W:
			input_dir.z = -1 if event.pressed else 0
		if event.keycode == KEY_S:
			input_dir.z = 1 if event.pressed else 0
		if event.keycode == KEY_A:
			input_dir.x = -1 if event.pressed else 0
		if event.keycode == KEY_D:
			input_dir.x = 1 if event.pressed else 0
		if event.keycode == KEY_R:
			input_dir.y = 1 if event.pressed else 0
		if event.keycode == KEY_F:
			input_dir.y = -1 if event.pressed else 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position += delta * 5.0 * input_dir
