extends ActorState


@export var move_state: ActorState


func _enter():
    actor.velocity = actor.KNOCKBACK_SPEED * actor.damage_direction
    super()


func _physics_update(delta):
    actor.move_and_slide()


func _animation_finished():
    state_machine.change_state(move_state)
