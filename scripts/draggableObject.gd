extends Node

var cam: Camera3D = null
var dif
const RAY_LENGTH = 100000.0

var mode: int = 1
var scaleChange: float = 1.0

var dragging := false
var drag_start_mouse := Vector2.ZERO
var drag_start_transform: Transform3D

var owned_by_player = 0 

# Start.
func _ready():
	#cam = get_tree().get_first_node_in_group("game_camera") as Camera3D
	cam = $"../../../..".getCamRef()
	if cam == null:
		cam = get_tree().get_first_node_in_group("game_camera") as Camera3D
		if cam == null:
			print_debug("DraggableObject: no se encontró ninguna Camera3D en el grupo 'game_camera'")
	
	dif = $"../".global_position - self.global_position
	pass

# Update.
func _process(_delta):
	pass
	

func raycast():
	var spaceState = cam.get_world_3d().direct_space_state
	var mousePos = cam.get_viewport().get_mouse_position()
	var origin = cam.project_ray_origin(mousePos)
	var end = origin + cam.project_ray_normal(mousePos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = spaceState.intersect_ray(query)
	result = result.get("collider")
	#print(result)
	return result


func _input(event):

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

	# CLICK DERECHO
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if Global.draggingSomething == self:
			Global.draggingSomething = null
			dragging = false


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



#Input.
#func _input(event):
	#
	#if event is InputEventKey and event.pressed :
		#match event.keycode:
			#KEY_1:
				#mode = 1
				#print("MODO: MOVER")
			#KEY_2:
				#mode = 2
				#print("MODO: ROTAR")
			#KEY_3:
				#mode = 3
				#print("MODO: ESCALAR")
		#
	#if Input.is_action_pressed("left_click"):
		#var collider = raycast()
		#if collider != null:
			#Global.draggingSomething = collider
			#print("Arrastrando:", Global.draggingSomething)
			#
	#if Global.draggingSomething == self and Global.draggingSomething != null:
		#if event is InputEventKey and event.pressed:
			#var parent_node := $"../" as Node3D
			#if parent_node == null:
				#return
				#
			#match event.keycode:
				#KEY_A:
					#if mode == 1:
						#parent_node.global_position += Vector3(-0.1, 0.0, 0.0)
					#elif mode == 2:
						#parent_node.transform = parent_node.transform.rotated(Vector3(0.0, 1.0, 0.0), -0.1)
				#KEY_D:
					#if mode == 1:
						#parent_node.global_position += Vector3(0.1, 0.0, 0.0)
					#elif mode == 2:
						#parent_node.transform = parent_node.transform.rotated(Vector3(0.0, 1.0, 0.0), 0.1)
				#KEY_W:
					#if mode == 1:
						#parent_node.global_position += Vector3(0.0, 0.1, 0.0)
					#elif mode == 3:
						#parent_node.transform = parent_node.transform.scaled(Vector3(1.1, 1.1, 1.1))
				#KEY_S:
					#if mode == 1:
						#parent_node.global_position += Vector3(0.0, -0.1, 0.0)
					#elif mode == 3:
						#parent_node.transform = parent_node.transform.scaled(Vector3(0.9, 0.9, 0.9))
	#
	## Quitar el click.
	#if Input.is_action_pressed("right_click") and Global.draggingSomething != self:
		#Global.draggingSomething = null
	#
	 ## Si hay raycast y evento de click izquierdo (posicion).
	##if cam.raycast() != null and Input.is_action_pressed("left_click"):
		##Global.draggingSomething = cam.raycast() # Cogemos
		##if (Global.draggingSomething == self or Global.draggingSomething == null):
			##var mousePos = get_viewport().get_mouse_position()
			##var origin = cam.project_ray_origin(mousePos)
			##var end = cam.project_ray_normal(mousePos)
			##var finalPosition = origin + end - dif
		#
			##$"../".global_position = finalPosition
	## Quitar el click.
	##if Input.is_action_just_released("left_click") and Global.draggingSomething == self:
		##Global.draggingSomething = null
	#pass
