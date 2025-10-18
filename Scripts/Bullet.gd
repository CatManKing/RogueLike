extends Node2D

var direction: Vector2
var speed: float
var damage: float
var lifespan: float
var hit: bool = false

func initialize(dir: Vector2, stats: PlayerStats):
	direction = dir
	speed = stats.get("projectile_speed")
	damage = stats.get("damage")
	lifespan = stats.get("projectile_lifespan")
	rotation = dir.angle()
	
	# start a one-shot timer when spawned
	var timer := get_tree().create_timer(lifespan, false)
	timer.timeout.connect(queue_free)
	
	
func _physics_process(delta):
	position += direction * speed * delta

func _on_area_2d_body_entered(body):
	#collision
	if body.has_method("take_damage") && !hit:
		body.take_damage(damage)
		hit = true
	queue_free()

