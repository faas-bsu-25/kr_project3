@abstract class_name Mobile
extends CharacterBody2D
## The name "mobile" is effectively synonymous to "mobile" entities in Minecraft,
## which are far more commonly and hereby referred to as "mobs".
##
## A mob is stateful. 
## A mob can exist in any one state at a time, and it emits a signal when it changes state.
## A mob may exist in any one of the following states:
## - Attack
## - Death
## - Hurt
## - Idle
## - Walk
## See [enum Mobile.State] for more information.
##
## A mob can attack and be attacked.
## When Mob A attacks Mob B, Mob A is referred to as the "attacker" and Mob B is referred to as the "victim".
## Both mobs emit a respective signal during an attack. 
## Mob A emits [signal Mobile.attacking], and Mob B emits [signal Mobile.attacked_by].
##
## For convenience, a mob can optionally specify a target.
## The target may not necessarily be an attacker or victim.
## Rather, methods are provided for a mob to act in relation to its target.
##
## A mob is event-driven. 
## Rather than invoke a connected method itself, a mob should signal itself.
## Ex. to run a code when a mob is attacked, the mob should emit its [signal Mobile.attacked_by] signal.


## Signal used to change state. Invokes [method Mobile._on_state_changed].
signal state_changed(to: Mobile.State)
## Signal used when attacking a given victim. Invokes [method Mobile._on_attacking].
signal attacking(victim: Mobile)
## Signal used when attacked by a given attacker. Invokes [method Mobile.on_attacked_by]
signal attacked_by(attacker: Mobile)

## The states in which a mob can exist. 
## The usage and changing of these states is entirely dependent on the implementing subclass.
enum State {
	ATTACK,	## This mob is currently attacking a victim
	DEATH,  ## This mob dead, likely as the result of being attacked.
	HURT,	## This mob is the current victim of an attack.
	IDLE,	## [b]Default state.[/b] This mob is not in any other state.
	WALK,	## This mob is in motion, but not involved in an attack.
}

## The state in which the mob currently exists.
var _state: State = State.IDLE


func _ready() -> void:
	# connect the mob's signals to related methods
	self.state_changed.connect(_init_on_state_changed)
	self.attacking.connect(_on_attacking)
	self.attacked_by.connect(_on_attacked_by)


# Privately changes the mob's state before running the event-related implementation
func _init_on_state_changed(to: Mobile.State) -> void:
	self._state = to
	self._on_state_changed(to)


@abstract func _on_state_changed(to: Mobile.State) -> void

@abstract func _on_attacking(victim: Mobile) -> void

@abstract func _on_attacked_by(attacker: Mobile) -> void


func get_state() -> Mobile.State:
	return self._state
