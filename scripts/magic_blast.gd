@icon("res://assets/node_icons/icon_area_damage.png")
class_name MagicBlast
extends GPUParticles2D


func _ready() -> void:
	print("A new blast is here!")
	SoundManager.play_sound(SoundManager.Sound.BLAST_EXPLOSION)
	self.emitting = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("kaboom!")
	if body is Mobile:
		(body as Mobile).on_attacked(null)


func _on_finished() -> void:
	print("bye!")
	self.queue_free()
