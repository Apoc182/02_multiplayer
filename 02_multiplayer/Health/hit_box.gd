extends Area2D


signal hit

@export var damage = 10.0


func _on_area_entered(hurt_box):
    if hurt_box.has_method("take_damage") && hurt_box.owner != owner:
        var direction = hurt_box.owner.global_position - owner.global_position
        direction = direction.normalized()
        print(direction)
        hit.emit()
        hurt_box.take_damage(damage, direction)
