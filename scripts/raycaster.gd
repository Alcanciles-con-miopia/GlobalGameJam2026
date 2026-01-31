extends Node3D

const RAY_LENGTH = 100000.0
var cam

func _ready():
	cam = self
	pass

func _process(delta):
	raycast()

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
