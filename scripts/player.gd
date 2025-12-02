@icon("res://assets/node_icons/icon_character.png")
class_name Player
extends CharacterBody2D


enum State { IDLE, WALK }

@export var walkspeed := 2000.0

var state := State.IDLE;


func _process(_delta: float) -> void:
	_determine_state()


func _physics_process(delta: float) -> void:
	var move_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	self.velocity = move_dir * delta * walkspeed;
	move_and_slide()


func _determine_state() -> void:
	if self.state != State.WALK and self.velocity != Vector2.ZERO:
		self.state = State.WALK
	elif (self.state != State.IDLE) and (self.velocity == Vector2.ZERO):
		self.state = State.IDLE
