extends Node


func _on_gameabout_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/aboutgame.tscn")
