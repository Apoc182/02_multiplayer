extends CharacterBody2D


const SPEED: int = 384

@onready var health: Health = $Health
var color: Color 

func is_this_client() -> bool:
    return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func _physics_process(_delta):
    if not is_this_client():
        return
    
    var input_direction = get_input_direction()
    input_direction = cartesian_to_isometric(get_input_direction())
    
    velocity = input_direction * SPEED
    move_and_slide()


func _ready():
    $MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
    $Sprite2D.modulate = color


func get_input_direction() -> Vector2:
    var input_direction_x = Input.get_axis("move_left", "move_right")
    var input_direction_y = Input.get_axis("move_up", "move_down")
    return Vector2(input_direction_x, input_direction_y)


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


func cartesian_to_isometric(cartesian_vector: Vector2) -> Vector2:
    var isometric_vector = Vector2.ZERO
    cartesian_vector = cartesian_vector.rotated(deg_to_rad(315))
    
    isometric_vector.x = cartesian_vector.x - cartesian_vector.y
    isometric_vector.y = (cartesian_vector.x + cartesian_vector.y) / 2
    
    return isometric_vector.normalized()
