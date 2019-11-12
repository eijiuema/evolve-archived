extends Node2D

onready var TileMap = $TileMap

export (int) var size

enum Terrain {
	Grass,
	Forest,
	Ocean,
	Stone
}

func _ready():
	for x in range(-size, size):
		for y in range(-size, size):
			if TileMap.get_cell(x, y) == TileMap.INVALID_CELL:
				TileMap.set_cell(x, y, Terrain.Ocean)

func get_tiles_by_terrain(terrain):
	return TileMap.get_used_cells_by_id(terrain)

func get_terrain(coordinate):
	return TileMap.get_cellv(coordinate)

func get_terrain_name(id):
	return Terrain.keys()[get_terrain(id)]
