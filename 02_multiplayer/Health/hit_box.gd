class_name HitBox
extends Area2D


signal hit

@export var damage = 10.0


func _on_area_entered(hurt_box):
    if hurt_box.owner == owner:
        return
    
    var direction = hurt_box.owner.global_position - owner.global_position
    direction = direction.normalized() 

    if hurt_box is HurtBox:
        hurt_box.take_damage(damage, direction)
    
    hit.emit(direction)
