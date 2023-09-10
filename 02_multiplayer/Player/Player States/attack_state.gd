extends ActorState


func _animation_finished():
    state_machine.change_state("move")
