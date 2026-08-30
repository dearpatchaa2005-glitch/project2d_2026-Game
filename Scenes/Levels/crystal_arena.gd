extends Node2D

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	# background
	draw_rect(Rect2(0,0,1600,700), Color("#101329"))
	# distant cave walls
	for i in range(9):
		var x := float(i * 210)
		draw_colored_polygon(PackedVector2Array([Vector2(x,0), Vector2(x+80,80), Vector2(x+145,35), Vector2(x+210,110), Vector2(x+210,700), Vector2(x,700)]), Color("#182044"))
	# cave pillars
	for x in [55.0, 380.0, 720.0, 1080.0, 1510.0]:
		draw_colored_polygon(PackedVector2Array([Vector2(x,0), Vector2(x+35,0), Vector2(x+22,260), Vector2(x-18,310), Vector2(x-8,700), Vector2(x-45,700)]), Color("#242b52"))
	# crystal clusters
	for p in [Vector2(110,515), Vector2(520,520), Vector2(920,525), Vector2(1410,520), Vector2(1340,240), Vector2(300,210)]:
		draw_crystal_cluster(p, 1.0)
	# platforms
	draw_rect(Rect2(0,540,1600,160), Color("#27243b"))
	draw_rect(Rect2(270,425,220,24), Color("#4a3d70"))
	draw_rect(Rect2(650,380,250,24), Color("#4a3d70"))
	draw_rect(Rect2(1030,450,250,24), Color("#4a3d70"))
	# lava trench
	draw_rect(Rect2(520,620,560,80), Color("#8d2434"))
	for x in range(535,1070,45):
		var wave_y := 628.0 + sin(float(x) * 0.04) * 5.0
		draw_circle(Vector2(x,wave_y), 18, Color("#ff7a36"))
	# gate
	draw_arc(Vector2(1500,450), 85, PI, TAU, 32, Color("#49d7ff"), 10.0)
	draw_arc(Vector2(1500,450), 62, PI, TAU, 32, Color("#8c55ff"), 6.0)

func draw_crystal_cluster(p: Vector2, s: float) -> void:
	var c1 := Color("#7d4dff")
	var c2 := Color("#3bd6ff")
	draw_colored_polygon(PackedVector2Array([p+Vector2(-42,35)*s,p+Vector2(-20,-45)*s,p+Vector2(-3,35)*s]), c1)
	draw_colored_polygon(PackedVector2Array([p+Vector2(-8,35)*s,p+Vector2(10,-70)*s,p+Vector2(28,35)*s]), c2)
	draw_colored_polygon(PackedVector2Array([p+Vector2(18,35)*s,p+Vector2(45,-30)*s,p+Vector2(58,35)*s]), c1)
