class_name ServerManager
extends Node

#@export_category("Player")
#@export var Player: PackedScene
#@export_category("Path")
#@export var main_scene: Node
@export_category("Atrubutes")
@export var addres: String
@export var port: String
@export var max_clients: int

var peer = ENetMultiplayerPeer.new()
enum connection {SERVER, CLIENT}
@export var masks: Array[Node] = [] 
var nextPlayer = 0

func CreateServer(_port: String = port):
	peer.create_server(_port.to_int(), max_clients)
	checkConnection(connection.SERVER)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(player_connected)
	player_connected(0)
	print("HOSTEANDO...")

func CreateClient(_address: String = addres, _port: String = port):
	peer.create_client(_address, _port.to_int())
	checkConnection(connection.CLIENT)
	multiplayer.multiplayer_peer = peer
	print("CONECTADO...")

func player_connected(id: int = 1):
	print_debug("Player ", id, " conectado.")
	#if id < masks.size():
		#masks[id].visible = true
	#else:
		#print_debug("PLAYER ID OUT OF BOUNDS: ", id)
	#nextPlayer += 1
	#var player = Player.instantiate()
	#player.name = str(id)
	#main_scene.add_child(player, true)
	#print("player conectado")
	pass

func checkConnection(type: connection):
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		if type == connection.SERVER:
			OS.alert("Error al crear el servidor","Error de red")
		else:
			OS.alert("Error al unirse a la partida", "Error en el servidor")
		return
