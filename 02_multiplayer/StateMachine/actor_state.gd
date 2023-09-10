class_name ActorState
extends State

var actor: Actor


func _enter():
    actor.animation_tree.get("parameters/playback").travel(state_name)


func _animation_finished():
    pass
