@icon("res://assets/node_icons/icon_time.png")
extends Timer


@onready var initial_wait_time: float = self.wait_time
@onready var player: Player = self.get_parent()


func _process(_delta: float) -> void:
	## only allow player to become unstunned if all are true:
	## 1. the player is hurt
	## 2. timer has ended
	## 3. player velocity is below the threshold
	##    (see Player.unstun_threshold)
	if (
		player.state == Player.State.HURT 
		and self.is_stopped() 
		and player.velocity.abs().x < player.knockback_impulse * player.actual_unstun_threshold()
		and player.velocity.abs().y < player.knockback_impulse * player.actual_unstun_threshold()
	):
		player.state = Player.State.IDLE


func _on_attack_player(_attacker: Node2D) -> void:
	self.start(initial_wait_time)
