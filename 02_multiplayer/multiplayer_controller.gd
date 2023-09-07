extends Control

@export var port: int = 8910
@export var max_player_count: int = 2

var peer = ENetMultiplayerPeer.new()



# Called when the node enters the scene tree for the first time.
func _ready():
    multiplayer.peer_connected.connect(peer_connected)
    multiplayer.peer_disconnected.connect(peer_disconnected)
    multiplayer.connected_to_server.connect(connected_to_server)
    multiplayer.connection_failed.connect(connection_failed)


# Client only
func connected_to_server() -> void:
    print("Connected to server.")
    send_player_information.rpc_id(1, $Name.text, multiplayer.get_unique_id())
    
func connection_failed() -> void:
    print("Connection failed.")

# Called from everyone
func peer_disconnected(id: int) -> void:
    print("Player " + str(id) + " disconnected.")

func peer_connected(id: int) -> void:
    print("Player " + str(id) + " connected.")
    
@rpc("any_peer")
func send_player_information(name: String, id: int) -> void:
    if not GameManager.players.has(id):
        GameManager.players[id] = GameManager.Player.new(id, name)
    if multiplayer.is_server():
        for i in GameManager.players:
            send_player_information.rpc(GameManager.players[i].name, i)
        

@rpc("any_peer", "call_local")
func start_game():
    var scene = load("res://room.tscn").instantiate()
    scene.player_color = $ColorPickerButton.color
    get_tree().root.add_child(scene)
    hide()

func _on_start_game_pressed():
    start_game.rpc()

func _on_join_game_pressed():
    var address = $Address.text
    peer.create_client(address, port)
    multiplayer.multiplayer_peer = peer
    $StartGame.disabled = true

func _on_host_game_pressed():
    peer = ENetMultiplayerPeer.new()
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer
    print("Waiting for players...")
    send_player_information($Name.text, multiplayer.get_unique_id())
