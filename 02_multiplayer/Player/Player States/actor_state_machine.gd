class_name ActorStateMachine
extends StateMachine


func init(actor: Actor):
    for child in get_children():
        if(child is State):
            child.state_machine = self
            child.actor = actor
    current_state._enter()


func _on_animation_player_animation_finished(anim_name):
    if anim_name == current_state.state_animation_name:
        current_state._animation_finished()
