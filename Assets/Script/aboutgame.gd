extends Node2D

func _on_backbutton_pressed() -> void:
	get_node("/root/autoload").reset_lives()
	get_tree().change_scene_to_file("res://Assets/Scenes/battle_ground.tscn")

func _on_nextbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/aboutgame_2.tscn")
