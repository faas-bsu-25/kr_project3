@icon("res://assets/node_icons/icon_particle.png")
class_name SoulboundTome
extends Node2D


var SPELL_SCENES: Array[PackedScene] = [
	preload("res://components/magic_missile.tscn"), 
	preload("res://components/magic_blast.tscn"),
]

var SPELL_ICONS: Array[CompressedTexture2D] = [
	preload("res://assets/node_icons/icon_projectile.png"),
	preload("res://assets/node_icons/icon_area_damage.png"),
]

var SPELL_USES: Array[int] = [
	-1, 
	10,
]

var selected_spell: int = 0 # index

@onready var player: Player = self.get_parent()
@onready var player_sprite: PlayerSprite = player.get_node("Sprite")
@onready var sprite: Sprite2D = $Sprite


func _process(_delta: float) -> void:
	if player_sprite.sprite_frames == player_sprite.PRIEST_FRAMES: 
		if Input.is_action_just_pressed("attack"):
			_use_spell()
		if Input.is_action_just_pressed("swap_spell"):
			_swap_spell()
		


func _use_spell() -> void:
	SPELL_USES[selected_spell] -= 1
	
	if selected_spell == 0:
		@warning_ignore("unsafe_method_access")
		var new_missile: MagicMissile = SPELL_SCENES[selected_spell].instantiate()
		new_missile.position = player.position
		new_missile.look_at(get_global_mouse_position())
		get_tree().root.add_child(new_missile)
		
	elif selected_spell == 1:
		@warning_ignore("unsafe_method_access")
		var new_blast: MagicBlast = SPELL_SCENES[selected_spell].instantiate()
		new_blast.position = player.position
		new_blast.position += (
			Vector2(50, 0) 
			if !player_sprite.flip_h
			else Vector2(-50, 0)
		)
		get_tree().root.add_child(new_blast)
	
	if SPELL_USES[selected_spell] == 0:
		SPELL_SCENES.remove_at(selected_spell)
		SPELL_ICONS.remove_at(selected_spell)
		selected_spell = 0
		sprite.set_texture(SPELL_ICONS[selected_spell])


func _swap_spell() -> void:
	selected_spell = (selected_spell + 1) % SPELL_SCENES.size()
	@warning_ignore("unsafe_call_argument")
	sprite.set_texture(SPELL_ICONS[selected_spell])
