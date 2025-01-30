class_name Enemy extends Area2D

signal killed(points)
signal hit

@export var speed = 150
@export var durability = 20
@export var points = 50

func _process(delta: float) -> void:
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func die():
	$AnimatedSprite2D.play("explode_animation")
	await get_tree().create_timer(0.1).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		autoload.lives -= 1
		if autoload.lives <= 0:
			body.die()
			queue_free()

func take_damage(amount):
	durability -= amount
	if durability <= 0:
		killed.emit(points)
		die()
	else:
		hit.emit()
