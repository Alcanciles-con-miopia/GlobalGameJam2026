extends Timer

@onready var TimerLabel: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = get_time_left()

	if(time > 0):
		var seconds:float = fmod(time , 60.0)
		var minutes:int   =  int(time / 60.0) % 60
		var hours:  int   =  int(time / 3600.0)
		var hhmmss_string:String = "%02d:%05.2f" % [minutes, seconds]
		TimerLabel.set_text(hhmmss_string)
	pass

func _on_timeout() -> void:
	#print_debug("timer")
	pass # Replace with function body.
