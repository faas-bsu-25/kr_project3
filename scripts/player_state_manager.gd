@icon("res://assets/node_icons/player_state_manager.png")
class_name PlayerStateManager
extends Node


signal state_changed(new_state: State)

enum State {IDLE, WALKING}

@export var state: State = State.IDLE

@onready var player: Player = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var moving := player.velocity != Vector2.ZERO
	
	if not moving and self.state != State.IDLE:
		state_changed.emit(State.IDLE)
	elif moving and self.state != State.WALKING:
		state_changed.emit(State.WALKING)


func _on_state_changed(new_state: PlayerStateManager.State) -> void:
	self.state = new_state
