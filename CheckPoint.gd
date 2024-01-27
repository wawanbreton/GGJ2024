extends Area3D


@export var checked: bool : get = get_checked, set = set_checked
signal checked_changed

@export var active: bool = false

func get_checked():
    return !get_node("MeshInstance3D").visible

func set_checked(new_checked):
    if new_checked && get_node("MeshInstance3D").visible:
        get_node("MeshInstance3D").visible = false
        emit_signal("checked_changed")

func _on_body_entered(body):
    if self.active:
        self.checked = true
