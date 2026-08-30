extends StaticBody2D

func _ready():
	$DetectArea.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if GameManager.has_key:
			queue_free()  # ประตูหายไป ผู้เล่นผ่านได้
