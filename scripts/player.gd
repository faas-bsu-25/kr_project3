@icon("res://assets/node_icons/icon_character.png")
class_name Player
extends Mobile


## Base movement speed
@export var walkspeed := 5000.0


func _ready() -> void:
	super._ready()


func _process(_delta: float) -> void:
	# If attacking, override normal state code.
	if Input.is_action_just_pressed("attack"):
		self._state = State.ATTACK
	
	_determine_state()


func _physics_process(delta: float) -> void:
	if _can_move_freely():
		var walk_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var walk_vector := walk_direction * walkspeed * delta
		
		self.velocity = walk_vector
		move_and_slide()


func _on_state_changed(_to: Mobile.State) -> void:
	print("State changed to: %s" % _to)


func _on_attacking(_victim: Mobile) -> void:
	pass


func _on_attacked_by(_attacker: Mobile) -> void:
	pass


func _determine_state() -> void:
	var determined_state: State
	
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
