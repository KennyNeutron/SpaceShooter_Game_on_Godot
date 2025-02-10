extends Area2D

@export var speed = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_pos(delta)

func global_pos(delta):
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var b_ground = get_node("/root/BattleGround")
		if !b_ground.FlagBits_PowerUp_PassRockets:
			body.popup_passrockets_powerup()
			body.spawn_passrockets()
			b_ground.FlagBits_PowerUp_PassRockets = true
		else:
			body.spawn_passrockets()
		queue_free()
