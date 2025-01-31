extends Area2D

@export var damage = 100

@onready var shieldtimer = $Timer

func _process(delta: float) -> void:
	timer(delta)

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy or area is Burstenemy:
		area.take_damage(damage)
		
func timer(delta):
	if shieldtimer.wait_time > 0.5:
		shieldtimer.wait_time -= delta * 1
	elif shieldtimer.wait_time <= 0.5:
		shieldtimer.wait_time = 0.1
		queue_free()
