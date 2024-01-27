extends Node3D

func _on_control_start_new_game():
    get_node("Menu").visible = false
    get_node("HUD").visible = true
    get_node("HUD").start_countdown()


func _on_hud_countdown_over():
    get_node("Wheelchair").active = true
