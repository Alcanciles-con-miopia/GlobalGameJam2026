extends Node3D
class_name ControlMapper

#@onready var ui: Control = $"../ui"
@export var ui : Control
#@export var selectScene : Node

var cursors : Array = [null, null]

func _ready() -> void:
	Input.joy_connection_changed.connect(_connection_changed)
	Global.cursors = cursors

func _input(event: InputEvent) -> void:
	if (event is InputEventJoypadMotion or event is InputEventJoypadButton):
		var objid = -1
		for id in range(len(cursors)):
			if not cursors[id] or cursors[id].DeviceID == -1: 
				objid = id
				continue
			if event.device == cursors[id].DeviceID:
				objid = -1 
				break
		if objid != -1:
			_add_pad(event.device, objid)

func _connection_changed(deviceid := -1, connected := false):
	for id in range(len(cursors)):
		if not cursors[id] or cursors[id].DeviceID != -1: continue
		if deviceid != cursors[id].DeviceID and connected:
			_add_pad(deviceid, id)
		elif deviceid == cursors[id].DeviceID and not connected:
			_remove_pad(deviceid, id)

func _add_pad(deviceid:=-1, id = -1):
	if deviceid != -1:
		print("ANYADE MANDO: ", deviceid)
		cursors[id] = Cursor.new()
		cursors[id].DeviceID = deviceid
		cursors[id].setColor(Color.BLUE if id == 0 else Color.RED)
		ui.add_child(cursors[id])

func _remove_pad(deviceid:=-1, id = -1):
	if deviceid != -1 and deviceid in cursors:
		print("QUITA MANDO")
		var dev = cursors[id]
		dev.vibrate(0.5)
		dev.queue_free()
		cursors.erase(id)
