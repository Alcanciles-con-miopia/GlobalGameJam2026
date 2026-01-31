extends Scene

@onready var client_label: Label = $UI/Control/ClientLabel
@onready var countdown_timer: Timer = $UI/Control/CountdownTimer
@onready var timer_label: Label = $UI/Control/CountdownTimer/Label
@onready var comparer: Node = $CompareMasks

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
		
	process_mode = Node.PROCESS_MODE_INHERIT
	
	var p1_mask := Global.player1_mask_id
	var p2_mask := Global.player2_mask_id

	print("Máscara P1:", p1_mask)
	print("Máscara P2:", p2_mask)
	
	#esto es un placeholder ns si vamos a hacer json o escribir aqui o nose
	client_label.text = "¡Haz que la máscara se parezca al cliente!"

	countdown_timer.start()

func on_disable() -> void:
	if ui_root == null:
		ui_root = get_node_or_null("UI/Control")

	if ui_root:
		ui_root.visible = false
	
	if timer_label:
		timer_label.visible = false
		timer_label.text = ""

	process_mode = Node.PROCESS_MODE_DISABLED

func _on_CountdownTimer_timeout() -> void:
	if comparer and comparer.has_method("finish_round"):
		comparer.finish_round()
	else:
		Global.LAST_WINNER = "TIE"
		Global.change_scene(Global.Scenes.FINALSCENE)
