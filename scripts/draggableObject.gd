extends Node

var cam:Camera3D
var dif

var mode: int = 1

var scaleChange = 1

# Start.
func _ready():
	cam = $"../../../..".getCamRef()
	#print(cam)
	
	dif = $"../".global_position - self.global_position
	pass

# Update.
func _process(_delta):
	pass

#Input.
func _input(event):
	
	if event is InputEventKey and event.pressed :
		if event.keycode == KEY_1:
			mode = 1
			print("MOVER")
		elif event.keycode == KEY_2:
			mode = 2
			print("ROTAR")
		elif event.keycode == KEY_3:
			mode = 3
			print("ESCALAR")
		
	if cam.raycast() != null and Input.is_action_pressed("left_click"):
		Global.draggingSomething = cam.raycast() # Cogemos
		print(Global.draggingSomething)
			
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
