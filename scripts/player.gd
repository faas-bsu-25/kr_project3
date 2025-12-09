@icon("res://assets/node_icons/icon_character.png")
class_name Player
extends Mobile


## When the player is hurt, it announces this to its children and others via this signal.
signal on_hurt

## State machine, mainly used with children in composition pattern.
##
## It is generally safer for a child node to reference a parent node,
##  especially @onready, than for a parent to reference a child.
## If a child is loaded, its parent is loaded. 
## The same cannot be said for the other way around.
enum State { 
	IDLE,	## player is stationary [default state]
	WALK,	## player is moving
	HURT,   ## player is hurt, and can neither idle nor walk
	ATTACK, ## player is actively using sword or Tome
}

## Base movement speed
@export var walkspeed := 5000.0
## Initial knockback speed
@export var knockback_impulse := 200.0
## While hitstunned/knockbacked, each tick multiplies the player's velocity by this percentage.
## Ex. if a player's knockback speed is 100m/s, 95% knockback_friction reduces the speed to 95m/s.
@export_range(0.0, 100.0, 0.01, "suffix:%") var knockback_friction := 95.0 # %
## Player regains control once the friction has slowed their velocity to this percent of the knockback impulse
@export_range(0.0, 100.0, 0.01, "suffix:%") var unstun_threshold := 20.0 # %

var state := State.IDLE;

## Convert the "percentage" [0-100] variables to actual decimal percentages on the fly.
## Since these functions are small lambdas that effectively represent a value,
## I shall treat them as variables.
## (Godot lacks a way to export real percentages.)
func actual_kb_friction() -> float: return knockback_friction / 100.0
## See docs for actual_kb_friction()
func actual_unstun_threshold() -> float: return unstun_threshold / 100.0


func _process(_delta: float) -> void:
	_determine_state()


func _physics_process(delta: float) -> void:
	# Move... unless HURT or ATTACKing
	if self.state == Player.State.HURT:
		self.velocity *= actual_kb_friction()
	elif self.state == Player.State.ATTACK:
		self.velocity = Vector2.ZERO
	else:
		var move_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		self.velocity = move_dir * delta * walkspeed;
	
	move_and_slide()


func _determine_state() -> void:
	# HURT state is triggered, unlike IDLE and WALK.
	# When HURT, you cannot move
	if state == State.HURT:
		return
	
	if Input.is_action_pressed("attack"):
		state = State.ATTACK
	elif self.state != State.WALK and self.velocity != Vector2.ZERO:
		self.state = State.WALK
	elif (self.state != State.IDLE) and (self.velocity == Vector2.ZERO):
		self.state = State.IDLE


func attack(victim: Mobile) -> void:
	victim.on_attacked(self)


func on_attacked(attacker: Mobile) -> void:
	self.state = State.HURT
	SoundManager.play_sound(SoundManager.Sound.PLAYER_HURT)
	on_hurt.emit()
	
	print(knockback_impulse)
	
	var knockback_dir: Vector2 = attacker.position.direction_to(self.position)
	var knockback_vec: Vector2 = knockback_dir * knockback_impulse
	print("Knockback force: %f\nKnockback direction: %v	\nKnockback vector: %v\n" 
			% [knockback_impulse, knockback_dir, knockback_vec])
	
	# Maximum velocity is the knockback vector, but minimum is in between.
	# An example would be a player moving right that gets knocked left.
	self.velocity += knockback_vec
	#self.velocity = self.velocity.clamp(-knockback_vec, knockback_vec)
