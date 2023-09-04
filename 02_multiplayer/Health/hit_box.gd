extends Area2D


signal hit

@export var damage = 10.0


func _on_area_entered(hurt_box):
    if hurt_box.has_method("take_damage"):
        hit.emit()
        hurt_box.take_damage(damage)
