extends Area2D

@export var damage = 100

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy or area is Burstenemy:
		area.take_damage(damage)
		explode()

func explode():
	$AnimatedSprite2D.play("explosive_animation")
	await get_tree().create_timer(0.3).timeout
	queue_free()
