extends Node

var cam: Camera3D = null
var dif
const RAY_LENGTH = 100000.0

var mode: int = 1
var scaleChange: float = 1.0

var dragging := false
var drag_start_mouse := Vector2.ZERO
var drag_start_transform: Transform3D

var current_bone = null
var last_cursor_pos_p1 : Vector2
var last_cursor_pos_p2 : Vector2
var owned_by_player = 0 

var asociated_cursor = null

# Start.
func _ready():
	#cam = get_tree().get_first_node_in_group("game_camera") as Camera3D
	cam = $"../../../..".getCamRef()
	if cam == null:
		cam = get_tree().get_first_node_in_group("game_camera") as Camera3D
		if cam == null:
			print_debug("DraggableObject: no se encontró ninguna Camera3D en el grupo 'game_camera'")
	dif = $"../".global_position - self.global_position
	
	Global.on_cursor_click.connect(_cursor_click)
	Global.on_cursor_move.connect(_cursor_move)
	pass
	
# Update.
func _process(_delta):
	pass





# VERSIÓN MANDO:
func raycast_cursor(cursor_pos):
	var spaceState = cam.get_world_3d().direct_space_state
	var origin = cam.project_ray_origin(cursor_pos)
	var end = origin + cam.project_ray_normal(cursor_pos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = spaceState.intersect_ray(query)
	result = result.get("collider")
	print(result)
	return result
	
func _cursor_click(e, cursor_pos, device_id):
	#print_debug("CURSOR CLICK ON DRAGGABLE?")
	#raycast_cursor(cursor_pos)
	
	if e is InputEventJoypadButton and e.button_index == JOY_BUTTON_A:
		if e.pressed:
			var collider = raycast_cursor(cursor_pos)
			if collider == self:
				Global.draggingSomething = self
				dragging = true
				Global.sound.set_sfx_volume_db(30)
				Global.sound.play_sfx("susi_scale", true)
				drag_start_mouse = cursor_pos
				drag_start_transform = $"../".global_transform
				print("Arrastrando:", self)
				for c in Global.cursors:
					if c.DeviceID == e.device:
						asociated_cursor = c
						return
		else:# Soltar click
			dragging = false
			asociated_cursor = null
			if Global.draggingSomething == self:
				Global.draggingSomething = null
	pass
	
func _cursor_move(cursor_pos, device_id):
	match device_id:
		0:
			last_cursor_pos_p1 = cursor_pos
		1:
			last_cursor_pos_p2 = cursor_pos
	pass
	
func _handle_cursor_drag(cursor_delta : Vector2):
	var parent := $"../" as Node3D
	if parent == null:
		return

	match mode:
		1: # MOVER
			parent.global_position += Vector3(
				cursor_delta.x * 0.01,
				-cursor_delta.y * 0.01,
				0.0
			)

		2: # ROTAR
			parent.rotate_y(cursor_delta.x * 0.01)

		3: # ESCALAR
			var factor := 1.0 + cursor_delta.y * 0.005
			parent.scale *= Vector3.ONE * factor
	
func _input(event):
	#if event is InputEventJoypadMotion:
		#print_debug(Global.cursors[event.device])
		
	if event is InputEventJoypadButton and event.is_action_released("A"):
		dragging = false
		asociated_cursor = null
		if Global.draggingSomething == self:
			Global.draggingSomething = null
			

	pass

func _physics_process(delta: float) -> void:
	if not asociated_cursor or not dragging: return
	#SNAPEANDO POSICION
	var parent := $"../" as Node3D
	if parent == null:
		return
	#print_debug(asociated_cursor)
	var origin = cam.project_ray_origin(asociated_cursor.position)
	var end = origin + cam.project_ray_normal(asociated_cursor.position) * RAY_LENGTH
	end.z = parent.global_position.z
	parent.global_position = end
	
	print(parent.global_position)
	#var delt = 0
	#asociated_cursor.position - last_cursor_pos_p1
	#else:
		#delta = Global.cursors[1].position - last_cursor_pos_p2
		#print_debug("DELTA: ", delta, " DEVICE: ", event.device)
		#_handle_cursor_drag(delta)
	
	
	## CALCULAR DELTA DEL CURSOR NO FUNCIONA
	#var delta = 0
	#if event.device == 0:
		#delta = Global.cursors[0].position - last_cursor_pos_p1
	#else:
		#delta = Global.cursors[1].position - last_cursor_pos_p2
	#print_debug("DELTA: ", delta, " DEVICE: ", event.device)
	#_handle_cursor_drag(delta)


	
	
	
	
	
	
	
	
	
	
	
	
	
# VERSION RATÓN:
func raycast():
	var spaceState = cam.get_world_3d().direct_space_state
	var mousePos = cam.get_viewport().get_mouse_position()
	#print_debug(mousePos)
	var origin = cam.project_ray_origin(mousePos)
	var end = origin + cam.project_ray_normal(mousePos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = spaceState.intersect_ray(query)
	result = result.get("collider")
	#print(result)
	return result

func _input_raton(event): #renombrar para que se ejecute
	# Cambiar modo (teclas)
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				mode = 1
				print("MODO: MOVER")
			KEY_2:
				mode = 2
				print("MODO: ROTAR")
			KEY_3:
				mode = 3
				print("MODO: ESCALAR")
				
	# CLICK IZQUIERDO
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var collider = raycast()
			if collider == self:
				Global.draggingSomething = self
				dragging = true
				drag_start_mouse = event.position
				drag_start_transform = $"../".global_transform
				print("Arrastrando:", self)
		else:
			# Soltar click
			dragging = false
			if Global.draggingSomething == self:
				Global.draggingSomething = null

	# ARRASTRAR RATÓN
	if event is InputEventMouseMotion and dragging and Global.draggingSomething == self:
		_handle_mouse_drag(event.relative)


func _handle_mouse_drag(mouse_delta: Vector2):

	var parent := $"../" as Node3D
	if parent == null:
		return

	match mode:
		1: # MOVER
			parent.global_position += Vector3(
				mouse_delta.x * 0.01,
				-mouse_delta.y * 0.01,
				0.0
			)

		2: # ROTAR
			parent.rotate_y(mouse_delta.x * 0.01)

		3: # ESCALAR
			var factor := 1.0 + mouse_delta.y * 0.005
			parent.scale *= Vector3.ONE * factor
