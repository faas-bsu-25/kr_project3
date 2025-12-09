@icon("res://assets/node_icons/icon_target.png")
extends Mobile
## Ironically, the Dummy is completely immobile.
## However, it does serve to test player interaction as it relates to
## mobile methods like [Mobile.attack] and [Mobile.on_attack]

@export var mob_to_attack: Mobile


func _process(_delta: float) -> void:
	# Test - hurt player on command ('H') to test Player.State.HURT
	if Input.is_action_just_pressed("test_hurt_player"):
		attack(mob_to_attack)


func attack(victim: Mobile) -> void:
	print("I will hurt you, %s!" % victim.name)
	victim.on_attacked(self)

func on_attacked(attacker: Mobile) -> void:
	print("Owww! That hurt, %s!" % attacker.name)
	SoundManager.play_sound(SoundManager.Sound.HIT_COLLIDE)
