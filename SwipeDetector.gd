extends Control

signal swipe(key, power)

@export var key = ""

var _time_last = 0
var _pos_last = Vector2()
var _index = -1

func _input(event):
	if event is InputEventScreenTouch and self.get_rect().has_point(event.position):
		if event.pressed:
			self._time_last = Time.get_ticks_usec()
			self._pos_last = event.position
			self._index = event.index
		else:
			self._send_swipe(event)
			self._index = -1
	elif event is InputEventScreenDrag and event.index == self._index:
		self._send_swipe(event)

func _send_swipe(event):
	var pos_delta = (event.position - self._pos_last).y
	var time_delta = Time.get_ticks_usec() - self._time_last
	
	swipe.emit(self.key, -(pos_delta / time_delta) * 1000)
	
	self._time_last = Time.get_ticks_usec()
	self._pos_last = event.position
