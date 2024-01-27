extends Node3D

func _ready():
    get_node("Checkpoint1").checked_changed.connect(Callable(self, "_on_checkpoint_checked_changed").bind(get_node("Checkpoint2")))
    get_node("Checkpoint2").checked_changed.connect(Callable(self, "_on_checkpoint_checked_changed").bind(get_node("CheckpointFinal")))
    get_node("CheckpointFinal").checked_changed.connect(Callable(self, "_on_checkpoint_checked_changed").bind(null))

func _on_control_start_new_game():
    get_node("Wheelchair").position = Vector3(0, 0, 0)
    get_node("Menu").visible = false
    get_node("HUD").visible = true
    get_node("HUD").start_countdown()

func _on_hud_countdown_over():
    get_node("Wheelchair").active = true
    get_node("Checkpoint1").active = true

func _on_checkpoint_checked_changed(next_checkpoint):
    if next_checkpoint:
        next_checkpoint.active = true
    else:
        get_node("Wheelchair").active = false
        get_node("HUD").visible = false
        get_node("Menu").set_score(get_node("HUD").get_score())
        get_node("Menu").visible = true
