extends Area2D

@export var speed = 600
@export var damage = 50

func _process(delta: float) -> void:
	global_pos(delta)

func global_pos(delta):
	global_position.y += -speed * delta
	
func _on_area_entered(area: Area2D) -> void:
	if area is Enemy or area is Burstenemy:
		area.take_damage(damage)
		explode()

func explode():
	$AnimatedSprite2D.play("explosive_animation")
	await get_tree().create_timer(2).timeout
	queue_free()
