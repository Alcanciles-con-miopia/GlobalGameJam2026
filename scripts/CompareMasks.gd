extends Node

#var maskClient # cliente
#var maskP1 # jugador 1
var maskP2 # jugador 2

# @onready var : Skeleton3D = $Armature/mascaras/Armature/Skeleton3D

@onready var maskClient: Skeleton3D = $ClientMask/mascaras/Armature/Skeleton3D
@onready var maskP1: Skeleton3D = $ClientMask/mascaras/Armature/Skeleton3D

var boneCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var id = maskClient.find_bone("nose")
	#print("bone id:", id)
	
	boneCount = maskP1.get_bone_count()
	_compareMask()
	
func _compareMask() -> void:
	for i in range(1, Global.BoneCount + 1):
		var bone = Global.Bones.find_key(i)
		var id = maskClient.find_bone(bone)
		print("bone id:", id)
		print("bone :", bone)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
