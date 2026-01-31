extends Node

var cam:Camera3D

# Start.
func _ready():
	cam = $"../../../..".getCamRef()
	print(cam)
	pass

# Update.
func _process(_delta):
	pass

#Input.
func _input(event):
	 # Si hay raycast y evento de click izquierdo (posicion).
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
	pass
