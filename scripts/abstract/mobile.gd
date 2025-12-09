@abstract class_name Mobile
extends CharacterBody2D
## The name "mobile" is effectively synonymous to "mobile" entities in Minecraft,
## which are far more commonly referred to as "mobs."
## [br]
## [br] A mobile can (optionally)...
## [br] - [method Mobile.attack] attack
## [br] - [method Mobile.on_attacked] be attacked
## [br] - ...
## [br]
## [br]As for *mobilization*, movement-related code varies so greatly
## both in triggers and in bahavioral updates that any node is
## better off handling that logic for themselves.
## [br]
## [br]For any "optional" abstract function(s) that a subclass wishes to ignore,
## it may use the `pass` keyword or leave said function(s) abstract.


## Target another Mobile, which will run code based on this mobile, its attacker.
@abstract func attack(victim: Mobile) -> void

## Targeted by another Mobile, this victim, will run code based on its attacker.
@abstract func on_attacked(attacker: Mobile) -> void


## A convenience subclass of [Mobile] which only attacks with no victim implementation
@abstract class Attacker extends Mobile:
	
	@abstract func attack(victim: Mobile) -> void
	
	func on_attacked(_attacker: Mobile) -> void:
		pass


## A convenience subclass of [Mobile] which only plays the victim with no attack implementation
@abstract class Victim extends Mobile:
	
	func attack(_victim: Mobile) -> void:
		pass
	
	@abstract func on_attacked(attacker: Mobile) -> void
