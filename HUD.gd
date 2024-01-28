extends Control

var _countdown = 0
var _time_start = 0
@onready var label_time = $%LabelTime
@onready var label_points = %LabelPoints
@onready var label_start_count = %LabelStartCount
@export var global_points: Node

signal countdown_over

func start_countdown():
	self._countdown = 4
	label_points.visible = false
	label_time.visible = false
	label_start_count.visible = true
	self._update_countdown()
	
	get_node("TimerCountdown").start()
	
func get_time():
	return label_time.text

func _process(_delta):
	var elapsed = Time.get_ticks_msec() - self._time_start
	
	var minutes = int(elapsed / 60000)
	var seconds = int(elapsed / 1000) % 60
	label_time.text = "%s:%s" % [str(minutes).lpad(2, '0'), str(seconds).lpad(2, '0')]
	
func _update_countdown():
	self._countdown -= 1
	label_start_count.text = str(self._countdown)

func _on_timer_timeout():
	self._update_countdown()
	
	if self._countdown == 0:
		_time_start = Time.get_ticks_msec()
		get_node("TimerCountdown").stop()
		label_time.visible = true
		label_points.visible = true
		global_points.points = 0
		label_points.text = str(global_points.points)
		label_start_count.visible = false
		emit_signal("countdown_over")
