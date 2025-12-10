class_name HurtstunTimer
extends Timer

@onready var player: Player = self.get_parent()

func control_hurt_state(duration: float) -> void:
	player.state_changed.emit(Player.State.HURT)
	self.start(duration)


func _on_timeout() -> void:
	player.state_changed.emit(Player.State.IDLE)
