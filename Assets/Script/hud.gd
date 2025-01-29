extends Control

@onready var score = $Sprite2D/Score:
	set(value):
		score.text = str(value)
