class_name Actor
extends CharacterBody2D


const SPEED: int = 480

var color: Color
var state_machine: StateMachine
var animation_player: AnimationPlayer

@export var input_enabled: bool = true

@onready var health: Health = $Health


func is_this_client() -> bool:
    return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func _physics_process(delta):
    if not is_this_client():
        return
    state_machine._physics_update(delta)


func _ready():
    $MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
    $Sprite2D.modulate = color
    $Label.text = GameManager.players[multiplayer.get_unique_id()].name
    animation_player = $AnimationPlayer
    state_machine = $StateMachine
    state_machine.init(self)


func get_input_direction() -> Vector2:
    if input_enabled:
        return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
    else:
        return Vector2.ZERO


func _on_hurtbox_hit(damage, direction):
    if not is_this_client():
        return
    health.take_damage(damage)


func _on_health_changed(current_health):
    if not is_this_client():
        return
    print(name + " has " + str(current_health) + " health remaining")
    if current_health <= 0:
        print (name + " is dead")
        hide()


func cartesian_to_isometric(cartesian_vector: Vector2) -> Vector2:
    var isometric_vector = Vector2.ZERO
    cartesian_vector = cartesian_vector.rotated(deg_to_rad(315))
    
    isometric_vector.x = cartesian_vector.x - cartesian_vector.y
    isometric_vector.y = (cartesian_vector.x + cartesian_vector.y) / 2
    
    return isometric_vector.normalized()
