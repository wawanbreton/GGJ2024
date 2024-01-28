extends Node3D

var WheelChair = preload("res://WheelChair.tscn")
@onready var audio_stream_lose = $Camera3D/AudioStreamLose
@onready var global_variables = $GlobalVariables
@onready var audio_stream_win = $Camera3D/AudioStreamWin


var first = true

func _ready():
	get_node("Checkpoint1").checked_changed.connect(Callable(self, "_on_checkpoint_checked_changed").bind(get_node("Checkpoint2")))
	get_node("Checkpoint2").checked_changed.connect(Callable(self, "_on_checkpoint_checked_changed").bind(get_node("CheckpointFinal")))
	get_node("CheckpointFinal").checked_changed.connect(Callable(self, "_on_checkpoint_checked_changed").bind(null))

func _on_control_start_new_game():
	if not first:
		self.get_node("Level").reset()
	first = false

	var wheelchair = self.get_node("Wheelchair") # This issues a warning but find_type won't work
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
	get_node("HUD").swipe.connect(Callable(wheelchair, "send_motor_power"))
	wheelchair.add_child(lookup_node)
	add_child(wheelchair)
	
	get_node("Checkpoint1").checked = false
	get_node("Checkpoint1").get_node("MeshInstance3D/Label3D").text = "1"
	get_node("Checkpoint2").checked = false
	get_node("Checkpoint2").get_node("MeshInstance3D/Label3D").text = "2"
	get_node("CheckpointFinal").checked = false
	get_node("CheckpointFinal").get_node("MeshInstance3D/Label3D").text = "3"
	
	get_node("Menu").visible = false
	get_node("HUD").visible = true
	get_node("HUD").start_countdown()
	
	trigger_music_muffle(false)

func _on_hud_countdown_over():
	get_node("Wheelchair").active = true
	get_node("Checkpoint1").active = true

func _on_checkpoint_checked_changed(checked, next_checkpoint):
	if checked:
		global_variables.update_points(global_variables.CHECKPOINT_AMOUNT)
		if next_checkpoint:
			next_checkpoint.active = true
		else:
			self._on_game_ended(true, get_node("HUD").get_time())

func _on_wheelchair_tilt():
	self._on_game_ended(false, get_node("HUD").get_time())

func _on_game_ended(win:bool,time):

	trigger_music_muffle(true)
	if win:
		audio_stream_win.play_in_order()
		Input.vibrate_handheld(1000)
	else:
		audio_stream_lose.play_in_order()
		Input.vibrate_handheld(1000)
	get_node("Wheelchair").active = false
	get_node("HUD").visible = false
	get_node("Menu").set_score(win, time, global_variables.points)
	get_node("Menu").visible = true


func trigger_music_muffle(is_muffle:bool):
	var bus_index = AudioServer.get_bus_index("Losing")

	AudioServer.set_bus_effect_enabled(bus_index,0,is_muffle)
	AudioServer.set_bus_effect_enabled(bus_index,1,is_muffle)
	AudioServer.set_bus_effect_enabled(bus_index,2,is_muffle)
