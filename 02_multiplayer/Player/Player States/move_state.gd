extends ActorState


func _physics_update(_delta):
    var input_direction = actor.get_input_direction()
    if input_direction.x:
        actor.set_facing_direction(input_direction.x)
    
    actor.velocity = input_direction * actor.MOVE_SPEED
    actor.move_and_slide()
    
    if Input.is_action_just_pressed("action") and state_machine.previous_state_name != "attack":
        state_machine.change_state("attack")
