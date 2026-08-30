extends Button

@export var exitToScene: PackedScene
@export var is_play_again: bool = false

func _on_pressed() -> void:
	if is_play_again:
		# ✅ ใช้ current_level ที่เก็บไว้ใน GameManager
		GameManager.restart()
		get_tree().change_scene_to_file(GameManager.current_level)
	elif exitToScene != null:
		SceneTransition.load_scene(exitToScene)
	else:
		get_tree().change_scene_to_file("res://Scenes/Levels/menu.tscn")
