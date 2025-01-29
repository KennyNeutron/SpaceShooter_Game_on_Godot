extends Node2D

@export var enemy_spaceship_scene: Array[PackedScene] = []

@onready var player_spawn = $PlayerSpawnpoint
@onready var bullet_container = $BulletContainer
@onready var timer = $EnemySpawnpoint
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gameover_screen = $UILayer/GameOverScreen

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score

func _ready() -> void:
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

func save_game_data():
	var savefile_data = FileAccess.open("user://save.data", FileAccess.WRITE)
	savefile_data.store_32(high_score)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if timer.wait_time > 0.5:
		timer.wait_time -= delta * 0.005
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5

func player_bullet_shot(bullet_scene, location):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = location
	bullet_container.add_child(bullet)

func _on_enemy_spawnpoint_timeout() -> void:
	var enemy = enemy_spaceship_scene.pick_random().instantiate()
	enemy.global_position = Vector2(randf_range(50, 500), -50)
	enemy.killed.connect(enemyship_killed)
	enemy_container.add_child(enemy)
	
func enemyship_killed(points):
	score += points
	if score > high_score:
		high_score = score

func player_killed():
	gameover_screen.set_score(score)
	gameover_screen.set_high_score(high_score)
	save_game_data()
	await get_tree().create_timer(1.5).timeout
	gameover_screen.visible = true
