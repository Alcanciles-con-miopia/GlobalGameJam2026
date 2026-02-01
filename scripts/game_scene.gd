extends Scene

@onready var client_label: Label = $UI/Control/ClientLabel
@onready var countdown_timer: Timer = $UI/Control/CountdownTimer
@onready var timer_label: Label = $UI/Control/CountdownTimer/Label
@onready var comparer: Node = $CompareMasks

@onready var client_masks_root: Node3D = $ClientMasks
@onready var p1_spawn: Node3D = $P1Spawn
@onready var p2_spawn: Node3D = $P2Spawn

# Escenas base de cada máscara para deformar por el player
@export var player_mask_scene_1: PackedScene
@export var player_mask_scene_2: PackedScene
@export var player_mask_scene_3: PackedScene

var ui_root: Control = null

var current_mask_type: StringName = ""  # "mask_1", "mask_2", "mask_3"
var p1_mask_root: Node3D = null
var p2_mask_root: Node3D = null

var current_client_mask_root: Node3D = null

func _ready() -> void:
	ui_root = get_node_or_null("UI/Control")
	if ui_root:
		ui_root.visible = false

	process_mode = Node.PROCESS_MODE_DISABLED

func on_enable() -> void:
	if ui_root == null:
		ui_root = get_node_or_null("UI/Control")

	if ui_root:
		ui_root.visible = true
	
	$UI.visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
	
	var p1_mask := Global.player1_mask_id
	var p2_mask := Global.player2_mask_id

	print("Máscara P1:", p1_mask)
	print("Máscara P2:", p2_mask)
	
	# Elige una máscara de cliente aleatoria de las 3 q hay
	_pick_random_client_mask()

	# Instancia dos máscaras base del mismo tipo para P1 y P2
	_spawn_player_masks()
	
	#esto es un placeholder ns si vamos a hacer json o escribir aqui o nose
	client_label.text = "¡Haz que la máscara se parezca al cliente!"

	if timer_label:
		timer_label.visible = true
	
	if comparer and comparer.has_method("setup"):
		var client_skel := _find_skeleton_in(current_client_mask_root)
		var p1_skel := _find_skeleton_in(p1_mask_root)
		var p2_skel := _find_skeleton_in(p2_mask_root)
		comparer.setup(client_skel, p1_skel, p2_skel)

	countdown_timer.start()
	
	# tweens de entrada
	$ClientMasks/ClientMask_1.enter()
	$ClientMasks/ClientMask_2.enter()
	$ClientMasks/ClientMask_3.enter()
	
	#var tween1 = Tween.new()
	#tween1.tween_property(p1_mask_root, "position", Vector3(0,5,1), 0)
	#tween1.tween_property(p1_mask_root, "position", Vector3(0,2.5,1), 0.5)
	#tween1.tween_property(p1_mask_root, "position", Vector3(0,2.5,1), 0.2)
	#tween1.tween_property(p1_mask_root, "position", Vector3(0,2.5,0.5), 0.5)
	#tween1.tween_property(p1_mask_root, "position", Vector3(0,2.5,0), 0.2)
	#
	#var tween2 = Tween.new()
	#tween2.tween_property(p2_mask_root, "position", Vector3(0,5,1), 0)
	#tween2.tween_property(p2_mask_root, "position", Vector3(0,2.5,1), 0.5)
	#tween2.tween_property(p2_mask_root, "position", Vector3(0,2.5,1), 0.2)
	#tween2.tween_property(p2_mask_root, "position", Vector3(0,2.5,0.5), 0.5)
	#tween2.tween_property(p2_mask_root, "position", Vector3(0,2.5,0), 0.2)

func on_disable() -> void:
	if ui_root == null:
		ui_root = get_node_or_null("UI/Control")

	if ui_root:
		ui_root.visible = false
	
	$UI.visible = false
	
	if timer_label:
		timer_label.visible = false
		timer_label.text = ""

	if p1_mask_root and is_instance_valid(p1_mask_root):
		p1_mask_root.queue_free()
		p1_mask_root = null

	if p2_mask_root and is_instance_valid(p2_mask_root):
		p2_mask_root.queue_free()
		p2_mask_root = null

	process_mode = Node.PROCESS_MODE_DISABLED
	
	if Global.sound and Global.sound.has_method("stop_sfx"):
		Global.sound.stop_sfx()

func _on_CountdownTimer_timeout() -> void:
	for c in Global.cursors:
		Input.start_joy_vibration(c.DeviceID, 1, 1 ,1)
	if comparer and comparer.has_method("finish_round"):
		comparer.finish_round()
	else:
		Global.LAST_WINNER = "TIE"
		Global.change_scene(Global.Scenes.FINALSCENE)

func _pick_random_client_mask() -> void:
	# ClientMasks por ahora tiene 3 hijos: ClientMask_1/2/3 (si eso ya escalamos)
	var masks := client_masks_root.get_children()
	if masks.is_empty():
		push_error("GameScene: no hay máscaras dentro de ClientMasks")
		return

	
	# Ocultar todas
	for m in masks:
		if m is Node3D:
			m.visible = false

	randomize()
	var idx := randi() % masks.size()
	var chosen := masks[idx]

	if chosen is Node3D:
		chosen.visible = true
		current_client_mask_root = chosen

	match chosen.name:
		"ClientMask_1":
			current_mask_type = "mask_1"
			#Global.sound.play_bgm("fino_bgm")
			Global.sound.play_bgm_i(0)
		"ClientMask_2":
			#Global.sound.play_bgm("alien_bgm")
			Global.sound.play_bgm_i(1)
			current_mask_type = "mask_2"
		"ClientMask_3":
			#Global.sound.play_bgm("enano_bgm")
			Global.sound.play_bgm_i(2)
			current_mask_type = "mask_3"
		_:
			current_mask_type = "mask_1"  # fallback

	print("GameScene: tipo de máscara de cliente elegido:", current_mask_type)

func _spawn_player_masks() -> void:
	var scene_for_players: PackedScene = null

	match current_mask_type:
		"mask_1":
			scene_for_players = player_mask_scene_1
		"mask_2":
			scene_for_players = player_mask_scene_2
		"mask_3":
			scene_for_players = player_mask_scene_3
		_:
			scene_for_players = player_mask_scene_1  # fallback

	if scene_for_players == null:
		push_error("GameScene: no hay PackedScene asignado para el tipo " + str(current_mask_type))
		return

	# Instanciar para P1
	p1_mask_root = scene_for_players.instantiate() as Node3D
	add_child(p1_mask_root)
	if p1_spawn:
		p1_mask_root.global_transform = p1_spawn.global_transform

	# Instanciar para P2
	p2_mask_root = scene_for_players.instantiate() as Node3D
	add_child(p2_mask_root)
	if p2_spawn:
		p2_mask_root.global_transform = p2_spawn.global_transform

	p1_mask_root.add_to_group("player1_mask")
	p2_mask_root.add_to_group("player2_mask")
	
	print("GameScene: instanciadas máscaras de jugador de tipo", current_mask_type)
	
func _find_skeleton_in(root: Node) -> Skeleton3D:
	if root == null:
		return null
	if root is Skeleton3D:
		return root as Skeleton3D

	for child in root.get_children():
		var skel := _find_skeleton_in(child)
		if skel != null:
			return skel
	return null
