extends Node

var cam: Camera3D = null
var dif
const RAY_LENGTH = 100000.0

var mode: int = 1
var scaleChange: float = 1.0

# Start.
func _ready():
	#cam = get_tree().get_first_node_in_group("game_camera") as Camera3D
	cam = $"../../../..".getCamRef()
	if cam == null:
		push_error("DraggableObject: no se encontró ninguna Camera3D en el grupo 'game_camera'")
	
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

#Input.
func _input(event):
	
	if event is InputEventKey and event.pressed :
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
		
	if Input.is_action_pressed("left_click"):
		var collider = raycast()
		if collider != null:
			Global.draggingSomething = collider
			print("Arrastrando:", Global.draggingSomething)
			
	if (Global.draggingSomething == self and Global.draggingSomething != null):
		if event is InputEventKey and event.pressed :
			if event.keycode == KEY_A:
				if mode == 1:
					$"../".global_position += Vector3(-0.1, 0.0, 0.0)
				elif mode == 2:
					$"../".transform = $"../".transform.rotated(Vector3(0.0, 1.0, 0.0), -0.1)
			elif event.keycode == KEY_D:
				if mode == 1:
					$"../".global_position += Vector3(0.1, 0.0, 0.0)
				elif mode == 2:
					$"../".transform = $"../".transform.rotated(Vector3(0.0, 1.0, 0.0), 0.1)
			elif event.keycode == KEY_W:
				if mode == 1:
					$"../".global_position += Vector3(0.0, 0.1, 0.0)
				elif mode == 3:
					$"../".transform = $"../".transform.scaled(Vector3(1.1, 1.1, 1.1))
			elif event.keycode == KEY_S:
				if mode == 1:
					$"../".global_position += Vector3(0.0, -0.1, 0.0)
				elif mode == 3:
					$"../".transform = $"../".transform.scaled(Vector3(0.9, 0.9, 0.9))
			pass
	
	# Quitar el click.
	if Input.is_action_pressed("right_click") and Global.draggingSomething != self:
		Global.draggingSomething = null
	
	 # Si hay raycast y evento de click izquierdo (posicion).
	#if cam.raycast() != null and Input.is_action_pressed("left_click"):
		#Global.draggingSomething = cam.raycast() # Cogemos
		#if (Global.draggingSomething == self or Global.draggingSomething == null):
			#var mousePos = get_viewport().get_mouse_position()
			#var origin = cam.project_ray_origin(mousePos)
			#var end = cam.project_ray_normal(mousePos)
			#var finalPosition = origin + end - dif
		
			#$"../".global_position = finalPosition
	# Quitar el click.
	#if Input.is_action_just_released("left_click") and Global.draggingSomething == self:
		#Global.draggingSomething = null
	pass
