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
		var battle_gs = get_node("/root/BattleGround")
		if !battle_gs.FlagBits_PowerUp_EncryptionShield:
			body.popup_encryptionshield_powerup()
			body.spawn_shield()
			battle_gs.FlagBits_PowerUp_EncryptionShield = true
		else:
			body.spawn_shield()
		queue_free()
