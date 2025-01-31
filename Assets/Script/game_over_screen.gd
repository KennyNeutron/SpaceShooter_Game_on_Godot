extends Control

func _on_restart_pressed() -> void:
	var restart = Input.is_action_just_pressed("restart")
	if restart == true:
		get_node("/root/autoload").reset_lives()
		get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	var quit = Input.is_action_just_pressed("quit")
	if quit == true:
		get_tree().quit()

func set_score(value):
	$Panel/Score.text = "Score: " + str(value)

func set_high_score(value):
	$Panel/HighScore.text = "Hi-Score: " + str(value)
