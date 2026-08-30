# This script is an autoload, that can be accessed from any other script!

extends Node2D

var score : int = 0
var hp    : int = 100
var life  : int = 4
var max_life : int = 5
var max_hp  :int = 100

var sfx_on = true
var music_on = true

var player :Player = null
var current_level : String = "res://Scenes/Levels/level_01.tscn"
var save_path := "user://game.save"
var save_player_position = Vector2.ZERO
var has_key : bool = false
var crystal_collected : int = 0
var crystal_required : int = 3
var player_stats = Stat.new()

func _ready() -> void:
	restart()
	
func get_stat(key:String,default=0):
	return player_stats.data_get(key,default)
	
# Adds 1 to score variable
func add_score(v=1):
	player_stats.data_add("score",v)

# Loads next level
func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)

func enemy_died(entity):
	player_stats.data_add("killed_enemy")
	player_stats.data_add("killed_"+entity.label)	

func restart():
	player_stats.data_set("hp", 3)       # ชีวิต 3 หน่วย
	player_stats.data_set("hp_max", 3)
	player_stats.data_set("life", 1)      # จำนวนครั้งที่ restart ด่านได้
	player_stats.data_set("life_max", 1)
	player_stats.data_set("score", 0)
	player_stats.data_set("coins", 0)
	player_stats.data_set("killed_enemy", 0)
	save_player_position = Vector2.ZERO
	has_key = false
	crystal_collected = 0
	crystal_required = 3

func damage(val=1):
	var hp = player_stats.data_add("hp", -val)  # หัก 1 ชีวิต
	if hp <= 0:
		death()

func add_hp(val=1):
	player_stats.data_add("hp",val)

func update_option():
	var music_bus = AudioServer.get_bus_index("music")
	var sfx_bus = AudioServer.get_bus_index("sfx")
	AudioServer.set_bus_mute(sfx_bus,!sfx_on)
	AudioServer.set_bus_mute(music_bus,!music_on)
	
func add_life():
	player_stats.data_add("life",1)

func death():
	if player != null:
		await player.death_tween()
	# ✅ เก็บด่านปัจจุบันก่อนไป game_over
	current_level = get_tree().current_scene.scene_file_path
	if player_stats.data_add("life",-1) <= 0:
		get_tree().change_scene_to_file("res://Scenes/Levels/game_over.tscn")

func save_option():
	var file = FileAccess.open("user://option.json", FileAccess.WRITE)
	if file:
		var payload: Dictionary = {
			"music" : music_on,
			"sound" : sfx_on,
		}
		var json_text = JSON.stringify(payload, "  ")
		file.store_pascal_string(json_text)
		file.close()

func load_option():
	if FileAccess.file_exists("user://option.json"):
		var file = FileAccess.open("user://option.json", FileAccess.READ)
		var text = file.get_pascal_string()
		var data = JSON.parse_string(text)        		
		file.close()
		music_on = data.get("music",true)
		sfx_on = data.get("sound",true)
		update_option()
				
func save_game():
	current_level = get_tree().current_scene.scene_file_path
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var pos = player.global_position
		var payload: Dictionary = {
			"current_level" : current_level,
			"player" : [pos.x, pos.y],
			"player_stats" : player_stats.data
		}
		var json_text = JSON.stringify(payload, "  ")
		file.store_pascal_string(json_text)
		file.close()

func has_gamesaved():
	return FileAccess.file_exists(save_path)

func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var text = file.get_pascal_string()
		var data = JSON.parse_string(text)        		
		file.close()
		current_level = data.get("current_level", current_level)
		player_stats.data = data.get("player_stats", {})
		var pos = data.get("player",[0,0])
		save_player_position = Vector2(pos[0],pos[1])
		get_tree().change_scene_to_file(current_level)
	else:
		restart()	
		get_tree().change_scene_to_file("res://Scenes/Levels/level_01.tscn")
func collect_crystal():
	crystal_collected += 1

func reset_crystals(required: int):
	crystal_collected = 0
	crystal_required = required

func collect_key():
	has_key = true
