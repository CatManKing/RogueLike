extends CharacterBody2D

@export var move_speed: float = 350.0
@export var max_health: float = 10.0
@export var xp_drop: float = 10.0
@export var floating_text_scene: PackedScene
var health: float
var target: Node2D

func _ready():
	target = Global.player
	health = max_health
	add_to_group("enemies")

func _physics_process(delta):
	if target == null:
		return
	#chase
	var dir = (target.global_position - global_position).normalized()
	velocity = dir * move_speed
	move_and_slide()
	look_at(target.global_position)

func take_damage(amount: float):
	health -= amount
	
	#disblay damage number
	var text = floating_text_scene.instantiate()
	text.global_position = global_position
	text.set_value(amount, Color(1, 0.3, 0.3))  # red for damage
	get_tree().current_scene.add_child(text)
	
	if health <= 0:
		die()

func die():
	queue_free()
	Global.player.stats.add_xp(xp_drop)
