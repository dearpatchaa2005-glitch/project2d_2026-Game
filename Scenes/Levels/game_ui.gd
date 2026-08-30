extends CanvasLayer

@onready var heart_icons = [
	$GameUI/TopBar/StatusPanel/Heart1,
	$GameUI/TopBar/StatusPanel/Heart2,
	$GameUI/TopBar/StatusPanel/Heart3,
	$GameUI/TopBar/StatusPanel/Heart4,
	$GameUI/TopBar/StatusPanel/Heart5
]
@onready var crystal_label: Label = $GameUI/TopBar/StatusPanel/CrystalLabel
@onready var coin_label: Label = $GameUI/TopBar/StatusPanel/CoinLabel
@onready var energy_bar: ProgressBar = $GameUI/EnergyBar
@onready var energy_label: Label = $GameUI/EnergyBar/EnergyLabel
@onready var alert_label: Label = $GameUI/BottomBar/AlertLabel

const MAX_ENERGY := 100.0
const SHOOT_ENERGY_COST := 10.0
const ENERGY_REGEN := 18.0
var energy := MAX_ENERGY
var shoot_was_pressed := false

func _ready() -> void:
	energy_bar.max_value = MAX_ENERGY
	energy = MAX_ENERGY
	_update_ui()

func _process(delta: float) -> void:
	_update_ui()

	# Simple energy system for the new stamina/energy bar.
	# Holding shoot consumes energy once per shot; energy regenerates while not shooting.
	if not Input.is_action_pressed("Shoot"):
		energy = min(MAX_ENERGY, energy + ENERGY_REGEN * delta)

	if Input.is_action_just_pressed("Shoot") and energy >= SHOOT_ENERGY_COST:
		energy -= SHOOT_ENERGY_COST

	energy_bar.value = energy
	energy_label.text = "%d/100" % roundi(energy)

func _update_ui() -> void:
	var hp := int(GameManager.get_stat("hp"))
	for i in heart_icons.size():
		heart_icons[i].visible = i < hp

	var crystals := int(GameManager.crystal_collected)
	var required := int(GameManager.crystal_required)
	crystal_label.text = "%d/%d" % [crystals, required]
	coin_label.text = "%d" % int(GameManager.player_stats.data_get("coins"))

	$GameUI/TopBar/btnSound/on.visible = GameManager.sfx_on
	$GameUI/TopBar/btnSound/mute.visible = !GameManager.sfx_on
	$GameUI/TopBar/btnMusic/on.visible = GameManager.music_on
	$GameUI/TopBar/btnMusic/mute.visible = !GameManager.music_on

func alert(text):
	alert_label.text = text
	alert_label.visible = true
	alert_label.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(alert_label, "scale", Vector2(1, 1), 0.3)
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
	if energy >= SHOOT_ENERGY_COST:
		Input.action_press("Shoot")
	else:
		Input.action_release("Shoot")
		alert("Not enough energy!")

func _on_btn_shoot_button_up() -> void:
	Input.action_release("Shoot")

func _on_btn_save_pressed() -> void:
	GameManager.save_game()
	alert("Game is saved.")

func _on_btn_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/menu.tscn")
