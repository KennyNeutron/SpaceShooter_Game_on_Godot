extends Node

@onready var pause_panel: Panel = %PausePanel

@warning_ignore("unused_parameter")
func _process(delta):
	var esc_button = Input.is_action_just_pressed("pause")
	if (esc_button == true):
		get_tree().paused = true
		pause_panel.show()

func _on_resume_pressed():
	get_tree().paused = false
	pause_panel.hide()

func _on_quit_pressed():
	get_tree().quit()
