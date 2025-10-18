extends CharacterBody2D

@export var stats: PlayerStats
@export var weapon: NodePath  # reference to the Weapon node
var weapon_ref: Node

var input_vector := Vector2.ZERO
var time_since_last_shot := 0.0

func _ready():
	PlayerStats.new()
	if weapon != NodePath():
		weapon_ref = get_node(weapon)
	#set global player reference
	Global.player = self
	#connect levelup event
	stats.leveled_up.connect(on_player_leveled)
	var ok = Global.player.stats.leveled_up.connect(on_player_leveled)

func on_player_leveled(level):
	Global.LevelUI.visible = true
	get_tree().paused = true

func _process(delta):
	get_input()
	handle_shooting(delta)
	look_at(get_global_mouse_position())
	print(global_position)

func _physics_process(delta):
	if stats == null:
		return
	velocity = input_vector.normalized() * stats.move_speed
	move_and_slide()

func get_input():
	input_vector = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)

func handle_shooting(delta):
	if stats == null or weapon_ref == null:
		return
	time_since_last_shot += delta

	if Input.is_action_pressed("Shoot") and time_since_last_shot >= stats.fire_rate:
		var mouse_pos = get_global_mouse_position()
		weapon_ref.fire(global_position, mouse_pos, stats)
		time_since_last_shot = 0.0
