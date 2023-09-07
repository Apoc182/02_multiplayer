extends Node

@export var address: String = "0.0.0.0"
@export var port: int = 8910
@export var max_player_count: int = 2

var peer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    multiplayer.peer_connected.connect(peer_connected)
    multiplayer.peer_disconnected.connect(peer_disconnected)
    multiplayer.connected_to_server.connect(connected_to_server)
    multiplayer.connection_failed.connect(connection_failed)
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer
    print("Waiting for players...")
    
    
# Client only
func connected_to_server() -> void:
    print("Connected to server.")
    
func connection_failed() -> void:
    print("Connection failed.")

# Called from everyone
func peer_disconnected(id: int) -> void:
    print("Player " + str(id) + " disconnected.")

func peer_connected(id: int) -> void:
    print("Player " + str(id) + " connected.")
