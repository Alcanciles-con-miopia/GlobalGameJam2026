extends Node3D

@onready var result_label: Label = $UI/Control/ResultLabel
var ui_root: Control = null
@onready var herm : AnimatedSprite3D = $Pj1
@onready var susi : AnimatedSprite3D = $Pj2


func _ready() -> void:
	ui_root = get_node_or_null("UI/Control")
	if ui_root:
		ui_root.visible = false

	process_mode = Node.PROCESS_MODE_DISABLED

@onready var camera: Camera3D = $Camera3D

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.is_action_pressed("A"):
		_on_ReplayButton_pressed()

func on_enable() -> void:
	if ui_root == null:
		ui_root = get_node_or_null("UI/Control")

	if ui_root:
		ui_root.visible = true
		
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

	var text := ""
	var winSound := ""
	var loseSound := ""
	match Global.LAST_WINNER:
		"SUSI":
			text = "¡Ha ganado SUSI!"
			winSound = "win_susi"
			herm.play("perder")
			susi.play("ganar")
			loseSound = "lose_hermi"
		"HERMENEGILDO":
			text = "¡Ha ganado HERMENEGILDO!"
			winSound = "win_hermi"
			herm.play("ganar")
			susi.play("perder")
			loseSound = "lose_susi"
		"TIE":
			text = "¡Empate!"
			susi.play("ganar")
			herm.play("ganar")
		_:
			text = "Fin de la ronda"

	result_label.text = text
	Global.sound.play_sfx(winSound)
	Global.sound.play_sfx(loseSound)

func on_disable() -> void:
	if ui_root == null:
		ui_root = get_node_or_null("UI/Control")

	if ui_root:
		ui_root.visible = false

	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_ReplayButton_pressed() -> void:
	Global.reset_round()
	
	Global.sound.play_sfx("button_click")
	Global.change_scene(Global.Scenes.SELECTMASK)
