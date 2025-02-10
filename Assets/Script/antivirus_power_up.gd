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
		var battle_grounds = get_node("/root/BattleGround")
		if !battle_grounds.FlagBits_PowerUp_AntiVirus:
			#print("Pop Up Showing")
			body.popup_antivirus_powerup()
			body.spawn_missile()
			battle_grounds.FlagBits_PowerUp_AntiVirus = true
		else:
			#print("Pop Up Not Showing")
			body.spawn_missile()
		queue_free()
