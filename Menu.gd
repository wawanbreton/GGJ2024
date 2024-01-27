extends Control

signal start_new_game

func _on_button_pressed():
    emit_signal('start_new_game')

func set_score(score):
    get_node("LabelScore").text = "Your time : %s" % score
    get_node("LabelScore").visible = true
