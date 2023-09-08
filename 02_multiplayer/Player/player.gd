class_name Actor
extends CharacterBody2D


var color: Color = Color.GRAY
var state_machine: StateMachine
var animation_tree: AnimationTree
var knockback_direction: Vector2 = Vector2.ZERO
var facing_direction = FacingDirection.RIGHT

const MOVE_SPEED: int = 480
const KNOCKBACK_SPEED: int = 960

enum FacingDirection {LEFT = -1, RIGHT = 1}

@export var hurt_state: ActorState
@export var sword_hit_state: ActorState

@onready var health: Health = $Health


func _ready():
    $MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
    $Sprite2D.modulate = color
    $Label.text = GameManager.players[multiplayer.get_unique_id()].name
    
    animation_tree = $AnimationTree
    state_machine = $StateMachine
    state_machine.init(self)


func _physics_process(delta):
    if not is_this_client():
        return
    
    state_machine._physics_update(delta)


func is_this_client() -> bool:
    return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()


func get_input_direction() -> Vector2:
    var input_direction_x = Input.get_axis("move_left", "move_right")
    var input_direction_y = Input.get_axis("move_up", "move_down")
    return Vector2(input_direction_x, input_direction_y)


func _on_hurtbox_hit(damage, direction):
    if not is_this_client():
        return
    
    health.take_damage(damage)
    knockback_direction = direction
    state_machine.change_state(hurt_state)


func _on_sword_hit(direction):
    if not is_this_client():
        return
    
    knockback_direction = direction
    state_machine.change_state(sword_hit_state)


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


func set_facing_direction(direction: float):
    if direction < 0:
        facing_direction = FacingDirection.LEFT
    if direction > 0:
        facing_direction = FacingDirection.RIGHT

    animation_tree.set("parameters/idle/blend_position", facing_direction)
    animation_tree.set("parameters/slash/blend_position", facing_direction)
    animation_tree.set("parameters/hurt/blend_position", facing_direction)
    animation_tree.set("parameters/hit/blend_position", facing_direction)
