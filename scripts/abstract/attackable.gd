@abstract class_name Attackable
extends CharacterBody2D


signal attacked(attacker: Attackable)


func _ready() -> void:
	self.attacked.connect(_on_attacked)

func attack(victim: Attackable) -> void:
	victim.attacked.emit(self)

@abstract func _on_attacked(attacker: Attackable) -> void
