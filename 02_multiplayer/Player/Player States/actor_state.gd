class_name ActorState
extends State

var actor: Actor
@export var state_animation_name: String


func _enter():
    actor.animation_tree.get("parameters/playback").travel(state_animation_name)


func _animation_finished():
    pass
