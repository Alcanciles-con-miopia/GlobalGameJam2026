extends Node3D

var Gyro=SDLGyro.new()

var _time_to_calibrate := 2
var _elapsed_time := 0

var _last_rotation

#Cursor

var _calibrating = false

func _ready() -> void:
	# Inicializacion del plugin
	Gyro.sdl_init()
	Gyro.controller_init()

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.is_action_pressed("A"):
		_calibrate()

func _process(delta: float) -> void:
	var rotation = Gyro.gamepad_polling()
	print( snappedf(rotation.x, 0.01), " ", snappedf(rotation.y, 0.01), " ", snappedf(rotation.z, 0.01))
	if rotation != _last_rotation:
		_last_rotation = rotation
		_elapsed_time = 0
	else:
		_elapsed_time += delta
	
	if _elapsed_time >= _time_to_calibrate:
		_calibrate()

func _calibrate() ->void:
	print("Calibrate")
	Gyro.calibrate()
	Gyro.stop_calibrate()
	
