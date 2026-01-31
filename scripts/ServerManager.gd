class_name ServerManager
extends Node

#@export_category("Player")
#@export var Player: PackedScene
#@export_category("Path")
#@export var main_scene: Node
@export_category("Atrubutes")
@export var addres: String
@export var port: int
@export var max_clients: int

var peer = ENetMultiplayerPeer.new()
enum connection {SERVER, CLIENT}
@export var masks: Array[Node] = [] 
var id = 0

#func CreateServer(_port:int = port):
	#peer.create_server(_port, max_clients)
	#checkConnection(connection.SERVER)
	#multiplayer.multiplayer_peer = peer
	#multiplayer.peer_connected.connect(player_connected)
	#multiplayer.connection_failed.connect(failed)
	#multiplayer.connected_to_server.connect(server_success)
	#multiplayer.server_disconnected.connect(server_fail)
	#player_connected(id)
	#print("HOSTEANDO...")
	#
#func failed():
	#print_debug(">>> Conexión del cliente falló.")
#func server_success():
	#print_debug(">>> Conexión a servidor conseguida.")
#func server_fail():
	#print_debug(">>> Conexion a servidor falló.")
#
#func CreateClient(_address: String = addres, _port: int = port):
	#peer.create_client(_address, _port)
	#checkConnection(connection.CLIENT)
	#multiplayer.multiplayer_peer = peer
	#for i in masks:
		#i.visible = true
	#print("CONECTADO...")
#
#func player_connected(idx: int = 1):
	#print_debug("Player ", multiplayer.get_unique_id() , " conectado.")
	#if id < masks.size():
		#masks[id].visible = true
	#else:
		#print_debug("PLAYER ID OUT OF BOUNDS: ", id)
	#id += 1
	##var player = Player.instantiate()
	##player.name = str(id)
	##main_scene.add_child(player, true)
	##print("player conectado")
	#pass
#
#func checkConnection(type: connection):
	#print_debug("PEER CONNECTION STATUS: ", peer.get_connection_status())
	#if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		#if type == connection.SERVER:
			#print_debug("Error al crear el servidor","Error de red")
		#else:
			#print_debug("Error al unirse a la partida", "Error en el servidor")
		#return



# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info = {"name": "Name"}

var players_loaded = 0



func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func CreateClient(address : String):
	if address.is_empty():
		address = "127.0.0.1"
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(addres, port)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	print("CONECTADO...")


func CreateServer():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, max_clients)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	players[1] = player_info
	player_connected.emit(1, player_info)
	print("HOSTEANDO...")


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()


# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)


# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			$/root/Game.start_game()
			players_loaded = 0


# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	print_debug("NEW PLAYER: ", new_player_id)


func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail():
	remove_multiplayer_peer()


func _on_server_disconnected():
	remove_multiplayer_peer()
	players.clear()
	server_disconnected.emit()
