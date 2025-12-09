@icon("res://assets/node_icons/icon_sound.png")
#class_name SoundManager - (Globals cannot have classnames)
extends Node
## In some cases, nodes would play sounds but be unable to finish playing.
## The most common example is a node that plays a sound and immediately `queue_free()`s itself.
## To remedy such cases, nodes can ask the globally-loaded SoundManager to play those sounds instead.
##
## As an aside, note to self: be sure to load the SCENE as a global, NOT the script.
# About "Globals cannot have classnames":
# When a script/object has a class name, that name is a globally-recognized TYPE identifier.
# When a script/object is added to globals, that name identifies A SINGLE SPECIFIC INSTANCE.
# Due to this, attempting to add a named script/object to globals 
#  creates a clash between these systems and as a result will not work.


## An enum to validate sounds requested via play_sound() and play_sound_pitched().
## Ideally, enum values would be directly applied to the child nodes,
## but this is not possible because child nodes do not have constant values.
##
## Instead, please see SoundManager#_get_sound() for its match pattern.
enum Sound {
	MISSILE_SHOOT,
	MISSILE_COLLIDE,
}


## Since enums can only be assigned constants,
## this match function is the next best thing.
##
## Keep in mind that a default statement will not suffice for a function that returns a variable.
## Godot won't validate the function unless an ultimate return value is provided beyond the match pattern.
func _get_sound(sound: Sound) -> AudioStreamPlayer:
	match (sound):
		Sound.MISSILE_SHOOT: return $Missile/Shoot as AudioStreamPlayer
		Sound.MISSILE_COLLIDE: return $Missile/Collide as AudioStreamPlayer
	
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
