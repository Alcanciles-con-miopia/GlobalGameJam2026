extends Node


var skel # Esqueleto de la mascara.

# Rangos de valores (simetricos) para randomizar la posicion (x), rotacion (y) y escala (z).
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
	skel = self # Guardamos el esqueleto.
	
	# Llamamos al randomizador con cada hueso.
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

# Update.
func _process(delta):
	pass

# Dado el nombre de un hueso y valores de rango siemtricos randomiza la posicion, rotacion y escala de un hueso.
func randomizeBone(boneName, positionRange, rotationRange, scaleRange):
	var boneID = skel.find_bone(boneName) #Coger el id del hueso dado su nombre.
	
	var trans = skel.get_bone_pose(boneID) # Coger el transform del hueso.
	
	trans = trans.translated(Vector3(randf_range(-positionRange, positionRange), randf_range(-positionRange, positionRange), 0.0))
	#trans = trans.rotated(Vector3(0.0, 0.0, 1.0), randf_range(-rotationRange, rotationRange))
	#trans = trans.scaled(Vector3(randf_range(1 - scaleRange, 1 + scaleRange), 1.0, 1.0))
	
	skel.set_bone_pose(boneID, trans) # Settear el transform cambiado al hueso.
	pass
