extends Area2D

@export var speed = 600
@export var damage = 10

func _ready() -> void:
	add_to_group("bullets")

func _on_bullet_disappeared():
	remove_from_group("bullets")
	queue_free()

func _process(delta: float) -> void:
	global_position.y += -speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy or area is Burstenemy:
		area.take_damage(damage)
		queue_free()
