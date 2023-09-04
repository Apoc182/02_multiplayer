extends Node

class Player:
    var id: int
    var name: String
    
    func _init(id: int, name: String):
        self.id = id
        self.name = name
        
var players: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
