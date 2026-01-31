extends Node3D

const RAY_LENGTH = 100000.0
var cam

func _ready():
	cam = self
	pass

#func _input(event):
	#if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		#var from = cam.project_ray_origin(event.position)
		#var to = from + cam.project_ray_normal(event.position) * RAY_LENGTH
		#_send_raycast(from, to)
		

# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html#collision-mask

#func _send_raycast(from, to):
	#var space_state = get_world_3d().direct_space_state
	#var query = PhysicsRayQueryParameters3D.create(from, to)
	#var result = space_state.intersect_ray(query)

func raycast():
	var spaceState= get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var origin = cam.project_ray_origin(mousePos)
	var end = origin + cam.project_ray_normal(mousePos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = spaceState.intersect_ray(query)
	result = result.get("collider")
	#print(result)
	return result
