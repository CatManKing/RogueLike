extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 0.5
@export var spawn_distance_min: float = 1500.0
@export var spawn_distance_max: float = 1700.0
@export var max_enemies: int = 20

var timer := 0.0

func _process(delta):
	if not enemy_scene:
		return

	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		spawn_enemy()

func spawn_enemy():
	if get_tree().get_nodes_in_group("enemies").size() >= max_enemies:
		return

	var player = Global.player  # using singleton
	if not player:
		return

	# pick a random direction around the player
	var angle = randf_range(0, TAU)
	var distance = randf_range(spawn_distance_min, spawn_distance_max)
	var spawn_pos = player.global_position + Vector2.RIGHT.rotated(angle) * distance

	#spawn enemy
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_pos
	get_tree().current_scene.add_child(enemy)
	var ai_node = enemy.get_node("CharacterBody2D")
	ai_node.target = player

	# optional random offset so they don't all line up perfectly
	enemy.global_position += Vector2(randf_range(-32, 32), randf_range(-32, 32))
