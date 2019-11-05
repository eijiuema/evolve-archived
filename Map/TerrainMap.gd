extends Node2D

onready var TileMap = $TileMap

enum Terrain {
	Grass,
	Forest,
	Ocean,
	Stone
}

func get_tiles_by_terrain(terrain):
	return TileMap.get_used_cells_by_id(terrain)

func get_terrain(coordinate):
	return TileMap.get_cellv(coordinate)

func get_terrain_by_id(id):
	return Terrain.keys()[id]
