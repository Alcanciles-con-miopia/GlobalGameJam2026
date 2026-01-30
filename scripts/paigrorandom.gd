extends Node


var skel

func _ready():
	skel = get_node("skel")
	var count = skel.get_bone_count()
	print("bone count:", count)
