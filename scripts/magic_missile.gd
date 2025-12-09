@icon("res://assets/node_icons/icon_projectile.png")
@tool
class_name MagicMissile
extends Attackable


@export var move_speed := 200.0

@export_category("Sprite")
@export var sprite_rotation_speed := 10.0
@export_tool_button("Toggle rotation", "ToolRotate") var toggle_rotation := func() -> void: 
	rotating = !rotating
@export_tool_button("Reset rotation", "Button") var reset_rotation := func() -> void:
	rotating = false
	sprite.rotation = 0
	shape.rotation = 0

var rotating := true

@onready var sprite: Polygon2D = $Sprite
@onready var shape: CollisionShape2D = $Shape


func _ready() -> void:
	sprite.rotation = 0;
	shape.rotation = 0;
	
	var pitch_scale := randf_range(0.5, 1.5)
	SoundManager.play_sound_pitched(SoundManager.Sound.MISSILE_SHOOT, pitch_scale)


func _process(delta: float) -> void:
	if rotating:
		sprite.rotation = fmod((sprite.rotation + (sprite_rotation_speed * delta)), 2.0 * PI)
		shape.rotation = fmod((shape.rotation + (sprite_rotation_speed * delta)), 2.0 * PI)
	
	# if in the editor, DO NOT GO BEYOND THIS POINT
	if Engine.is_editor_hint():
		return
	
	# move "forward"
	velocity = transform.x * move_speed * delta
	var collision := move_and_collide(self.velocity)
	
	if collision:
		if collision.get_collider() is Attackable:
			attack(collision.get_collider() as Attackable)
		
		SoundManager.play_sound(SoundManager.Sound.MISSILE_COLLIDE)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()


func _on_attacked(_attacker: Attackable) -> void:
	pass
