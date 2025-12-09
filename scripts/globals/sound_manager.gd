@icon("res://assets/node_icons/icon_sound.png")
#class_name SoundManager - (Globals cannot have classnames)
extends Node
## In some cases, nodes would play sounds but be unable to finish playing.
## The most common example is a node that plays a sound and immediately `queue_free()`s itself.
## To remedy such cases, nodes can ask the globally-loaded SoundManager to play those sounds instead.
##
## As an aside, note to self: be sure to load the SCENE as a global, NOT the script.


## An enum to validate sounds requested via play_sound() and play_sound_pitched().
## Ideally, enum values would be directly applied to the child nodes,
## but this is not possible because child nodes do not have constant values.
##
## Instead, please see SoundManager#_get_sound() for its match expression.
enum Sound {
	MISSILE_SHOOT,
	MISSILE_COLLIDE,
}


## Since enums can only be assigned constants,
## this match function is the next best thing.
## Keep in mind that a default statement will not suffice for a function that returns a variable.
## Godot won't validate the function unless an ultimate return value is provided outside the match expression.
func _get_sound(sound: Sound) -> AudioStreamPlayer:
	match (sound):
		Sound.MISSILE_SHOOT: return $MissileShootSound as AudioStreamPlayer
		Sound.MISSILE_COLLIDE: return $MissileCollideSound as AudioStreamPlayer
	
	return null


## Play a sound from a child AudioStreamPlayer of the same name, if said audio exists.
## Uses pitch_scale of 1.0.
func play_sound(sound: Sound) -> void:
	play_sound_pitched(sound, 1.0)


## Play a sound from a child AudioStreamPlayer of the same name, if said audio exists.
## A pitch_scale can also be applied.
func play_sound_pitched(sound: Sound, pitch_scale: float) -> void:
	var to_play: AudioStreamPlayer = _get_sound(sound)
	
	to_play.pitch_scale = pitch_scale
	to_play.play()
