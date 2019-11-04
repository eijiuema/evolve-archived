extends Node2D

onready var TileMap = $HexTileMap

var seen_matrix = {}

func _ready():
	for x in range(-25, 25):
		for y in range(-25, 25):
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

func unseen(coordinates):
	if coordinates is Array:
		for coordinate in coordinates:
			if seen_matrix.has(coordinate) and seen_matrix[coordinate] > 0:
				seen_matrix[coordinate] -= 1
	else:
		unseen([coordinates])

func fog_value(coordinate):
	return seen_matrix[coordinate] if seen_matrix.has(coordinate) else 0
		
				
func update():
	for tile in TileMap.get_used_cells():
		if fog_value(tile) == 0:
			TileMap.set_cellv(tile, 1)
		else:
			TileMap.set_cellv(tile, 0)