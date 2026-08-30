extends CharacterBody2D

@export var speed: float = 80.0
@export var move_distance: float = 100.0

var start_y: float = 0.0
var direction: int = 1

func _ready():
	start_y = global_position.y
	add_to_group("enemy")

func _physics_process(delta):
	velocity.y = speed * direction
	if global_position.y > start_y + move_distance:
		direction = -1
	elif global_position.y < start_y - move_distance:
		direction = 1
	move_and_slide()
