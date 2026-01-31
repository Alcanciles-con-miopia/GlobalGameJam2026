extends Node3D

@onready var result_label: Label = $UI/Control/ResultLabel
var ui_root: Control = null

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
		
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

	var text := ""
	match Global.LAST_WINNER:
		"P1":
			text = "¡Ha ganado el Jugador 1!"
		"P2":
			text = "¡Ha ganado el Jugador 2!"
		"TIE":
			text = "¡Empate!"
		_:
			text = "Fin de la ronda"

	result_label.text = text

func on_disable() -> void:
	if ui_root == null:
		ui_root = get_node_or_null("UI/Control")

	if ui_root:
		ui_root.visible = false

	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_ReplayButton_pressed() -> void:
	Global.reset_round()
	Global.change_scene(Global.Scenes.SELECTMASK)
