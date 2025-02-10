class_name Player extends CharacterBody2D

# Spawn Bullets
signal bullet_shot(bullet_scene, location)
signal killed
signal stop
signal addlife
signal missiles
signal firewall
signal pocketbomb
signal shield
signal prockets

# Description Pop Up
signal popup_medkit
signal popup_antivirus
signal popup_firewallcannons
signal popup_encryptionshield
signal popup_passrockets
signal popup_datapacketbomb

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
	player_movement()
	
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func player_movement():
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	velocity = direction * speed 
	move_and_slide()

func shoot():
	bullet_shot.emit(bullet_scene, muzzle.global_position)

func die() -> void:
	killed.emit()
	$AnimatedSprite2D.play("explode_animation")
	await get_tree().create_timer(0.1).timeout
	stop.emit()
	queue_free()

func life(recover) -> void:
	addlife.emit(recover)

func spawn_missile():
	missiles.emit()

func spawn_firewallcanon():
	firewall.emit()

func spawn_dpb():
	pocketbomb.emit()

func spawn_shield():
	shield.emit()

func spawn_passrockets():
	prockets.emit()

func popup_medkit_powerup():
	popup_medkit.emit()

func popup_antivirus_powerup():
	popup_antivirus.emit()

func popup_firewallcannons_powerup():
	popup_firewallcannons.emit()

func popup_encryptionshield_powerup():
	popup_encryptionshield.emit()

func popup_passrockets_powerup():
	popup_passrockets.emit()

func popup_datapacketbomb_powerup():
	popup_datapacketbomb.emit()
