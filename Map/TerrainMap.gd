extends Node2D

onready var TileMap = $TileMap

enum Terrain {
	Grass,
	Forest,
	Ocean
}

func get_terrain(terrain):
	return TileMap.get_used_cells_by_id(terrain)
