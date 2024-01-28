extends Control

@export var global_points: Node
@onready var label_time = $LabelTime
@onready var label_points = $LabelPoints
@onready var label_win = $LabelWin
@onready var label_defeat = $LabelDefeat



signal start_new_game

func _ready():
	label_win.visible = false
	label_defeat.visible = false
	label_time.visible = false
	label_points.visible = false

func _on_button_pressed():
	emit_signal('start_new_game')

func set_score(win, time, points):
	print(win)
	#get_node("LabelScore").text = "Your time : %s" % time
	label_time.visible = true
	label_time.text = "Time : %s" % time
	label_points.visible = true
	label_points.text = "Points : %s" % points
	if win:
		label_win.visible = true
	else:
		label_defeat.visible = true
	#get_node("LabelScore").visible = score != global_points.points
	#get_node("LabelDefeat").visible = score == global_points.points
