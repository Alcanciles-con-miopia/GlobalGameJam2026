extends Node

var cam: Camera3D = null
var dif

var mode: int = 1
var scaleChange: float = 1.0

# Start.
func _ready():
	cam = get_tree().get_first_node_in_group("game_camera") as Camera3D
	if cam == null:
		push_error("DraggableObject: no se encontró ninguna Camera3D en el grupo 'game_camera'")
	
	if $"../" is Node3D:
		dif = $"../".global_position - self.global_position

#Input.
func _input(event) -> void:
	if cam == null:
		return
	
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
		var collider = cam.raycast()
		if collider != null:
			Global.draggingSomething = collider
			# print("Arrastrando:", Global.draggingSomething)
			
	if Global.draggingSomething == self and Global.draggingSomething != null:
		if event is InputEventKey and event.pressed:
			var parent_node := $"../" as Node3D
			if parent_node == null:
				return
				
			match event.keycode:
				KEY_A:
					if mode == 1:
						parent_node.global_position += Vector3(-0.1, 0.0, 0.0)
					elif mode == 2:
						parent_node.transform = parent_node.transform.rotated(Vector3(0.0, 1.0, 0.0), -0.1)
				KEY_D:
					if mode == 1:
						parent_node.global_position += Vector3(0.1, 0.0, 0.0)
					elif mode == 2:
						parent_node.transform = parent_node.transform.rotated(Vector3(0.0, 1.0, 0.0), 0.1)
				KEY_W:
					if mode == 1:
						parent_node.global_position += Vector3(0.0, 0.1, 0.0)
					elif mode == 3:
						parent_node.transform = parent_node.transform.scaled(Vector3(1.1, 1.1, 1.1))
				KEY_S:
					if mode == 1:
						parent_node.global_position += Vector3(0.0, -0.1, 0.0)
					elif mode == 3:
						parent_node.transform = parent_node.transform.scaled(Vector3(0.9, 0.9, 0.9))

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
