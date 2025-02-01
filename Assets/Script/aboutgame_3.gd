extends Node2D

func _on_prevbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/aboutgame_2.tscn")

func _on_nextbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/aboutgame_4.tscn")
