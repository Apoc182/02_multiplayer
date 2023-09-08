extends ActorState


@export var move_state: ActorState


func _enter():
    actor.velocity = actor.MOVE_SPEED * -actor.knockback_direction
    actor.set_facing_direction(actor.knockback_direction.x)
    super()


func _physics_update(_delta):
    actor.move_and_slide()


func _animation_finished():
    state_machine.change_state(move_state)
