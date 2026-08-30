class_name Enemy
extends CharacterBody2D
enum State {
	IDLE,
	WALK,
	PATROL,
	CHASE,
	ATTACK,
	REST,
	DAMAGED,
	DEAD
}

var state = State.IDLE
var label: String = "enemy"
var speed: float = 100.0
var hp: int = 3
var max_hp: int = 3
var attack_damage: int = 1
var chase_range: float = 0.0
var attack_range: float = 50.0
var direction: int = 1
func _ready() -> void:
	pass

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
func take_damage(val: int = 1):
	hp -= val
	if hp <= 0:
		GameManager.enemy_died(self)
		queue_free()
