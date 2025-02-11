extends Area2D

@export var damage = 100

@onready var barrier_timer = $Timer

func _process(delta: float) -> void:
	barrierTime(delta)

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy or area is Burstenemy:
		area.take_damage(damage)
	
func barrierTime(delta):
	if barrier_timer.wait_time > 0.5:
		barrier_timer.wait_time -= delta * 1
	elif barrier_timer.wait_time <= 0.5:
		barrier_timer.wait_time = 0.1
		queue_free()
