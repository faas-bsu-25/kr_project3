@icon("res://assets/node_icons/icon_character.png")
class_name Player
extends CharacterBody2D


## Other entities call this signal to hurt the player.
## Given this, it makes sense to declare the signal here.
@warning_ignore("unused_signal")
signal attack_player(attacker: Node2D);

enum State { IDLE, WALK, HURT }

@export var walkspeed := 5000.0
@export var knockback_force := 200
@export_range(0.0, 100.0, 0.1, "suffix:%") var knockback_friction := 95 ## %

var state := State.IDLE;
func actual_friction() -> float: return knockback_friction / 100.0


func _process(_delta: float) -> void:
	_determine_state()


func _physics_process(delta: float) -> void:
	## Move unless HURT, as hitstun is active
	if self.state == Player.State.HURT:
		self.velocity *= actual_friction()
	else:
		var move_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		self.velocity = move_dir * delta * walkspeed;
	
	move_and_slide()


func _determine_state() -> void:
	## HURT state is triggered, unlike IDLE and WALK.
	## When HURT, you cannot move
	if state == State.HURT:
		return
	
	if self.state != State.WALK and self.velocity != Vector2.ZERO:
		self.state = State.WALK
	elif (self.state != State.IDLE) and (self.velocity == Vector2.ZERO):
		self.state = State.IDLE


func _on_attack_player(attacker: Node2D) -> void:
	self.state = State.HURT
	
	print(knockback_force)
	
	var knockback_dir: Vector2 = attacker.position.direction_to(self.position)
	var knockback_vec: Vector2 = knockback_dir * knockback_force
	print("Knockback force: %f\nKnockback direction: %v	\nKnockback vector: %v\n" 
			% [knockback_force, knockback_dir, knockback_vec])
	
	self.velocity = knockback_vec
