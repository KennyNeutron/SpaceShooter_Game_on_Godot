class_name Player extends CharacterBody2D

signal bullet_shot(bullet_scene, location)
signal killed

@export var speed = 300
@export var shoot_per_sec := 0.3

@onready var muzzle = $Muzzle

var bullet_scene = preload("res://Assets/Scenes/bullet.tscn")
var shoot_cooldown = false

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if !shoot_cooldown:
		shoot_cooldown = true
		shoot()
		await get_tree().create_timer(shoot_per_sec).timeout
		shoot_cooldown = false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	velocity = direction * speed 
	move_and_slide()
	
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func shoot():
	bullet_shot.emit(bullet_scene, muzzle.global_position)

func die():
	killed.emit()
	$AnimatedSprite2D.play("explode_animation")
	await get_tree().create_timer(0.1).timeout
	queue_free()
