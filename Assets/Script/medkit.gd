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
		body.life(recover)
		queue_free()
