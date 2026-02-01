extends Node3D

@export var mask_type: StringName = "mask_1"
@export var camRef:Camera3D = null

func getCamRef():
	print("Toma una camara")
	return camRef

func enter():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector3(0,5,1), 0)
	tween.tween_property(self, "position", Vector3(0,2.5,1), 0.5)
	tween.tween_property(self, "position", Vector3(0,2.5,1), 0.2)
	tween.tween_property(self, "rotation", Vector3(0,0,1), 0.2)
	tween.tween_property(self, "rotation", Vector3(0,0,-0.5), 0.1)
	tween.tween_property(self, "rotation", Vector3(0,0,0), 0.1)
	tween.tween_property(self, "position", Vector3(0,2.5,0.5), 0.5)
	tween.tween_property(self, "position", Vector3(0,2.5,0), 0.2)
	
	tween.tween_property(self, "position", Vector3(0,2.5,0), 5)
	tween.tween_property(self, "rotation", Vector3(0,0,1), 0.2)
	tween.tween_property(self, "rotation", Vector3(0,0,-0.5), 0.1)
	tween.tween_property(self, "rotation", Vector3(0,0,0), 0.1)
	
	tween.tween_property(self, "position", Vector3(0,2.5,0), 7)
	tween.tween_property(self, "rotation", Vector3(0,0,1), 0.2)
	tween.tween_property(self, "rotation", Vector3(0,0,-0.5), 0.1)
	tween.tween_property(self, "rotation", Vector3(0,0,0), 0.1)
	
	tween.tween_property(self, "position", Vector3(0,2.5,0), 6)
	tween.tween_property(self, "rotation", Vector3(0,0,1), 0.2)
	tween.tween_property(self, "rotation", Vector3(0,0,-0.5), 0.1)
	tween.tween_property(self, "rotation", Vector3(0,0,0), 0.1)
	
	tween.tween_property(self, "position", Vector3(0,2.5,0), 6)
	tween.tween_property(self, "rotation", Vector3(0,0,1), 0.2)
	tween.tween_property(self, "rotation", Vector3(0,0,-0.5), 0.1)
	tween.tween_property(self, "rotation", Vector3(0,0,0), 0.1)
	
	
	tween.tween_property(self, "position", Vector3(0,2.5,0), 3)
	tween.tween_property(self, "rotation", Vector3(0,0,1), 0.2)
	tween.tween_property(self, "rotation", Vector3(0,0,-0.5), 0.1)
	tween.tween_property(self, "rotation", Vector3(0,0,0), 0.1)
	
	tween.tween_property(self, "position", Vector3(0,2.5,0), 3)
	tween.tween_property(self, "rotation", Vector3(0,0,1), 0.2)
	tween.tween_property(self, "rotation", Vector3(0,0,-0.5), 0.1)
	tween.tween_property(self, "rotation", Vector3(0,0,0), 0.1)
