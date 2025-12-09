@icon("res://assets/node_icons/icon_particle.png")
class_name SoulboundTome
extends Node2D


const MAGIC_MISSILE_SCENE: PackedScene = preload("res://components/magic_missile.tscn")

@onready var player: Player = self.get_parent()
@onready var sprite: PlayerSprite = player.get_node("Sprite")


func _process(_delta: float) -> void:
	if (
		sprite.sprite_frames == sprite.PRIEST_FRAMES 
		and Input.is_action_just_pressed("attack")
	):
		var new_missile: MagicMissile = MAGIC_MISSILE_SCENE.instantiate()
		new_missile.position = player.position
		new_missile.look_at(get_global_mouse_position())
		get_tree().root.add_child(new_missile)
