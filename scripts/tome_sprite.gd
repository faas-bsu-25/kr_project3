@icon("res://assets/node_icons/icon_face.png")
extends Sprite2D


@onready var player_sprite: PlayerSprite = self.get_parent().get_parent().get_node("Sprite")


func _ready() -> void:
	self.visible = player_sprite.sprite_frames == player_sprite.PRIEST_FRAMES


func _on_player_sprite_frames_changed() -> void:
	self.visible = player_sprite.sprite_frames == player_sprite.PRIEST_FRAMES
