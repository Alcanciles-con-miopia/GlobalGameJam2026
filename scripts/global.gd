extends Node

## SEÑALES
# flujo
signal on_transition_begin(speed)
signal on_transition_end
signal on_enable(scene)
signal on_disable(scene)
signal on_game_end()

## maquina de estados y variables de flujo
var sm # state machine
var current_scene = Scenes.INTRO 
var next_scene = Scenes.INTRO
## MUY IMPORTANTE: MISMO ORDEN QUE EN EL SERIALIZED ARRAY DE LA STATEMACHINE
enum Scenes { INTRO, ARISCENE, GAME, NULL}

## sonido
var sfx
var bgm
var sound

var coolDown = 0.5
var startCoolDown = false
var random = RandomNumberGenerator.new()

## HUESOS
enum Bones {
	eye_r = 1,
	eye_l,

	forehead_l,
	forehead_r,
	
	cheek_l,
	cheek_r,
	
	chin,
	
	nose,
	
	commissure_l,
	commissure_r,
	
	mouth
}
# DRAGG
var draggingSomething = null # Hueso que se esta moviendo en un momento.



# PUNTUACIONES
var PLAYER1_POINTS = 0
var PLAYER2_POINTS = 0

var BoneCount = 11

# MULTIPLAYER
var HostIP = -1 # -1 para gestion de errores

func _ready() -> void:
	pass

func  _process(delta: float) -> void:
	if startCoolDown:
		if coolDown <= 0:
			startCoolDown = false
			coolDown = 0.5
		else:
			coolDown-= delta
	pass

func change_scene(next : Global.Scenes, speed = 1.0, force = true):
	Global.next_scene = next
	#print(">> Changing from ", Global.current_scene, " to ", Global.next_scene)
	if ((current_scene != next || force) and not startCoolDown):
		#startCoolDown = true
		Global.on_transition_begin.emit(speed)

func timer(tiempo = 1.0):
	return get_tree().create_timer(tiempo).timeout
