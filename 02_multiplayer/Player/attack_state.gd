extends ActorState


@export var move_state: ActorState


func _animation_finished(anim_name):
    if anim_name == state_animation_name:
        state_machine.change_state(move_state)
