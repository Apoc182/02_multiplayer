class_name Health
extends Node


signal health_changed(current_health)

@export var max_health = 100.0

@onready var current_health = max_health: set = set_health


func set_health(new_value):
    current_health = clamp(new_value, 0, max_health)
    health_changed.emit(current_health)


func take_damage(damage):
    current_health -= damage
