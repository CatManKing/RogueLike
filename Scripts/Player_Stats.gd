extends Resource
class_name PlayerStats

signal leveled_up(level: int)

@export var move_speed: float = 500.0
@export var fire_rate: float = 0.15
@export var damage: float = 5.0
@export var projectile_speed: float = 1200.0
@export var projectile_lifespan: float = 2.0
@export var projectile_count: int = 1         # how many bullets per shot
@export var spread_angle: float = 10        # degrees between projectiles
@export var muzzle_offset: float = 80.0   

# Leveling system
var xp: float = 0.0
var level: int = 1
var xp_to_next: float = 50.0
var upgrade_points: int = 0

func add_xp(amount: float):
	xp += amount
	while xp >= xp_to_next:
		xp -= xp_to_next
		level_up()

func level_up():
	level += 1
	upgrade_points += 1
	xp_to_next = int(xp_to_next * 1.25)  # scale requirement
	leveled_up.emit(1)
	print("Level Up! Now level", level, "Upgrade points:", upgrade_points)
