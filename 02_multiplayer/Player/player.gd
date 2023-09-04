extends CharacterBody2D


const SPEED: int = 320

@export var input_enabled: bool = true

@onready var health: Health = $Health

func is_this_client() -> bool:
    return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func _physics_process(_delta):
    if not is_this_client():
        return
    var input_direction = get_input_direction()
    velocity = input_direction.normalized() * SPEED
    move_and_slide()

func _ready():
    $MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func get_input_direction() -> Vector2:
    var input_direction_x = Input.get_axis("move_left", "move_right")
    var input_direction_y = Input.get_axis("move_up", "move_down")
    if input_enabled:
        return Vector2(input_direction_x, input_direction_y)
    else:
        return Vector2.ZERO


func _on_hurtbox_hit(damage):
    if not is_this_client():
        return
    health.take_damage(damage)


func _on_health_changed(current_health):
    if not is_this_client():
        return
    print(name + " has " + str(current_health) + " health remaining")
    if current_health <= 0:
        print (name + " is dead")
        queue_free()
