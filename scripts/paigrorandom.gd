extends Node

var boneID
var skel

# Start.
func _ready():
	skel = self
	
	for i in range(1, Global.BoneCount + 1):
		var bone = Global.Bones.find_key(i)
		print(bone)
		boneID = skel.find_bone(bone)
		print(boneID)
		
	randomizeBone("eye_l", 0.005, 0.05, 0.5)
	randomizeBone("eye_r", 0.005, 0.05, 0.5)
	randomizeBone("forehead_l", 0.005, 0.05, 0.5)
	randomizeBone("forehead_r", 0.005, 0.05, 0.5)
	randomizeBone("cheek_l", 0.005, 0.05, 0.5)
	randomizeBone("cheek_r", 0.005, 0.05, 0.5)
	randomizeBone("chin", 0.005, 0.05, 0.5)
	randomizeBone("nose", 0.005, 0.05, 0.5)
	randomizeBone("commissure_l", 0.005, 0.05, 0.5)
	randomizeBone("commissure_r", 0.005, 0.05, 0.5)
	randomizeBone("mouth", 0.005, 0.05, 0.5)

# Update.
func _process(delta):
	pass

func randomizeBone(boneName, positionRange, rotationRange, scaleRange):
	print("Giro de ", boneName)
	boneID = skel.find_bone(boneName)
	var trans = skel.get_bone_pose(boneID)
	trans = trans.translated(Vector3(randf_range(-positionRange, positionRange), randf_range(-positionRange, positionRange), 0.0))
	trans = trans.rotated(Vector3(0.0, 0.0, 1.0), randf_range(-rotationRange, rotationRange)) #PAIGRO AQUI CAMBIAR POR CTE
	trans = trans.scaled(Vector3(randf_range(1 - scaleRange, 1 + scaleRange), 1.0, 1.0))
	skel.set_bone_pose(boneID, trans)
	pass
