extends Skeleton3D

# Rango para los ojos
@export var eyesRange:Vector3 = Vector3(0.005, 0.05, 0.5)
# Rango para las frente.
@export var foreheadsRange:Vector3 = Vector3(0.005, 0.05, 0.5)
# Rango para las mejillas.
@export var cheeksRange:Vector3 = Vector3(0.005, 0.05, 0.5)
# Rango para el menton.
@export var chinRange:Vector3 = Vector3(0.005, 0.05, 0.5)
# Rango para la nariz.
@export var noseRange:Vector3 = Vector3(0.005, 0.05, 0.5)
# Rango para las comisuras.
@export var commissuresRange:Vector3 = Vector3(0.005, 0.05, 0.5)
# Rango para la boca.
@export var mouthRange:Vector3 = Vector3(0.005, 0.05, 0.5)

# Start.
func _ready():
	randomize()
	
	for i in range(1, Global.BoneCount + 1):
		var bone = Global.Bones.find_key(i)
		print("Bone:", bone, "id:", find_bone(bone))
		
	randomizeBone("eye_l", eyesRange.x, eyesRange.y, eyesRange.z)
	randomizeBone("eye_r", eyesRange.x, eyesRange.y, eyesRange.z)
	randomizeBone("forehead_l", foreheadsRange.x, foreheadsRange.y, foreheadsRange.z)
	randomizeBone("forehead_r", foreheadsRange.x, foreheadsRange.y, foreheadsRange.z)
	randomizeBone("cheek_l", cheeksRange.x, cheeksRange.y, cheeksRange.z)
	randomizeBone("cheek_r", cheeksRange.x, cheeksRange.y, cheeksRange.z)
	randomizeBone("chin", chinRange.x, chinRange.y, chinRange.z)
	randomizeBone("nose", noseRange.x, noseRange.y, noseRange.z)
	randomizeBone("commissure_l", commissuresRange.x, commissuresRange.y, commissuresRange.z)
	randomizeBone("commissure_r", commissuresRange.x, commissuresRange.y, commissuresRange.z)
	randomizeBone("mouth", mouthRange.x, mouthRange.y, mouthRange.z)


func randomizeBone(boneName: StringName, positionRange: float, rotationRange: float, scaleRange: float) -> void:
	print("Giro de ", boneName)
	var boneID = find_bone(boneName) #Coger el id del hueso dado su nombre.
	
	if boneID < 0:
		push_warning("Hueso no encontrado: " + boneName)
		return

	var trans: Transform3D = get_bone_pose(boneID) # Coger el transform del hueso.
	
	trans = trans.translated(Vector3(randf_range(-positionRange, positionRange), randf_range(-positionRange, positionRange), 0.0))
	trans = trans.rotated(Vector3(0.0, 0.0, 1.0), randf_range(-rotationRange, rotationRange))
	trans = trans.scaled(Vector3(randf_range(1.0 - scaleRange, 1.0 + scaleRange), 1.0, 1.0))
	
	set_bone_pose(boneID, trans) # Settear el transform cambiado al hueso.
	
