extends Node2D

@export var enemy_spaceship_scene: Array[PackedScene] = []
var power_up_scenes = [
	preload("res://Assets/Scenes/passrockets_power_up.tscn"),
	preload("res://Assets/Scenes/medkit.tscn"),
	preload("res://Assets/Scenes/firewall_power_ups.tscn"),
	preload("res://Assets/Scenes/en_shield_power_up.tscn"),
	preload("res://Assets/Scenes/dpb_power_ups.tscn"),
	preload("res://Assets/Scenes/antivirus_power_up.tscn"),
	preload("res://Assets/Scenes/the_most_ignore_rule.tscn")
]

@export var missile_scene: PackedScene = preload("res://Assets/Scenes/antivirus_missle.tscn")
@export var firewall_scene: PackedScene = preload("res://Assets/Scenes/firewall_canon.tscn")
@export var datapocketbomb_scene: PackedScene = preload("res://Assets/Scenes/data_pocket_bomb.tscn")
@export var encryptionshield_scene: PackedScene = preload("res://Assets/Scenes/encryption_shield.tscn")
@export var passwordrockets_scene: PackedScene = preload("res://Assets/Scenes/password_rockets.tscn")
@export var mostignorerule_barrier_scene: PackedScene = preload("res://Assets/Scenes/tmir_shield_barrier.tscn")

@onready var player_spawn = $PlayerSpawnpoint
@onready var bullet_container = $BulletContainer
@onready var powerup_container = $PowerUpContainer
@onready var timer = $EnemySpawnpoint
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gameover_screen = $UILayer/GameOverScreen
@onready var bullet_sound = $SFX/BulletSound
@onready var hit_sound = $SFX/HitSound
@onready var explode_sound = $SFX/ExplodeSound

@onready var powerup_medkit_description = $FirstCollidePowerUp/MedkitDescription
@onready var powerup_antivirus_description = $FirstCollidePowerUp/AntiVirusDescription
@onready var powerup_firewallCannons_description = $FirstCollidePowerUp/FirewallDescription
@onready var powerup_encryptionshield_description = $FirstCollidePowerUp/ShieldDescription
@onready var powerup_pocketrockets_description = $FirstCollidePowerUp/PassRocketsDescription
@onready var powerup_datapacketbomb_description = $FirstCollidePowerUp/DPBDescription
@onready var powerup_mostignorerule_description = $FirstCollidePowerUp/MostIgnoreRuleDescription
@onready var exit_bttn_of_MIR = $FirstCollidePowerUp/MostIgnoreRuleDescription/exit_bttn_of_MIR

var player = null
var tmir = null
var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score
var last_powerups_spawn_time = -30
var next_powerup_time = randi() % 11 + 10

@onready var time_label = $UILayer/HUD/Timer/time
var time = 0.0

var FlagBits_PowerUp_Medkit = false
var FlagBits_PowerUp_AntiVirus = false
var FlagBits_PowerUp_FireWallCannons = false
var FlagBits_PowerUp_EncryptionShield = false
var FlagBits_PowerUp_PassRockets = false
var FlagBits_PowerUp_DataPacketBomb = false
var FlagBits_PowerUp_MostIgnoreRuleBarrier = false

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

func wait_for_bullets_to_finish():
	while get_tree().get_nodes_in_group("bullets").size() > 0:
		await get_tree().create_timer(0.2).timeout  

func player_killed():
	explode_sound.play()
	await wait_for_bullets_to_finish()

	gameover_screen.set_score(score)
	gameover_screen.set_high_score(high_score)
	save_game_data()
	
	remove_all_powerups()

	await get_tree().create_timer(2.5).timeout
	
	gameover_screen.visible = true

