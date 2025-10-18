extends Node2D

@export var map_width: int = 100
@export var map_height: int = 80
@export var fill_percent: float = 0.45   # chance of wall when randomly filling
@export var smooth_iterations: int = 5
@export var tilemap_node: NodePath
@export var wall_tile_id: int = 0
@export var floor_tile_id: int = 1

var map: Array = []

func _ready():
	randomize()
	generate_map()

func generate_map():
	# initialize 2D array
	map.resize(map_height)
	for y in range(map_height):
		map[y] = []
		for x in range(map_width):
			# edges always walls
			if x == 0 or y == 0 or x == map_width - 1 or y == map_height - 1:
				map[y].append(1)
			else:
				# use Python-style inline if (no ?: in GDScript)
				var is_wall = (1 if (randi() % 100) < int(fill_percent * 100) else 0)
				map[y].append(is_wall)

	# smooth several times
	for i in range(smooth_iterations):
		smooth_map()

	# draw onto TileMap
	draw_to_tilemap()

func smooth_map():
	# create a copy to avoid mutating while reading
	var new_map = []
	new_map.resize(map_height)
	for y in range(map_height):
		new_map[y] = []
		for x in range(map_width):
			var wall_count = get_surrounding_wall_count(x, y)
			if wall_count > 4:
				new_map[y].append(1)
			elif wall_count < 4:
				new_map[y].append(0)
			else:
				new_map[y].append(map[y][x])
	map = new_map

func get_surrounding_wall_count(grid_x, grid_y):
	var count = 0
	for neighbor_y in range(grid_y - 1, grid_y + 2):
		for neighbor_x in range(grid_x - 1, grid_x + 2):
			if neighbor_x >= 0 and neighbor_x < map_width and neighbor_y >= 0 and neighbor_y < map_height:
				if neighbor_x != grid_x or neighbor_y != grid_y:
					count += map[neighbor_y][neighbor_x]
			else:
				count += 1  # treat out of bounds as wall
	return count

func draw_to_tilemap():
	var tilemap = $TileMap  # directly get child node
	tilemap.clear()

	for y in range(map_height):
		for x in range(map_width):
			var tile_id = wall_tile_id if map[y][x] == 1 else floor_tile_id
			tilemap.set_cell(0, Vector2i(x, y), tile_id)


