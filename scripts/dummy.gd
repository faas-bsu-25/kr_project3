@icon("res://assets/node_icons/icon_target.png")
extends StaticBody2D


@export var player_to_attack: Player


func _process(_delta: float) -> void:
	# Test - hurt player on command ('H') to test Player.State.HURT
	if Input.is_action_just_pressed("test_hurt_player"):
		player_to_attack.attack_player.emit(self)
