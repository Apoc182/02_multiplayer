extends ActorState


@export var move_state: ActorState


func _animation_finished():
    state_machine.change_state(move_state)
