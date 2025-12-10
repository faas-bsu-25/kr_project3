@icon("res://assets/node_icons/icon_character.png")
class_name Player
extends Mobile


## Base movement speed
@export var walkspeed := 5000.0

## When attacked, player is hurt for this long
@export_range(0.0, 5.0, 0.01, "or_greater", "suffix:seconds") var stun_time := 0.5
## While player is hurt, recoil away from attacker at this speed
@export_range(0.0, 10_000.0, 0.01, "or_greater", "hide_slider") var stun_recoil_speed := 2000.0
## Stored when an attacker hurts the player, the player recoils from the attacker in this direction
var recoil_direction: Vector2

@onready var hurtstun_timer: HurtstunTimer = $HurtstunTimer

func _ready() -> void:
	super._ready()


func _process(_delta: float) -> void:
	# If attacking, change state.
	# _determine_state() will worry about when the action is released.
	if Input.is_action_just_pressed("attack"):
		self._state = State.ATTACK
	
	_determine_state()


func _physics_process(delta: float) -> void:
	if _can_move_freely():
		var walk_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var walk_vector := walk_direction * walkspeed * delta
		self.velocity = walk_vector
	elif self._state == State.HURT:
		var recoil_vector: Vector2 = recoil_direction * stun_recoil_speed * delta
		self.velocity = recoil_vector
	
	move_and_slide()


func _on_state_changed(to_state: Mobile.State) -> void:
	print("State changed to: %s" % to_state)


func _on_attacking(_victim: Mobile) -> void:
	pass


func _on_attacked_by(attacker: Mobile) -> void:
	recoil_direction = attacker.position.direction_to(self.position)
	hurtstun_timer.control_hurt_state(0.5)


func _determine_state() -> void:
	var determined_state: State
	
	# If hurt, stay hurt until something else changes state.
	if self._state == State.HURT:
		return
	
	if self._state == State.ATTACK and not Input.is_action_pressed("attack"):
		determined_state = State.IDLE
	
	if _can_move_freely():
		if self.velocity != Vector2.ZERO:
			determined_state = State.WALK
		else: # self.velocity == Vector2.ZERO
			determined_state = State.IDLE
	
	if determined_state and self._state != determined_state:
		self.state_changed.emit(determined_state)


func _can_move_freely() -> bool:
	return (
		self._state == State.IDLE
		or self._state == State.WALK
	)
