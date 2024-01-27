extends Control

var _countdown = 0
var _time_start = 0

signal countdown_over

func start_countdown():
    self._countdown = 4
    
    get_node("LabelTime").visible = false
    get_node("LabelStartCount").visible = true
    self._update_countdown()
    
    get_node("TimerCountdown").start()
    
func get_score():
    return get_node("LabelTime").text

func _process(_delta):
    var elapsed = Time.get_ticks_msec() - self._time_start
    
    var minutes = int(elapsed / 60000)
    var seconds = int(elapsed / 1000) % 60
    get_node("LabelTime").text = "%s:%s" % [str(minutes).lpad(2, '0'), str(seconds).lpad(2, '0')]
    
func _update_countdown():
    self._countdown -= 1
    get_node("LabelStartCount").text = str(self._countdown)

func _on_timer_timeout():
    self._update_countdown()
    
    if self._countdown == 0:
        _time_start = Time.get_ticks_msec()
        get_node("TimerCountdown").stop()
        get_node("LabelTime").visible = true
        get_node("LabelStartCount").visible = false
        emit_signal("countdown_over")
