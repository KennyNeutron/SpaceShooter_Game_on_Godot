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
		var battleground = get_node("/root/BattleGround")
		if !battleground.FlagBits_PowerUp_MostIgnoreRuleBarrier:
			body.popup_mostignorerule_powerup()
			body.spawn_ignorerule_barrier()
			battleground.FlagBits_PowerUp_MostIgnoreRuleBarrier = true
		else:
			body.spawn_ignorerule_barrier()
		queue_free()
