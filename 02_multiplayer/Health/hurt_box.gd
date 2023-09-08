class_name HurtBox
extends Area2D


signal hit(damage, direction)


func take_damage(damage: float, direction: Vector2):
    hit.emit(damage, direction)
    print(owner.name + " takes " + str(damage) + " damage")
