extends Label

var HostIP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_text_submitted(new_text: String) -> void:
	HostIP = new_text
	print(HostIP)
