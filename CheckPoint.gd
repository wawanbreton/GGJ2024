extends Area3D


@export var checked: bool : get = get_checked, set = set_checked
signal checked_changed(bool)

@export var active: bool = false

func get_checked():
	return !get_node("MeshInstance3D").visible

func set_checked(new_checked):
	if new_checked != self.checked:
		get_node("MeshInstance3D").visible = !new_checked
		emit_signal("checked_changed", new_checked)
		if (!get_node("AudioStreamPlayer3D").playing) :
			get_node("AudioStreamPlayer3D").play()

func _on_body_entered(_body):
	if self.active:
		self.checked = true

func _process(delta):
	self.rotate_y(delta * 0.55)
