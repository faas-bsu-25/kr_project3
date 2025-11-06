@icon("res://assets/node_icons/player.png")
class_name Player
extends CharacterBody2D


@export var speed := 10000.0


func _physics_process(delta: float) -> void:
	var move_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_dir * speed * delta
	move_and_slide()
