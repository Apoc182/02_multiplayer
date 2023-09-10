class_name StateMachine
extends Node


var state_reference: Dictionary = {}
@export var current_state: State
@export var current_state_name: String
@export var previous_state: State
@export var previous_state_name: String


func init(_owner):
    for child in get_children():
        if(child is State):
            child.state_machine = self
            state_reference[child.state_name] = child
    current_state._enter()


func _process(_delta):
    if previous_state_name != current_state_name:
        previous_state = state_reference.get(previous_state_name)
        current_state = state_reference[current_state_name]
        
        if previous_state:
            previous_state._exit()
        
        current_state._enter()

    previous_state_name = current_state_name


func _update(delta):
    current_state._update(delta)


func _physics_update(delta):
    current_state._physics_update(delta)


func change_state(new_state_name: String):
    var new_state = state_reference[new_state_name]
    current_state_name = new_state_name
    current_state = new_state
