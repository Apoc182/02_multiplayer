extends ActorState


@export var attack_state: ActorState


func _physics_update(delta):
    var input_direction = actor.get_input_direction()
    input_direction = actor.cartesian_to_isometric(input_direction)
    
    actor.velocity = input_direction * actor.SPEED
    actor.move_and_slide()
    
    if Input.is_action_just_pressed("action"):
        state_machine.change_state(attack_state)
