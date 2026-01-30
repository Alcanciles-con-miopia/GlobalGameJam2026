extends Node

var boneID
var skel

func _ready():
	skel = self
	
	for i in range(1, Global.BoneCount + 1):
		var bone = Global.Bones.find_key(i)
		print(bone)
		boneID = skel.find_bone(bone)
		print(boneID)
		
	randomizeEye_L("eye_l")

func _process(delta):
	boneID= 17
	var t = skel.get_bone_pose(boneID)
	t = t.rotated(Vector3(0.0, 1.0, 0.0), 0.1 * delta)
	skel.set_bone_pose(boneID, t)
	pass

func randomizeEye_L(boneName):
	boneID = skel.find_bone(boneName)
	var trans = skel.get_bone_pose(boneID)
	trans = trans.rotated(Vector3(1.0, 1.0, 0.0), 500)
	pass
func randomizeEye_R(boneName):
	pass
func randomizeForeheadL_(boneName):
	pass
func randomizeForehead_R(boneName):
	pass
func randomizeCheek_L(boneName):
	pass
func randomizeCheekR(boneName):
	pass
func randomizeChin(boneName):
	pass
func randomizeComissure_L(boneName):
	pass
func randomizeComissure_R(boneName):
	pass
func randomizeMouth(boneName):
	pass
