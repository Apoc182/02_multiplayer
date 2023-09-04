extends Area2D


signal hit(damage)


func take_damage(damage):
    hit.emit(damage)
    print(owner.name + " takes " + str(damage) + " damage")
