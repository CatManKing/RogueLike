extends Node2D

@export var float_speed: float = 50.0
@export var lifetime: float = 1.0
@export var base_font_size: int = 4
@export var scale_multiplier: float = 0.06   # how strongly size scales with damage

var velocity := Vector2(0, -1)
var timer := 0.0

var start_position: Vector2
var random_offset: Vector2
var random_rotation: float

func _ready():
	modulate.a = 1.0
	random_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
	random_rotation = randf_range(-20, 20) # degrees
	start_position = global_position + random_offset


func set_value(value: float, color: Color = Color(1, 1, 1)):
	$Label.text = str(int(value))  # round damage for display
	$Label.modulate = color

	# Scale label size based on damage
	var scale_factor = 1 + clamp(value * scale_multiplier, 0.0, 3.0)
	scale = Vector2.ONE * scale_factor

	# Optional: change color slightly for stronger hits
	if value > 10:
		$Label.modulate = Color(1, 0.6, 0.3)
	if value > 25:
		$Label.modulate = Color(1, 0.3, 0.3)

func _process(delta):
	position += velocity * float_speed * delta
	timer += delta
	modulate.a = lerp(1.0, 0.0, timer / lifetime)

	if timer >= lifetime:
		queue_free()
