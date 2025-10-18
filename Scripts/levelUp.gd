extends Control

@export var stats: PlayerStats
@export var follow_player: bool = true
@export var offset := Vector2(0, -100)  # pixels above player

func _process(_delta):
	if follow_player and Global.player:
		global_position = Global.player.global_position + offset

func _ready():
	Global.LevelUI = self

func _on_button_pressed():
	#move speed
	stats.move_speed += 500
	upgraded()

func _on_button_2_pressed():
	stats.projectile_count += 1
	upgraded()

func _on_button_3_pressed():
	stats.fire_rate -= 0.05
	upgraded()

func upgraded():
	stats.upgrade_points -=1
	if stats.upgrade_points < 1:
		visible = false
	get_tree().paused = false
