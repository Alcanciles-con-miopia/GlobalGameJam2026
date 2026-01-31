extends Node3D

@export var mask_type: StringName = "mask_1"
@export var camRef:Camera3D = null

func getCamRef():
	print("Toma una camara")
	return camRef
