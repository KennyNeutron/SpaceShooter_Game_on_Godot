extends Area2D

@export var speed = 100
@export var recover = 1

func _process(delta: float) -> void:
	medkit_position(delta)

func medkit_position(delta):
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var battle_ground = get_node("/root/BattleGround")
		if !battle_ground.FlagBits_PowerUp_Medkit:
			#print("Pop Up Showing")
			body.popup_medkit_powerup()
			body.life(recover)
			battle_ground.FlagBits_PowerUp_Medkit = true
		else:
			#print("Pop Up Not Showing")
			body.life(recover)
		queue_free()
