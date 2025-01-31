extends Control

func _on_restart_pressed() -> void:
	get_node("/root/autoload").reset_lives()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

func set_score(value):
	$Panel/Score.text = "Score: " + str(value)

func set_high_score(value):
	$Panel/HighScore.text = "Hi-Score: " + str(value)
