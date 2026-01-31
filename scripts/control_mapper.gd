extends Node3D
class_name ControlMapper

#@onready var ui: Control = $"../ui"
@export var ui : Control

var cursors := {}

func _ready() -> void:
	Input.joy_connection_changed.connect(_connection_changed)

func _input(event: InputEvent) -> void:
	if (event is InputEventJoypadMotion or event is InputEventJoypadButton) and event.device not in cursors:
		print("INPUT")
		_add_pad(event.device)

func _connection_changed(deviceid := -1, connected := false):
	if deviceid not in cursors and len(cursors) < 2 and connected:
		_add_pad(deviceid)
	else:
		_remove_pad(deviceid)

func _add_pad(deviceid:=-1):
	if deviceid != -1:
		print("ANYADE MANDO: ", deviceid)
		cursors[deviceid] = Cursor.new()
		cursors[deviceid].DeviceID = deviceid
		cursors[deviceid].setColor(Color.BLUE if len(cursors) ==1 else Color.RED)
		ui.add_child(cursors[deviceid])

func _remove_pad(deviceid:=-1):
	if deviceid != -1 and deviceid in cursors:
		print("QUITA MANDO")
		var dev = cursors[deviceid]
		dev.vibrate(0.5)
		dev.queue_free()
		cursors.erase(deviceid)
