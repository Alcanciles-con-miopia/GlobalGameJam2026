extends Node

@onready var maskClient: Skeleton3D = get_node_or_null("ClientMask/mascara1/Skeleton/Skeleton3D")
@onready var maskP1: Skeleton3D = get_node_or_null("P1Mask/mascara1/Skeleton/Skeleton3D")
@onready var maskP2: Skeleton3D = get_node_or_null("P2Mask/mascara3/Skeleton/Skeleton3D")

var boneCount

var diffP1: float = 0.0
var diffP2: float = 0.0
var BEST_MASK : String = ""  # "P1", "P2" o "TIE"

func finish_round() -> void:
	# esto es pa ahora q no tenemos modelos todavia dice empate y a tomar por culo
	if maskClient == null or maskP1 == null or maskP2 == null:
		Global.LAST_WINNER = "TIE"
		Global.change_scene(Global.Scenes.FINALSCENE)
		return

	diffP1 = 0.0
	diffP2 = 0.0

	_compareMask()

	Global.LAST_WINNER = BEST_MASK

	Global.PLAYER1_POINTS += diffP1
	Global.PLAYER2_POINTS += diffP2

	Global.change_scene(Global.Scenes.FINALSCENE)
	
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
		var diffPosP1 = (posClient - posP1).length()
		diffP1 += diffPosP1
		
		# - dif scale
		var diffScaleP1 = (scaleClient - scaleP1).length()
		diffP1 += diffScaleP1
		
		# - dif rot
		var diffRotXP1 = (rotClient.x - rotP1.x).length()
		var diffRotYP1 = (rotClient.y - rotP1.y).length()
		var diffRotZP1 = (rotClient.z - rotP1.z).length()
		
		diffP1 += diffRotXP1
		diffP1 += diffRotYP1
		diffP1 += diffRotZP1
		
		# -- diferencias P2
		# - dif pos
		var diffPosP2 = (posClient - posP2).length()
		diffP2 += diffPosP2
		
		# - dif scale
		var diffScaleP2 = (scaleClient - scaleP2).length()
		diffP2 += diffScaleP2
		
		# - dif rot
		var diffRotXP2 = (rotClient.x - rotP2.x).length()
		var diffRotYP2 = (rotClient.y - rotP2.y).length()
		var diffRotZP2 = (rotClient.z - rotP2.z).length()
		
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
	elif m == diffP2:
		best = "P1"
	else:
		best = "TIE"
	
	print("Best Mask: ", best)
	return best
