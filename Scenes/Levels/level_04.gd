extends "res://Scenes/Levels/base_level.gd"

@onready var boss = $Boss
@onready var boss_bar: ProgressBar = $BossUI/BossBar
@onready var boss_text: Label = $BossUI/BossName

func _ready() -> void:
	super._ready()
	# Blank Level 4 layout: keep the simple floor/platforms and player,
	# while retaining the boss system and UI. The boss model itself is
	# intentionally invisible as a placeholder.
	$Level/Background1.visible = false
	$Level/Background2.visible = false
	$LevelFinishDoor.visible = false
	$LevelFinishDoor.monitoring = false
	$Player.global_position = Vector2(180, 480)
	$Player/Camera2D.limit_left = 0
	$Player/Camera2D.limit_right = 1600
	$Player/Camera2D.limit_top = 0
	$Player/Camera2D.limit_bottom = 700
	boss.health_changed.connect(_on_boss_health_changed)
	boss.defeated.connect(_on_boss_defeated)
	_on_boss_health_changed(boss.health, boss.max_health)
	$UserInterface.alert("BOSS BATTLE!  Press X to attack")

func _on_boss_health_changed(current: int, maximum: int) -> void:
	boss_bar.max_value = maximum
	boss_bar.value = current
	boss_text.text = "CRYSTAL OVERLORD   %d / %d" % [current, maximum]
	if boss.phase == 2:
		boss_text.text += "   PHASE 2"

func _on_boss_defeated() -> void:
	boss_bar.value = 0
	boss_text.text = "CRYSTAL OVERLORD DEFEATED!"
	$UserInterface.alert("BOSS DEFEATED!")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/game_win.tscn")
