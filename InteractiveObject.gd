extends StaticBody2D

@onready var clue = $Label

func _ready():
	clue.text = name
	clue.hide()

func interaction(player):
	player.interactive_zone.delete_body(self)
	queue_free()
