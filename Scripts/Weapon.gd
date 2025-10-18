extends Node2D

@export var projectile_scene: PackedScene

func fire(global_origin: Vector2, target_pos: Vector2, stats: PlayerStats):
	if projectile_scene == null:
		push_warning("Weapon has no projectile scene assigned!")
		return

	var dir = (target_pos - global_origin).normalized()

	# If only one projectile, just fire straight
	if stats.projectile_count <= 1:
		_spawn_projectile(global_origin, dir, stats)
		return

	# Calculate spread in radians
	var total_spread = deg_to_rad(stats.spread_angle) * (stats.projectile_count - 1)
	var start_angle = -total_spread / 2.0

	for i in range(stats.projectile_count):
		var angle = start_angle + i * deg_to_rad(stats.spread_angle)
		var spread_dir = dir.rotated(angle)
		_spawn_projectile(global_origin, spread_dir, stats)

func _spawn_projectile(origin: Vector2, dir: Vector2, stats: PlayerStats):
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = origin + dir * stats.muzzle_offset

	if projectile.has_method("initialize"):
		projectile.initialize(dir, stats)
	else:
		push_warning("Projectile missing 'initialize' method!")
