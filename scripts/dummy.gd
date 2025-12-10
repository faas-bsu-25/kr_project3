extends Mobile

@export var victim: Mobile


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test_hurt_player"):
		self.attacking.emit(victim)


func _on_attacked_by(_attacker: Mobile) -> void:
	pass


func _on_attacking(victim: Mobile) -> void:
	print("Hurting %s." % victim.name)
	victim.attacked_by.emit(self)


func _on_state_changed(_to_state: Mobile.State) -> void:
	pass
