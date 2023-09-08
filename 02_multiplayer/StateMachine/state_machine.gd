class_name StateMachine
extends Node


@export var current_state: State


func init(_owner):
    for child in get_children():
        if(child is State):
            child.state_machine = self
    current_state._enter()


func _update(delta):
    current_state._update(delta)


func _physics_update(delta):
    current_state._physics_update(delta)


func change_state(new_state: State):
    if current_state:
        current_state._exit()
    current_state = new_state
    current_state._enter()
