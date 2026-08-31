extends CharacterBody2D

signal health_changed(current: int, maximum: int)
signal defeated

@export var max_health: int = 40
@export var move_speed: float = 90.0
@export var attack_interval: float = 1.6
@export var fireball_scene: PackedScene

var health: int = 40
var phase: int = 1
var attack_timer: float = 1.0
var hit_flash: float = 0.0
var defeated_once := false
var player: Node2D

func _ready() -> void:
	add_to_group("Enemy")
	health = max_health
	player = get_tree().get_first_node_in_group("Player")
	health_changed.emit(health, max_health)
	queue_redraw()

func _physics_process(delta: float) -> void:
	if defeated_once:
		return
	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
	attack_timer -= delta
	hit_flash = max(0.0, hit_flash - delta)
	if player != null:
		var distance := player.global_position.x - global_position.x
		if abs(distance) > 180.0:
			velocity.x = sign(distance) * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0.0, move_speed * 3.0 * delta)
		if attack_timer <= 0.0:
			shoot_fireball()
			attack_timer = attack_interval if phase == 1 else attack_interval * 0.55
	move_and_slide()
	queue_redraw()

func take_damage(amount: int = 1) -> void:
	if defeated_once:
		return
	health = max(0, health - amount)
	hit_flash = 0.12
	if health <= max_health / 2 and phase == 1:
		phase = 2
		attack_timer = 0.2
	health_changed.emit(health, max_health)
	if health == 0:
		defeat()
	queue_redraw()

func shoot_fireball() -> void:
	if fireball_scene == null or player == null:
		return
	var fireball = fireball_scene.instantiate()
	get_tree().current_scene.add_child(fireball)
	fireball.global_position = global_position + Vector2(-48 if player.global_position.x < global_position.x else 48, -55)
	var direction: Vector2 = (player.global_position - fireball.global_position).normalized()
	if fireball.has_method("setup"):
		fireball.setup(direction, 300.0 if phase == 1 else 390.0)

func defeat() -> void:
	if defeated_once:
		return
	defeated_once = true
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.25, 1.25), 0.18)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.35)
	await tween.finished
	defeated.emit()
	queue_free()

func _draw() -> void:
	var body_color := Color("#6b46c1") if hit_flash <= 0.0 else Color.WHITE
	# shadow
	draw_ellipse_custom(Vector2(0, 42), Vector2(72, 18), Color(0, 0, 0, 0.35))
	# legs / armor
	draw_colored_polygon(PackedVector2Array([Vector2(-55,25), Vector2(-28,10), Vector2(-18,58), Vector2(-52,58)]), Color("#25214a"))
	draw_colored_polygon(PackedVector2Array([Vector2(55,25), Vector2(28,10), Vector2(18,58), Vector2(52,58)]), Color("#25214a"))
	# body
	draw_colored_polygon(PackedVector2Array([Vector2(-58,-20), Vector2(-38,-60), Vector2(0,-76), Vector2(38,-60), Vector2(58,-20), Vector2(42,35), Vector2(0,55), Vector2(-42,35)]), body_color)
	# armor plates
	draw_colored_polygon(PackedVector2Array([Vector2(-62,-15), Vector2(-82,8), Vector2(-48,18), Vector2(-34,-20)]), Color("#3d2b73"))
	draw_colored_polygon(PackedVector2Array([Vector2(62,-15), Vector2(82,8), Vector2(48,18), Vector2(34,-20)]), Color("#3d2b73"))
	# head
	draw_colored_polygon(PackedVector2Array([Vector2(-40,-70), Vector2(-25,-102), Vector2(0,-116), Vector2(25,-102), Vector2(40,-70), Vector2(25,-42), Vector2(0,-32), Vector2(-25,-42)]), Color("#374e9b"))
	# crystals
	var crystal := Color("#58d8ff") if phase == 1 else Color("#ff4d9d")
	draw_colored_polygon(PackedVector2Array([Vector2(-28,-102), Vector2(-22,-143), Vector2(-10,-112)]), crystal)
	draw_colored_polygon(PackedVector2Array([Vector2(28,-102), Vector2(22,-143), Vector2(10,-112)]), crystal)
	draw_colored_polygon(PackedVector2Array([Vector2(0,-108), Vector2(0,-158), Vector2(14,-116)]), crystal)
	# eyes
	draw_circle(Vector2(-15,-68), 7, Color("#ffdf4a"))
	draw_circle(Vector2(15,-68), 7, Color("#ffdf4a"))
	# core
	draw_circle(Vector2(0,-10), 15, Color("#bdf5ff"))
	draw_circle(Vector2(0,-10), 8, crystal)
	# phase 2 aura
	if phase == 2:
		draw_arc(Vector2.ZERO, 90.0, 0.0, TAU, 32, Color(1,0.2,0.55,0.45), 5.0)

func draw_ellipse_custom(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(24):
		var a := TAU * float(i) / 24.0
		points.append(center + Vector2(cos(a) * radius.x, sin(a) * radius.y))
	draw_colored_polygon(points, color)
