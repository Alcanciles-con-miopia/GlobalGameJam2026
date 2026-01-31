extends Scene


func on_enable() -> void:
	var p1_mask := Global.player1_mask_id
	var p2_mask := Global.player2_mask_id

	print("Máscara P1:", p1_mask)
	print("Máscara P2:", p2_mask)

	# instanciar los modelos configurar el rig blablabla
