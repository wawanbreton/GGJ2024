extends Control

signal start_new_game

func _ready():
	get_node("LabelScore").visible = false
	get_node("LabelDefeat").visible = false

func _process(_delta):
	if (visible && get_node("Button").visible && Input.get_action_strength("ui_accept") > 0) :
		emit_signal('start_new_game')
	if ( Input.get_action_strength("Reset") > 0 ) :
		emit_signal('start_new_game')

func _on_button_pressed():
	emit_signal('start_new_game')

func set_score(score):
	get_node("LabelScore").text = "Your time : %s" % score
	get_node("LabelScore").visible = score != null
	get_node("LabelDefeat").visible = score == null
