extends Node3D

const MASK_NODES := ["cara1", "cara2"]

@onready var camera: Camera3D = $Camera3D
@onready var play_button: Button = $UI/Control/Button
@onready var label_p1: Label = $UI/Control/HBoxContainer/LabelP1
@onready var label_p2: Label = $UI/Control/HBoxContainer/LabelP2


var ui_root: Control = null

var player1_choice: StringName = ""
var player2_choice: StringName = ""

var p1_mask_node: Node3D = null
var p2_mask_node: Node3D = null

func _ready() -> void:
	ui_root = get_node_or_null("UI/Control")
	if ui_root:
		ui_root.visible = false

	play_button.disabled = true
	label_p1.text = "P1: (sin seleccionar)"
	label_p2.text = "P2: (sin seleccionar)"
	

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.is_action_pressed("A") and (Global.cursors[0] and event.device == Global.cursors[0].DeviceID):
		_handle_mask_click(1, Global.cursors[0].position)
	elif event is InputEventJoypadButton and event.is_action_pressed("A") and (Global.cursors[1] and event.device == Global.cursors[1].DeviceID):
		_handle_mask_click(2, Global.cursors[1].position)

func _handle_mask_click(player: int, mouse_pos: Vector2) -> void:
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * 100.0

	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to)
	var result: Dictionary = space_state.intersect_ray(query)

	if result.is_empty():
		return

	var collider := result["collider"] as Node
	if collider == null:
		return

	var mask_node := collider.get_parent() as Node3D
	if mask_node == null:
		return

	var mask_id: StringName = mask_node.mask_id

	_select_mask(player, mask_node, mask_id)

func _select_mask(player: int, mask_node: Node3D, mask_id: StringName) -> void:
	if player == 1:
		# 1) Si ya tenía esta máscara la deseleccionas
		if p1_mask_node == mask_node:
			_reset_mask(mask_node)
			p1_mask_node = null
			player1_choice = ""
		else:
			# 2) Si la tiene el jugador 2 no deja cogerla
			if p2_mask_node == mask_node:
				return

			# 3) Si tenía otra máscara la resetea
			if p1_mask_node != null:
				_reset_mask(p1_mask_node)

			# 4) Asigna la nueva
			p1_mask_node = mask_node
			player1_choice = mask_id
			_highlight_mask(mask_node, 1)

	else: # lo mismo pal jugador 2
		if p2_mask_node == mask_node:
			_reset_mask(mask_node)
			p2_mask_node = null
			player2_choice = ""
		else:
			if p1_mask_node == mask_node:
				return

			if p2_mask_node != null:
				_reset_mask(p2_mask_node)

			p2_mask_node = mask_node
			player2_choice = mask_id
			_highlight_mask(mask_node, 2)

	_update_ui()

func _reset_mask(mask_node: Node3D) -> void:
	var mesh := mask_node.get_node_or_null("Armature/Skeleton3D/mascaraPrueba") as MeshInstance3D
	if mesh == null:
		return

	if mesh.material_override == null:
		return

	var mat := mesh.material_override as StandardMaterial3D
	if mat == null:
		return

	mat.albedo_color = Color(1.0, 1.0, 1.0)

func _reset_all_masks() -> void:
	for name in MASK_NODES:
		var mask_node := get_node_or_null(name) as Node3D
		if mask_node:
			_reset_mask(mask_node)  

func _highlight_mask(mask_node: Node3D, player: int) -> void:
	var mesh := mask_node.get_node_or_null("Armature/Skeleton3D/mascaraPrueba") as MeshInstance3D
	if mesh == null:
		return

	if mesh.material_override == null:
		var base_material := mesh.get_active_material(0)
		if base_material == null:
			return
		mesh.material_override = base_material.duplicate()

	var mat := mesh.material_override as StandardMaterial3D
	if mat == null:
		return

	if player == 1:
		mat.albedo_color = Color(1.0, 0.6, 0.6)
	else:
		mat.albedo_color = Color(0.6, 0.6, 1.0)  

func _update_ui() -> void:
	if player1_choice == "":
		label_p1.text = "P1: (sin seleccionar)"
	else:
		label_p1.text = "P1: " + String(player1_choice)

	if player2_choice == "":
		label_p2.text = "P2: (sin seleccionar)"
	else:
		label_p2.text = "P2: " + String(player2_choice)

	play_button.disabled = (player1_choice == "" or player2_choice == "")

func _reset_selection_state() -> void:
	player1_choice = ""
	player2_choice = ""
	p1_mask_node = null
	p2_mask_node = null

	_reset_all_masks()

	_update_ui()

func _on_Button_pressed() -> void:
	Global.player1_mask_id = player1_choice
	Global.player2_mask_id = player2_choice
	
	Global.player1_character = _character_from_mask_id(player1_choice)
	Global.player2_character = _character_from_mask_id(player2_choice)
	
	Global.sound.play_sfx("button_click")
	
	Global.change_scene(Global.Scenes.GAME)

func _character_from_mask_id(mask_id: StringName) -> Global.Character:
	match String(mask_id):
		"mask_1":
			return Global.Character.SUSI
		"mask_2":
			return Global.Character.HERMENEGILDO
		_:
			return Global.Character.SUSI

func on_enable() -> void:
	if ui_root == null:
		ui_root = get_node_or_null("UI/Control")
	
	if ui_root:
		ui_root.visible = true

	process_mode = Node.PROCESS_MODE_INHERIT
	
	_reset_selection_state()

func on_disable() -> void:
	if ui_root == null:
		ui_root = get_node_or_null("UI/Control")

	if ui_root:
		ui_root.visible = false

	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
