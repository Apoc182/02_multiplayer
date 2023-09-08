class_name Actor
extends CharacterBody2D


const MOVE_SPEED: int = 480
const KNOCKBACK_SPEED: int = 960

var color: Color = Color.GRAY
var state_machine: StateMachine
var animation_player: AnimationPlayer
var damage_direction: Vector2 = Vector2.ZERO

@export var hurt_state: ActorState

@onready var health: Health = $Health

func is_this_client() -> bool:
    return true

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
    return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()


func _on_hurtbox_hit(damage, direction):
    if not is_this_client():
        return
    health.take_damage(damage)
    damage_direction = direction
    state_machine.change_state(hurt_state)


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
