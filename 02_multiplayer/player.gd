extends CharacterBody2D


const SPEED: int = 320


func _physics_process(_delta):
    var input_direction = get_input_direction()
    velocity = input_direction.normalized() * SPEED
    move_and_slide()


func get_input_direction() -> Vector2:
    var input_direction_x = Input.get_axis("move_left", "move_right")
    var input_direction_y = Input.get_axis("move_up", "move_down")
    return Vector2(input_direction_x, input_direction_y)
