@icon("res://assets/node_icons/icon_face.png")
@tool
extends AnimatedSprite2D

## "Appearances" (sprite frames) to swap between depending on equipment
const PRIEST_FRAMES = preload("res://resources/player_priest_frames.tres")
const SWORDMAIN_FRAMES = preload("res://resources/player_swordmain_frames.tres")

## This is a setter, a tool script feature, that runs a function
## each time the corresponding export variable changes.
@export_enum("Priest", "Swordmain") var appearance: int:
	set(new_appearance):
		appearance = new_appearance
		match (new_appearance):
			0: ## "Priest"
				self.sprite_frames = PRIEST_FRAMES
			1: ## "Swordmain"
				self.sprite_frames = SWORDMAIN_FRAMES

# I find getting parent in a tool script is a lot less dangerous than getting child.
# Dr. Faas has heard my spiel before.
@onready var player: Player = self.get_parent()


func _process(_delta: float) -> void:
	## Tool scripts also run live in the editor.
	## This is the official way to kep them from running code in the editor.
	if Engine.is_editor_hint():
		return
		
	## Test - swap appearance manually when player presses 'R'
	if Input.is_action_just_pressed("test_swap_appearance"):
		if self.sprite_frames == PRIEST_FRAMES:
			self.sprite_frames = SWORDMAIN_FRAMES
			self.appearance = 1 # "Priest"
		else:
			self.sprite_frames = PRIEST_FRAMES
			self.appearance = 0 # "Swordmain"
	
	## Flip sprite if moving left + reverse
	if player.state != Player.State.HURT:
		if player.velocity.x < 0:
			self.flip_h = true
		elif player.velocity.x > 0:
			self.flip_h = false
	
	## Change animation if state calls for it
	match player.state:
		Player.State.IDLE:
			play("idle")
		Player.State.WALK:
			play("walk")
		## I only want it to play once,
		## so see _on_attack_player()
		#Player.State.HURT:
			#play("hurt")


func _on_attack_player(_attacker: Node2D) -> void:
	play("hurt")
