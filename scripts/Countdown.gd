extends Timer

@onready var TimerLabel: Label = $Label

func _process(delta: float) -> void:
	var time = get_time_left()

	if(time > 0):
		var seconds:float = fmod(time , 60.0)
		var minutes:int   =  int(time / 60.0) % 60
		#TimerLabel.text = "%02d.%02d" % [seconds, centesimas]
		var hhmmss_string:String = "%05.2f" % [seconds]
		TimerLabel.text = hhmmss_string
	else:
		if time<5:
			for c in Global.cursors:
				Input.start_joy_vibration(c.DeviceID, 5- time, 5- time,0.1)
		TimerLabel.text = "00:00"
