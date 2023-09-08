class_name ActorStateMachine
extends StateMachine


func init(actor: Actor):
    for child in get_children():
        if(child is State):
            child.state_machine = self
            child.actor = actor
    current_state._enter()


func _on_animation_tree_animation_finished(_anim_name):
    current_state._animation_finished()
