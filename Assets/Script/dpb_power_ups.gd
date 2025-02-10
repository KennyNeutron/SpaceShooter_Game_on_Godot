extends Area2D

@export var speed = 100

func _process(delta: float) -> void:
	global_pos(delta)

func global_pos(delta):
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var b_grounds = get_node("/root/BattleGround")
		if !b_grounds.FlagBits_PowerUp_DataPacketBomb:
			body.popup_datapacketbomb_powerup() 
			body.spawn_dpb()
			b_grounds.FlagBits_PowerUp_DataPacketBomb = true
		else: 
			body.spawn_dpb()
		queue_free()
