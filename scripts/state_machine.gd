extends Node

@export var scenes: Array[Node] = [] 
@onready var fade = $Fade

@onready var bgm: AudioStreamPlayer2D = $Sound/BGM
@onready var sfx: AudioStreamPlayer2D = $Sound/SFX
@onready var sound = $Sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## INICIALIZAR GLOBAL
	Global.sm = self
	Global.sfx = sfx
	Global.bgm = bgm
	Global.sound = sound
	
	## CONECTAR SEÑALES
	Global.on_transition_end.connect(_on_fade_end)
	Global.on_game_end.connect(_on_game_end)
	
	## PRIMER CAMBIO DE ESCENA
<<<<<<< Updated upstream
	Global.change_scene(Global.Scenes.GAME)
	var thread = Thread.new()
	thread.start(_connect_wiimotes_thread)
	print_debug("WIIMOTE: Intentando iniciar hilo.")
	if (thread.is_started()):
		print_debug("WIIMOTE: Hilo inicializado.")
	else:
		print_debug("WIIMOTE: ERROR al inicializar el hilo.")
=======
	Global.change_scene(Global.Scenes.ARISCENE)
>>>>>>> Stashed changes
	pass 

func _connect_wiimotes_thread():
	# Initialize loading screen
	print_debug("WIIMOTE: Intentando iniciar conexión.")
	GDWiimoteServer.initialize_connection(true)
	call_deferred("_on_connection_complete")

func _on_connection_complete():
	# Hide loading screen
	# Retrieve connected Wiimotes
	print_debug("WIIMOTE: SUCCESS, conexión finalizada.")
	var connected_wiimotes = GDWiimoteServer.finalize_connection()
	## can also retrieve later on with GDWiimoteServer.get_connected_wiimotes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	var scene = Global.Scenes.NULL;
	if event.is_action_pressed("1"):
		print_debug("WIIMOTE: Se ha pulsado A.")
		#scene = Global.Scenes.INTRO
	if event.is_action_pressed("2"):
		print_debug("WIIMOTE: Se ha pulsado B.")
		#scene = Global.Scenes.GAME
	#if event.is_action_pressed("ui_cancel"):
		#get_tree().quit()
	if (scene != Global.Scenes.NULL):
		Global.change_scene(scene)

func _on_game_end():
	pass

#func _on_transition(speed = 1.0) -> void: #fade in
	#fade.transition(speed)


func _on_fade_end() -> void: #justo antes del fadeout, la idea es que esto sea un switch
	# escena a apagar
	scenes[Global.current_scene].visible = false
	scenes[Global.current_scene].on_disable()
	scenes[Global.current_scene].process_mode = Node.PROCESS_MODE_DISABLED

	# escena a encender
	scenes[Global.next_scene].visible = true
	scenes[Global.next_scene].on_enable()
	scenes[Global.next_scene].process_mode = Node.PROCESS_MODE_INHERIT

	Global.current_scene = Global.next_scene
	
	# actualiza la musica segun la escena
	_update_bgm_for_scene()

func _update_bgm_for_scene() -> void:
	match Global.current_scene:
		Global.Scenes.INTRO:
			# Global.sound.play_bgm("intro_theme")
			Global.sound.stop_bgm()
		Global.Scenes.GAME:
			# sample de prueba luego se cambia por el real
			Global.sound.play_bgm("bgmusicSample")
		Global.Scenes.ARISCENE:
			# sample de prueba luego se cambia por el real
			Global.sound.play_bgm("bgmusicSample")
		Global.Scenes.NULL:
			Global.sound.stop_bgm()
