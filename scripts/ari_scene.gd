extends Scene

@onready var player1 = $cara1/Armature/Skeleton3D
@onready var player2 = $cara2/Armature/Skeleton3D

var bothselected = false
var clicks = 0

func _process(delta: float) -> void:
	if(bothselected) : Global.change_scene(Global.Scenes.GAME)
	
func _input(event) :
	if event.is_action_pressed("right_click"):
		clicks += 1
	if event.is_action_pressed("left_click"):
		clicks += 1
	if(clicks >= 2):
		bothselected = true
