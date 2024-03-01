extends CharacterBody2D

@onready var interactive_zone = $InteractiveZone


var direction: Vector2

@export var speed: float = 5

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity =  direction * speed * (delta * 1000)
	move_and_slide()


