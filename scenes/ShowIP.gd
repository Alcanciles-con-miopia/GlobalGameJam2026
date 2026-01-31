extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ip = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	text = ip
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass