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
	if DeviceID == -1:
		return

	var x_ax = Input.get_joy_axis(DeviceID, JOY_AXIS_LEFT_X)
	var y_ax = Input.get_joy_axis(DeviceID, JOY_AXIS_LEFT_Y)

	var input_vec = Vector2(x_ax, y_ax)
	var strength = input_vec.length()

	if strength < 0.4:
		return

	var direction = input_vec.normalized()

	var speed_factor := 1.0
	if strength < 0.7:
		speed_factor = 0.25
	elif strength < 0.95:
		speed_factor = 0.5
	else:
		speed_factor = 1.0

	var vectorMovible = direction * vel * speed_factor * delta
	var newpos = position + vectorMovible

	newpos.x = clamp(newpos.x, 0, get_viewport().size.x)
	newpos.y = clamp(newpos.y, 0, get_viewport().size.y)

	position = newpos
	Global.on_cursor_move.emit(position, DeviceID)

	#print_debug(Global.cursors[0])
	#print("AA: ", DeviceID, " vector: ", direction)
