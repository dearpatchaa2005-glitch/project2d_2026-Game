extends Area2D

var direction := Vector2.RIGHT
var speed := 320.0
var lifetime := 4.0
var hit := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	queue_redraw()

func setup(dir: Vector2, spd: float) -> void:
	direction = dir.normalized()
	speed = spd
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
	queue_redraw()

func _on_body_entered(body: Node) -> void:
	if hit:
		return
	if body.is_in_group("Player"):
		hit = true
		GameManager.damage(1)
		queue_free()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 13.0, Color("#ff6b35"))
	draw_circle(Vector2.ZERO, 7.0, Color("#ffe26b"))
	draw_circle(Vector2(-8,0), 5.0, Color("#c735ff"))
