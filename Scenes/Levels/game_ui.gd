extends CanvasLayer

@onready var score_label = %ScoreLabel
@onready var heart_label = %HeartLabel
@onready var alert_label: Label = $GameUI/BottomBar/AlertLabel

func _process(_delta):
	score_label.text = "Score: %d" % GameManager.player_stats.data_get("score")
	
	var hp = GameManager.get_stat("hp")
	var hearts = ""
	for i in range(hp):
		hearts += "❤️"
	heart_label.text = hearts
	
	$GameUI/TopBar/btnSound/on.visible   = GameManager.sfx_on
	$GameUI/TopBar/btnSound/mute.visible = !GameManager.sfx_on
	$GameUI/TopBar/btnMusic/mute.visible = !GameManager.music_on

func alert(text):
	alert_label.text = text
	alert_label.visible = true
	alert_label.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(alert_label, "scale", Vector2(1,1), 0.3)
	await get_tree().create_timer(2).timeout
	alert_label.visible = false

func _on_btn_sound_pressed() -> void:
	GameManager.sfx_on = !GameManager.sfx_on
	GameManager.update_option()
	GameManager.save_option()

func _on_btn_music_pressed() -> void:
	GameManager.music_on = !GameManager.music_on
	GameManager.update_option()
	GameManager.save_option()

func _on_btn_left_pressed() -> void:
	Input.action_press("Left")

func _on_btn_left_released() -> void:
	Input.action_release("Left")

func _on_btn_up_pressed() -> void:
	Input.action_press("Jump")

func _on_btn_up_released() -> void:
	Input.action_release("Jump")

func _on_btn_right_pressed() -> void:
	Input.action_press("Right")

func _on_btn_right_released() -> void:
	Input.action_release("Right")

func _on_btn_shoot_button_down() -> void:
	Input.action_press("Shoot")

func _on_btn_shoot_button_up() -> void:
	Input.action_release("Shoot")

func _on_btn_save_pressed() -> void:
	GameManager.save_game()
	alert("Game is saved.")

# ✅ เพิ่มฟังก์ชัน Exit
func _on_btn_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/menu.tscn")
