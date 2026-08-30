extends Node2D

@export var speed: float = 100.0
@export var move_distance: float = 150.0
@export var damage: int = 1

var start_x: float = 0.0
var direction: int = 1
var can_damage: bool = true  # ✅ ป้องกันโดนซ้ำ

func _ready():
	start_x = global_position.x
	$Area2D.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta):
	position.x += speed * direction * delta
	
	if position.x > start_x + move_distance:
		direction = -1
	elif position.x < start_x - move_distance:
		direction = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and can_damage:
		can_damage = false
		GameManager.damage(damage)
		# ✅ รอ 1 วินาทีก่อนโดนได้อีก
		await get_tree().create_timer(1.0).timeout
		can_damage = true
