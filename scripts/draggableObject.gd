extends Node

var active = false
var dif = Vector2(0, 0)

var cam

#var newMousePosition
#var lastMousePosition

#var axisMovement: float = 0.01
#var totalMovement: Vector3 = Vector3( 0.0, 0.0, 0.0)
#var limit:float = 0.05

# Start.
func _ready():
	#lastMousePosition = get_viewport().get_mouse_position()
	cam = $"../../../../../Camera3D"
	print(cam)
	pass

# Update.
func _process(_delta):
	#newMousePosition = get_viewport().get_mouse_position()
	
	#print(newMousePosition)
	#if active:
		#move(newMousePosition, lastMousePosition)
		
	#lastMousePosition = get_viewport().get_mouse_position()
	pass

#Input.
func _input(event):
	 # Si hay raycast y evento de click.
	if cam.raycast() != null and Input.is_action_pressed("left_click"):
		Global.draggingSomething = cam.raycast() # Cogemos
		if (Global.draggingSomething == self or Global.draggingSomething == null):
			var mousePos = get_viewport().get_mouse_position()
			var origin = cam.project_ray_origin(mousePos)
			var end = cam.project_ray_normal(mousePos)
			var finalPosition = origin + end
		
			$"../".global_position = finalPosition
	# Quitar el click.
	if Input.is_action_just_released("left_click") and Global.draggingSomething == self:
		Global.draggingSomething = null

func move(newMouse, lastMouse):
	var mov = get_viewport().get_mouse_position()
	mov = mov.normalized() * 0.005
	if get_viewport().get_mouse_position().x > get_viewport().size.x/3:
		mov.x = -mov.x
	if get_viewport().get_mouse_position().y < get_viewport().size.y/3:
		mov.y = -mov.y
		
	var newPos:Vector3 = Vector3(0.0, 0.0, 0.0)
	
	newPos.x = (get_viewport().size.x) / (10 * get_viewport().get_mouse_position().x)
	newPos.y = (get_viewport().size.y) / (10 * get_viewport().get_mouse_position().y)
	$"..".global_position = newPos
	
	#var movement: Vector3 = Vector3(0.0, 0.0, 0.0)
	#if !Global.maskRotated: # Orientacion normal de la mascara.
	#	if newMouse.x > lastMouse.x: # Hacia la derecha.
	#		movement.x = axisMovement
	#	else: # Hacia la izquierda.
	#		movement.x = -axisMovement
	#	if newMouse.y > lastMouse.y: # Hacia abajo.
	#		movement.y = axisMovement
	#	else: # Hacia arriba.
	#		movement.y = -axisMovement
	#elif Global.maskRotated: # Para si se gira la camara.
	#	movement = Vector3(0.0, 0.0, 0.0)
	#else: # Por defecto.
	#	movement = Vector3(0.0, 0.0, 0.0)
	
	#mov = limits(mov) #Comprobamos que no se hayan superado los limites.
	
	#$"..".global_position = $"..".global_position + movement # Movimeinto.
	pass

func limits(movement):
	#totalMovement = totalMovement + movement
	
	#if totalMovement.x > limit or totalMovement.x < -limit:
		#movement.x = limit
	#if totalMovement.y > limit or totalMovement.y < -limit:
		#movement.y = limit
	#if totalMovement.z > limit or totalMovement.z < -limit:
		#movement.z = limit
	
	return movement
