class_name Burstenemy extends Area2D

signal killed(points)
signal hit

@export var speed = 350
@export var durability = 10
@export var points = 20

func _process(delta: float) -> void:
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func die():
	set_physics_process(false)  
	set_collision_layer_value(1, false)  
	set_collision_mask_value(1, false) 
	$AnimatedSprite2D.play("explode_animation")  
	await get_tree().create_timer(0.1).timeout  
	queue_free() 

func _on_body_entered(body: Node2D) -> void:
	if has_active_shield():
		body.take_damage()
	elif not_active_shield():
		if body is Player:
			autoload.lives -= 1
			if autoload.lives <= 0:
				body.die()
				queue_free()

func take_damage(damage):
	if durability <= 0:
		return
	durability -= damage
	if durability <= 0:
		killed.emit(points)
		die()
	else:
		hit.emit()

func has_active_shield() -> bool:
	return get_node_or_null("EncryptionShield") != null

func not_active_shield():
	return get_node_or_null("EncryptionShield") == null
