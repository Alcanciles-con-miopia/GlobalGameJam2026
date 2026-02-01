extends Node

var maskClient: Skeleton3D = null
var maskP1: Skeleton3D = null
var maskP2: Skeleton3D = null

var diffP1: float = 0.0
var diffP2: float = 0.0
var BEST_MASK: String = ""  # "P1", "P2" o "TIE"

# GameScene debe llamar a esto cuando tenga los skeletons
func setup(client: Skeleton3D, p1: Skeleton3D, p2: Skeleton3D) -> void:
	maskClient = client
	maskP1 = p1
	maskP2 = p2

func finish_round() -> void:
	# si no tenemos skeletons, empate rápido
	if maskClient == null or maskP1 == null or maskP2 == null:
		print("CompareMasks: faltan skeletons, empate forzado.")
		Global.LAST_WINNER = "TIE"
		Global.change_scene(Global.Scenes.FINALSCENE)
		return

	diffP1 = 0.0
	diffP2 = 0.0

	_compareMask()

	print("CompareMasks: diffP1 =", diffP1, " diffP2 =", diffP2, " BEST =", BEST_MASK)

	Global.LAST_WINNER = BEST_MASK

	# Sumamos una sola vez
	Global.PLAYER1_POINTS += diffP1
	Global.PLAYER2_POINTS += diffP2

	Global.change_scene(Global.Scenes.FINALSCENE)
	
# returns [diffP1, diffP2]
func _compareMask() -> Array:
	for i in range(1, Global.BoneCount + 1):
		var boneKey = Global.Bones.find_key(i)
		
		var idClient = maskClient.find_bone(boneKey)
		var idP1 = maskP1.find_bone(boneKey)
		var idP2 = maskP2.find_bone(boneKey)
		
		if idClient < 0 or idP1 < 0 or idP2 < 0:
			continue
		
		var poseClient := maskClient.get_bone_pose(idClient)
		var poseP1 := maskP1.get_bone_pose(idP1)
		var poseP2 := maskP2.get_bone_pose(idP2)

		var posClient = poseClient.origin
		var posP1 = poseP1.origin
		var posP2 = poseP2.origin
		
		var rotClient = poseClient.basis
		var rotP1 = poseP1.basis
		var rotP2 = poseP2.basis

		var scaleClient = rotClient.get_scale()
		var scaleP1 = rotP1.get_scale()
		var scaleP2 = rotP2.get_scale()
		
		# --- P1 ---
		var diffPosP1 = (posClient - posP1).length()
		var diffScaleP1 = (scaleClient - scaleP1).length()
		var diffRotXP1 = (rotClient.x - rotP1.x).length()
		var diffRotYP1 = (rotClient.y - rotP1.y).length()
		var diffRotZP1 = (rotClient.z - rotP1.z).length()
		diffP1 += diffPosP1 + diffScaleP1 + diffRotXP1 + diffRotYP1 + diffRotZP1
		
		# --- P2 ---
		var diffPosP2 = (posClient - posP2).length()
		var diffScaleP2 = (scaleClient - scaleP2).length()
		var diffRotXP2 = (rotClient.x - rotP2.x).length()
		var diffRotYP2 = (rotClient.y - rotP2.y).length()
		var diffRotZP2 = (rotClient.z - rotP2.z).length()
		diffP2 += diffPosP2 + diffScaleP2 + diffRotXP2 + diffRotYP2 + diffRotZP2
	
	print("DIFERENCIAS ", diffP1, " ", diffP2)
	BEST_MASK = _getBestMask(diffP1, diffP2)
	
	return [diffP1, diffP2]
	
func _getBestMask(d1: float, d2: float) -> String:
	# MENOR diferencia = más parecido
	var eps := 0.0001

	if abs(d1 - d2) < eps:
		return "TIE"
	elif d1 < d2:
		return "HERMENEGILDO"
	else:
		return "SUSI"
