extends RigidBody2D
func _ready():
	body_entered.connect(_on_body_entered)

func shoot(direction: Vector2, speed: float, lifetime: float):
	apply_impulse(direction * speed)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
	queue_free()
