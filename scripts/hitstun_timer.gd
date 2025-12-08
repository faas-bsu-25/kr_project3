@icon("res://assets/node_icons/icon_time.png")
extends Timer


@onready var initial_wait_time: float = self.wait_time
@onready var player: Player = self.get_parent()


func _ready() -> void:
	## specifically connect to the emission of my parent player
	player.attack_player.connect(_on_attack_player);


func _on_attack_player(_attacker: Node2D) -> void:
	self.start(initial_wait_time)


func _on_timeout() -> void:
	player.state = Player.State.IDLE;
