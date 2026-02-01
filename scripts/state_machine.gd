extends Node

@export var scenes: Array[Node] = [] 
@onready var fade = $Fade

@onready var bgm: AudioStreamPlayer2D = $Sound/BGM
@onready var sfx: AudioStreamPlayer2D = $Sound/SFX
@onready var sound = $Sound

var wiimotes_connected = false
var agarre = false
var connected_wiimotes
var mostrar_aviso = false
var counter = 0

var instruccion = 0

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
	Global.change_scene(Global.Scenes.SELECTMASK)
	#_wiiconnect()
	pass 
	
#func _wiiconnect():
	#var thread = Thread.new()
	#thread.start(_connect_wiimotes_thread)
	#print_debug("WIIMOTE: Intentando iniciar hilo.")
	#if (thread.is_started()):
		#print_debug("WIIMOTE: Hilo inicializado.")
	#else:
		#print_debug("WIIMOTE: ERROR al inicializar el hilo.")

#func _connect_wiimotes_thread():
	## Initialize loading screen
	#print_debug("WIIMOTE: Intentando iniciar conexión.")
	#GDWiimoteServer.initialize_connection(false)
	#call_deferred("_on_connection_complete")

#func _on_connection_complete():
	## Hide loading screen
	## Retrieve connected Wiimotes
	#print_debug("WIIMOTE: SUCCESS, conexión finalizada.")
	#connected_wiimotes = GDWiimoteServer.finalize_connection()
	#wiimotes_connected = true
	#
	#aviso.visible = true
	#mostrar_aviso = true
	#aviso_texto.text = tr("WIIMOTE_FEEDBACK_SUCCESS") + " " + str(connected_wiimotes.size())
	#
	#for i in connected_wiimotes:
		#i.set_ir(true)
	## can also retrieve later on with GDWiimoteServer.get_connected_wiimotes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#_wiimotion()
	#_warning()
	pass
	
#func _wiimotion():
	#if (wiimotes_connected):
		##for i : GDWiimote in connected_wiimotes:
			###print_debug("IR CALCULATED POSITION: ", i.get_ir_cursor_calculated_position())
			##print_debug("SMOOTHED ORIENTATION: ", i.get_smoothed_orientation())
			###Input.warp_mouse(i.get_ir_cursor_calculated_position())
		#for i in range(connected_wiimotes.size()):
			##print_debug("IR CALCULATED POSITION: ", i.get_ir_cursor_calculated_position())
			#print_debug("WIIMOTE ", i + 1, " SMOOTHED ORIENTATION: ", connected_wiimotes[i].get_smoothed_orientation())
			##Input.warp_mouse(i.get_ir_cursor_calculated_position())
	#pass
	#
#func _warning():
	#if mostrar_aviso:
		#counter += 1
		#if counter >= 400:
			#mostrar_aviso = false
			#counter = 0
			#var tween = create_tween()
			#tween.tween_property(aviso, "modulate", Color.TRANSPARENT, 0.5)
	#pass

func _input(event):
	var scene = Global.Scenes.NULL;
	if event.is_action_pressed("1"):
		scene = Global.Scenes.FINALSCENE
	#if event.is_action_pressed("2"):
		#scene = Global.Scenes.GAME
	#if event.is_action_pressed("ui_cancel"):
		#get_tree().quit()
	#if (scene != Global.Scenes.NULL):
		#Global.change_scene(scene)
	#_wiinput(event)
	
func _wiinput(event):
	instruccion += 1
	if Input.is_action_just_released("A") or Input.is_action_just_released("B"):
		agarre = false
	if Input.is_action_pressed("A") and Input.is_action_pressed("B"):
		if not agarre: 
			print_debug("WIIMOTE: ", instruccion, " Se ha pulsado A+B.")
			agarre = true
	else: 
		if event.is_action_pressed("A") and not agarre:
			print_debug("WIIMOTE: ", instruccion, " Se ha pulsado A.")
		if event.is_action_pressed("B") and not agarre:
			print_debug("WIIMOTE: ", instruccion, " Se ha pulsado B.")
		

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
			# Global.sound.play_bgm("bgmusicSample")
			Global.sound.stop_bgm()
		Global.Scenes.SELECTMASK:
			# sample de prueba luego se cambia por el real
			Global.sound.play_bgm("selectBGM")
		Global.Scenes.NULL:
			Global.sound.stop_bgm()