func quit_and_reset(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("restart"):
		get_node("/root/autoload").reset_lives()
		get_tree().reload_current_scene()
	
	if timer.wait_time > 0.5:
		timer.wait_time -= delta * 0.5
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
	player.pocketbomb.connect(pocket_bomb)
	player.shield.connect(player_spawn_shield)
	player.prockets.connect(password_rockets)
	player.ignorerule_barrier.connect(themostignorerule)
	player.stop.connect(stop)
	player.popup_medkit.connect(medkitPopup_description)
	player.popup_antivirus.connect(antivirusPopup_description)
	player.popup_firewallcannons.connect(firewallcannonsPopup_description)
	player.popup_encryptionshield.connect(encryptionshieldPopup_description)
	player.popup_passrockets.connect(passrocketsPopup_description)
	player.popup_datapacketbomb.connect(datapacketbomb_description)
	player.popup_mostignorerule.connect(mostignorerulePopup_description)
	
	if not exit_bttn_of_MIR.is_connected("pressed", Callable(self, "_on_exit_bttn_of_mir_pressed")):
		exit_bttn_of_MIR.connect("pressed", Callable(self, "_on_exit_bttn_of_mir_pressed"))

	
	

func add_life(recover: int) -> void:
	autoload.lives += recover

func time_start(delta):
	time += delta
	var total_seconds = int(time)
	@warning_ignore("integer_division")
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	
	time_label.text = "%02d:%02d" % [minutes, seconds]
	
	if total_seconds - last_powerups_spawn_time >= next_powerup_time:
		spawn_power_up()
		last_powerups_spawn_time = total_seconds
		next_powerup_time = randi() % 11 + randi_range(9,21)

func spawn_power_up():
	var random_power_up_scene = power_up_scenes[randi() % len(power_up_scenes)].instantiate()
	random_power_up_scene.global_position = Vector2(randf_range(50, 500), -50)
	powerup_container.add_child(random_power_up_scene)

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

func password_rockets():
	call_deferred("spawn_pass_rockets")

func spawn_pass_rockets():
	var offset = 40
	for i in range(3):
		var pr = passwordrockets_scene.instantiate()
		pr.position = Vector2(0, offset)
		player.add_child(pr)
		offset -= 50

func pocket_bomb():
	var dpBomb = datapocketbomb_scene.instantiate()
	dpBomb.global_position = player.global_position
	powerup_container.call_deferred("add_child", dpBomb)

func player_spawn_shield():
	call_deferred("encryption_shields")

func encryption_shields():
	var es = encryptionshield_scene.instantiate()
	es.position = Vector2()  # Set local position
	player.add_child(es)

func themostignorerule():
	call_deferred("mostignorerule_barrier")

func mostignorerule_barrier():
	tmir = mostignorerule_barrier_scene.instantiate()
	tmir.global_position = Vector2(-47, -9)
	#print("Spawning power-up barrier at position:", tmir.global_position)
	powerup_container.call_deferred("add_child", tmir)

func remove_all_powerups():
	if tmir != null and tmir.is_inside_tree():
		tmir.queue_free()
		tmir = null

func stop():
	set_process(false)

func medkitPopup_description():
	powerup_medkit_description.visible = true
	get_tree().paused = true

func _on_exit_bttn_of_medkit() -> void:
	get_tree().paused = false
	powerup_medkit_description.visible = false

func antivirusPopup_description():
	powerup_antivirus_description.visible = true
	get_tree().paused = true

func _on_exit_bttn_of_antivirus() -> void:
	get_tree().paused = false
	powerup_antivirus_description.visible = false

func firewallcannonsPopup_description():
	powerup_firewallCannons_description.visible = true
	get_tree().paused = true

func _on_exit_bttn_of_firewall() -> void:
	get_tree().paused = false
	powerup_firewallCannons_description.visible = false

func encryptionshieldPopup_description():
	get_tree().paused = true
	powerup_encryptionshield_description.visible = true
	
func _on_exit_bttn_of_eShields() -> void:
	print("Exit button connected")
	get_tree().paused = false
	powerup_encryptionshield_description.visible = false
	
func passrocketsPopup_description():
	powerup_pocketrockets_description.visible = true
	get_tree().paused = true

func _on_exit_bttn_of_passrockets() -> void:
	get_tree().paused = false
	powerup_pocketrockets_description.visible = false
	
func datapacketbomb_description():
	powerup_datapacketbomb_description.visible = true
	get_tree().paused = true

func _on_exit_bttn_of_dpb_pressed() -> void:
	get_tree().paused = false
	powerup_datapacketbomb_description.visible = false
	
func mostignorerulePopup_description():
	powerup_mostignorerule_description.visible = true
	get_tree().paused = true

func _on_exit_bttn_of_mir_pressed() -> void:
	get_tree().paused = false
	powerup_mostignorerule_description.visible = false
