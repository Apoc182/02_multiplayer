extends CharacterBody2D


const SPEED: int = 320

var input_enabled: bool = true
var rotate_input_direction: bool = false

@onready var health: Health = $Health

func is_this_client() -> bool:
    return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func _physics_process(_delta):
    if not is_this_client():
        return
        
    if Input.is_action_just_pressed("ui_accept"):
        rotate_input_direction = !rotate_input_direction
        
    var input_direction = get_input_direction()
    if rotate_input_direction:
        input_direction = input_direction.rotated(deg_to_rad(315))
    input_direction = cartesian_to_isometric(input_direction)

    velocity = input_direction * SPEED
    move_and_slide()
    
    $Node/Label.global_position = Vector2(32, 32)
    $Node/Label2.global_position = Vector2(32, 96)
    $Node/Label2.text = "rotate_input_direction = " + str(rotate_input_direction)
    

func _ready():
    $MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func get_input_direction() -> Vector2:
    var input_direction_x = Input.get_axis("move_left", "move_right")
    var input_direction_y = Input.get_axis("move_up", "move_down")
    
    if input_enabled:
        return Vector2(input_direction_x, input_direction_y).normalized()
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


func cartesian_to_isometric(cartesian_vector: Vector2) -> Vector2:
    var isometric_vector = Vector2.ZERO

    isometric_vector.x = cartesian_vector.x - cartesian_vector.y
    isometric_vector.y = (cartesian_vector.x + cartesian_vector.y) / 2

    return isometric_vector
