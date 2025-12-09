@icon("res://assets/node_icons/icon_target.png")
extends Attackable


@export var player_to_attack: Player


func _process(_delta: float) -> void:
	# Test - hurt player on command ('H') to test Player.State.HURT
	if Input.is_action_just_pressed("test_hurt_player"):
		player_to_attack.attack_player.emit(self)


func _on_attacked(attacker: Attackable) -> void:
	print("Yeowch! %s attacked me!" % attacker.name)
