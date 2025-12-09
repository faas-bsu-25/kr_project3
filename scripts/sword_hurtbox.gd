@icon("res://assets/node_icons/icon_sword.png")
class_name SwordHurtbox
extends Area2D


## The parent player of the sword('s hurtbox)
@onready var player: Player = self.get_parent()
## The animated sprite, the frames of which this hurtbox is dependent upon
## Given this dependency, the hurtbox enables and disables its shapes during the attack animation.
@onready var sprite: PlayerSprite = player.get_node("Sprite")

## The first hurtbox shape, which activates on frame 3.
@onready var box_one: CollisionPolygon2D = $FirstSwingShape
## The second hurtbox shape, which activates on frames 6 and 7.
@onready var box_two: CollisionPolygon2D = $SecondSwingShape

## The sword swinging sound
@onready var swing_sound: AudioStreamPlayer = $SwingSound


## Using the `attack_2` animation...
## 1st swing: frame 3 only
## 2nd swing: frames 6 and 7
func _on_sprite_frame_changed() -> void:
	# If the player hasn't loaded, 
	# or if not using a sword, 
	# don't check frames
	if (
		!player or !sprite
		or sprite.sprite_frames != sprite.SWORDMAIN_FRAMES
	):
		return
	
	# Disable hurtboxes and return if the sprite isn't attacking
	if player.state != Player.State.ATTACK or sprite.animation != "attack_2":
		if !box_one.disabled:
			box_one.disabled = true
		if !box_two.disabled:
			box_two.disabled = true
		return
	
	# Enable/Disable hurtboxes when needed
	match (sprite.frame):
		3:
			box_one.disabled = false
			swing_sound.play()
		4:
			box_one.disabled = true
		6:
			box_two.disabled = false
			swing_sound.play()
		8:
			box_two.disabled = true


func _on_body_entered(body: Node2D) -> void:
	print("I hit a %s!" % body.name)
	SoundManager.play_sound(SoundManager.Sound.MISSILE_COLLIDE)
	
	if body is Attackable:
		player.attack(body as Attackable)
