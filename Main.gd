extends Node3D

var WheelChair = preload("res://WheelChair.tscn")


func _ready():
    get_node("Checkpoint1").checked_changed.connect(Callable(self, "_on_checkpoint_checked_changed").bind(get_node("Checkpoint2")))
    get_node("Checkpoint2").checked_changed.connect(Callable(self, "_on_checkpoint_checked_changed").bind(get_node("CheckpointFinal")))
    get_node("CheckpointFinal").checked_changed.connect(Callable(self, "_on_checkpoint_checked_changed").bind(null))

func _on_control_start_new_game():
    var wheelchair = get_node("Wheelchair")
    var lookup_node = null
    if wheelchair:
        lookup_node = wheelchair.get_node('Lookup')
        wheelchair.remove_child(lookup_node)
        remove_child(wheelchair)
        wheelchair.queue_free()
    else:
        lookup_node = get_node('Lookup')
        remove_child(lookup_node)
    
    wheelchair = WheelChair.instantiate()
    wheelchair.name = "Wheelchair"
    wheelchair.tilt.connect(_on_wheelchair_tilt)
    wheelchair.add_child(lookup_node)
    add_child(wheelchair)
    
    get_node("Checkpoint1").checked = false
    get_node("Checkpoint2").checked = false
    get_node("CheckpointFinal").checked = false
    
    get_node("Menu").visible = false
    get_node("HUD").visible = true
    get_node("HUD").start_countdown()

func _on_hud_countdown_over():
    get_node("Wheelchair").active = true
    get_node("Checkpoint1").active = true

func _on_checkpoint_checked_changed(checked, next_checkpoint):
    if checked:
        if next_checkpoint:
            next_checkpoint.active = true
        else:
            self._on_game_ended(get_node("HUD").get_score())
            
func _on_wheelchair_tilt():
    self._on_game_ended(null)

func _on_game_ended(score):
    get_node("Wheelchair").active = false
    get_node("HUD").visible = false
    get_node("Menu").set_score(score)
    get_node("Menu").visible = true
