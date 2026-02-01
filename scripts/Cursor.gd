extends TextureRect
class_name Cursor

var DeviceID := -1

const MANO_ABIERTA = preload("res://assets/images/mano_abierta.png")
const MANO_CERRADA = preload("res://assets/images/mano_cerrada.png")

var direction : Vector2
var vel := 1000

func _ready() -> void:
	texture = MANO_ABIERTA
	vibrate(0.2)


func setColor(color):
	set_modulate(color);

func vibrate(time:= 0.1):
	if DeviceID == -1: return
	Input.start_joy_vibration(DeviceID, 1, 1 ,time)

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.is_action_pressed("A") and event.device == DeviceID:
		texture = MANO_CERRADA
		# LANZAR RAYCAST ANDRES AQUI
		#print_debug("CURSOR CLICK")
		Global.on_cursor_click.emit(event, position + Vector2(20, 20), DeviceID)
		#Global.on_cursor_click.emit()

	elif event is InputEventJoypadButton and event.is_action_released("A") and event.device == DeviceID:
		texture = MANO_ABIERTA
		
	#if event is InputEventJoypadMotion and event.is_action("right_trigger") and event.device == DeviceID:
		#vel += vel_factor
		#print("vel factor")
	#elif event is InputEventJoypadMotion and event.is_action("left_trigger") and event.device == DeviceID:
		#vel -= vel_factor
		#print("vel factor")

func _physics_process(delta: float) -> void:
	if DeviceID == -1: return
	var x_ax = Input.get_joy_axis(DeviceID, JOY_AXIS_LEFT_X)
	x_ax = x_ax if abs(x_ax) >= 0.4 else 0
	var y_ax = Input.get_joy_axis(DeviceID, JOY_AXIS_LEFT_Y)
	y_ax = y_ax if abs(y_ax) >= 0.4 else 0
	direction = Vector2(x_ax, y_ax)
	var vectorMovible = direction * vel * delta
	#print("SSSSSSSSSS", x_ax, ",", y_ax)
	vectorMovible.x = vectorMovible.x/4 if abs(x_ax) < 0.7 else (vectorMovible.x/2 if abs(x_ax)<0.95 else vectorMovible.x)
	vectorMovible.y = vectorMovible.y/4 if abs(y_ax) < 0.7 else (vectorMovible.y/2 if abs(y_ax)<0.95 else vectorMovible.y)
	#print("EEEEEEEEE", vectorMovible)
	var newpos = position + vectorMovible 
	newpos.x = min(get_viewport().size.x, newpos.x)
	newpos.x = max(0, newpos.x)
	newpos.y = min(get_viewport().size.y, newpos.y)
	newpos.y = max(0, newpos.y)
	position = newpos
	Global.on_cursor_move.emit(position, DeviceID)
	#print_debug(Global.cursors[0])
	#print("AA: ", DeviceID, " vector: ", direction)
