extends Node

#var maskClient # cliente
#var maskP1 # jugador 1
#var maskP2 # jugador 2

# @onready var : Skeleton3D = $Armature/mascaras/Armature/Skeleton3D

@onready var maskClient: Skeleton3D = $ClientMask/mascara1/Skeleton/Skeleton3D
@onready var maskP1: Skeleton3D = $P1Mask/mascara1/Skeleton/Skeleton3D
@onready var maskP2: Skeleton3D = $P2Mask/mascara3/Skeleton/Skeleton3D

var boneCount

var diffP1 = 0
var diffP2 = 0

var BEST_MASK : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boneCount = maskP1.get_bone_count()
	_compareMask()
	
# returns [diffP1, diffP2]
func _compareMask() -> Array:
	for i in range(1, Global.BoneCount + 1):
		# key de los huesos
		var boneKey = Global.Bones.find_key(i)
		print("----- bone key :", boneKey)
		
		# -- id de los huesos
		var idClient = maskClient.find_bone(boneKey)
		var idP1 = maskP1.find_bone(boneKey)
		var idP2 = maskP2.find_bone(boneKey)
		
		# -- posiciones
		var posClient = maskClient.get_bone_pose(idClient).origin
		var posP1 = maskP1.get_bone_pose(idP1).origin
		var posP2 = maskP2.get_bone_pose(idP2).origin
		
		# -- rotaciones
		var rotClient = maskClient.get_bone_pose(idClient).basis
		var rotP1 = maskP1.get_bone_pose(idP1).basis
		var rotP2 = maskP2.get_bone_pose(idP2).basis

		# -- escalas
		var scaleClient = maskClient.get_bone_pose(idClient).basis.get_scale()
		var scaleP1 = maskP1.get_bone_pose(idP1).basis.get_scale()
		var scaleP2 = maskP2.get_bone_pose(idP2).basis.get_scale()
		
		# -- diferencias P1
		# - dif pos
		var diffPosP1
		diffPosP1 = (posClient - posP1).length()
		diffP1 += diffPosP1
		# - dif scale
		var diffScaleP1
		diffScaleP1 = (scaleClient - scaleP1).length()
		diffP1 += diffScaleP1
		# - dif rot
		var diffRotXP1
		var diffRotYP1
		var diffRotZP1
		
		diffRotXP1 = (rotClient.x - rotP1.x).length()
		diffRotYP1 = (rotClient.y - rotP1.y).length()
		diffRotZP1 = (rotClient.z - rotP1.z).length()
		
		diffP1 += diffRotXP1
		diffP1 += diffRotYP1
		diffP1 += diffRotZP1
		
		# -- diferencias P2
		# - dif pos
		var diffPosP2
		diffPosP2 = (posClient - posP2).length()
		diffP2 += diffPosP2
		# - dif scale
		var diffScaleP2
		diffScaleP2 = (scaleClient - scaleP2).length()
		diffP2 += diffScaleP2
		# - dif rot
		var diffRotXP2
		var diffRotYP2
		var diffRotZP2
		
		diffRotXP2 = (rotClient.x - rotP2.x).length()
		diffRotYP2 = (rotClient.y - rotP2.y).length()
		diffRotZP2 = (rotClient.z - rotP2.z).length()
		
		diffP2 += diffRotXP2
		diffP2 += diffRotYP2
		diffP2 += diffRotZP2
	
	print("DIFERENCIAS ", diffP1, " ", diffP2)
	BEST_MASK = _getBestMask(diffP1,diffP2)
	
	# puntuaciones globales
	Global.PLAYER1_POINTS += diffP1
	Global.PLAYER2_POINTS += diffP2
	
	return [diffP1, diffP2]
	
func _getBestMask(diffP1: float, diffP2: float) -> String:
	var m = maxf(diffP1, diffP2)
	
	var best : String
	if(m == diffP1):
		best = "P2"
	else:
		best = "P1"
	
	print("Best Mask: ", best)
	return best


func _on_line_edit_text_submitted(new_text: String) -> void:
	pass # Replace with function body.
