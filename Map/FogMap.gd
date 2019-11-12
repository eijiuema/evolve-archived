extends Node2D

onready var TileMap = $HexTileMap

var seen_matrix = {}

export (int) var size

func _ready():
	for x in range(-size, size):
		for y in range(-size, size):
			TileMap.set_cell(x, y, 1)

func seen(coordinates):
	if coordinates is Array:
		for coordinate in coordinates:
			if seen_matrix.has(coordinate):
				seen_matrix[coordinate] += 1
			else:
				seen_matrix[coordinate] = 1
	else:
		seen([coordinates])
		
func seen_circle(center, radius = 1):
	seen(TileMap.get_circle(center, radius))

func unseen(coordinates):
	if coordinates is Array:
		for coordinate in coordinates:
			if seen_matrix.has(coordinate) and seen_matrix[coordinate] > 0:
				seen_matrix[coordinate] -= 1
	else:
		unseen([coordinates])

func fog_value(coordinate):
	return seen_matrix[coordinate] if seen_matrix.has(coordinate) else 0
	
func visible(coordinate):
	return fog_value(coordinate) > 0
	
func update():
	for tile in TileMap.get_used_cells():
		if fog_value(tile) == 0:
			TileMap.set_cellv(tile, 1)
		else:
			TileMap.set_cellv(tile, 0)