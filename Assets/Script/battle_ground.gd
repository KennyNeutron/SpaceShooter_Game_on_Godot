extends Node2D

@export var enemy_spaceship_scene: Array[PackedScene] = []
@export var missile_scene: PackedScene = preload("res://Assets/Scenes/antivirus_missle.tscn")
@export var firewall_scene: PackedScene = preload("res://Assets/Scenes/firewall_canon.tscn")

@onready var player_spawn = $PlayerSpawnpoint
@onready var bullet_container = $BulletContainer
@onready var enemybullet_container = $EnemyBulletContainer
@onready var powerup_container = $PowerUpContainer
@onready var timer = $EnemySpawnpoint
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gameover_screen = $UILayer/GameOverScreen
@onready var bullet_sound = $SFX/BulletSound
@onready var hit_sound = $SFX/HitSound
@onready var explode_sound = $SFX/ExplodeSound

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score

@onready var time_label = $UILayer/HUD/Timer/time
var time = 0.0

@onready var playerhp_label = $UILayer/HUD/PlayerHp/playerhp

func _ready() -> void:
	player_data()

func save_game_data():
	var savefile_data = FileAccess.open("user://save.data", FileAccess.WRITE)
	savefile_data.store_32(high_score)

func _process(delta):
	health_label()
	time_start(delta)
	quit_and_reset(delta)

func player_bullet_shot(bullet_scene, location):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = location
	bullet_container.add_child(bullet)
	bullet_sound.play()

func _on_enemy_spawnpoint_timeout() -> void:
	var enemy = enemy_spaceship_scene.pick_random().instantiate()
	enemy.global_position = Vector2(randf_range(50, 500), -50)
	enemy.killed.connect(enemyship_killed)
	enemy.hit.connect(enemy_hit)
	enemy_container.add_child(enemy)
	
func enemyship_killed(points):
	hit_sound.play()
	score += points
	if score > high_score:
		high_score = score

func enemy_hit():
	hit_sound.play()

func player_killed():
	explode_sound.play()
	gameover_screen.set_score(score)
	gameover_screen.set_high_score(high_score)
	save_game_data()
	await get_tree().create_timer(1.5).timeout
	gameover_screen.visible = true

func quit_and_reset(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if timer.wait_time > 0.5:
		timer.wait_time -= delta * 0.05
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5

func player_data():
	var savefile_data = FileAccess.open("user://save.data", FileAccess.READ)
	if savefile_data!=null:
		high_score = savefile_data.get_32()
	else:
		high_score = 0
		save_game_data()
	
	score = 0
	player = get_tree().get_first_node_in_group("player")
	assert(player!=null)
	player.global_position = player_spawn.global_position
	player.bullet_shot.connect(player_bullet_shot)
	player.killed.connect(player_killed)
	player.addlife.connect(add_life)
	player.missiles.connect(spawn_missiles)
	player.firewall.connect(firewall_canons)
	player.stop.connect(stop)

func add_life(recover: int) -> void:
	autoload.lives += recover

func time_start(delta):
	time += delta
	var total_seconds = int(time)
	@warning_ignore("integer_division")
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	
	time_label.text = "%02d:%02d" % [minutes, seconds]

func health_label():
	playerhp_label.text = str(autoload.lives)

func spawn_missiles():
	call_deferred("player_spawn_missile")

func player_spawn_missile():
	var missile = missile_scene.instantiate()
	missile.global_position = Vector2(randf_range(50, 500), 970) 
	powerup_container.add_child(missile)

func firewall_canons():
	call_deferred("player_spawn_firewallcanon")

func player_spawn_firewallcanon():
	for i in range(10):
		var firewall = firewall_scene.instantiate()
		firewall.global_position = Vector2(randf_range(50, 500), 960)
		powerup_container.add_child(firewall)

func stop():
	set_process(false)
