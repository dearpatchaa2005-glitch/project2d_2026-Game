extends Enemy

var move_timer: float = 2.0  # เปลี่ยนทิศทุก 2 วินาที
var timer: float = 0.0

func _ready() -> void:
	super._ready()
	var types = Array($Sprite/AnimateSprite.sprite_frames.get_animation_names())
	$Sprite/AnimateSprite.animation = types.pick_random()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# ✅ กลับทิศเมื่อชนกำแพง หรือครบเวลา
	timer += delta
	if is_on_wall() or timer >= move_timer:
		direction *= -1
		timer = 0.0
	
	velocity.x = speed * direction
	move_and_slide()

func _on_state_changed(new_state: Enemy.State) -> void:
	if new_state == Enemy.State.IDLE || new_state == Enemy.State.DEAD:
		$Sprite/AnimateSprite.play("", 0.1)
	else:
		$Sprite/AnimateSprite.play("", 1.0)
