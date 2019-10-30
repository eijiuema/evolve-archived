extends Node2D

onready var Highlight = Global.UI.get_node("TileHighlight")
onready var TerrainMap = $TerrainTileMap
onready var FogMap = $FogTileMap

var objectMap = {}

func _ready():
	add_object(Vector2(0, 0), "Wood")
	pass

func _process(delta):
	var hovered_cell = TerrainMap.world_to_map(get_global_mouse_position())
	Highlight.position = TerrainMap.map_to_world(hovered_cell)
	var TileHoverInfo = Global.UI.get_node("CanvasLayer/TileHoverInfo")
	var tile_info = get_tile(hovered_cell)
	TileHoverInfo.text = "Position: " + str(hovered_cell) + "\nTerrain: " + str(tile_info['terrain']) + "\nObjects: " + str(tile_info['objects'])
	
func add_object(position, object):
	if (objectMap.has(position)):
		objectMap[position].append(object)
	else:
		objectMap[position] = [object]
		
func remove_object(position, object):
	if (objectMap.has(position)):
		objectMap[position].erase(object)
		
func get_objects(position):
	if (objectMap.has(position)):
		return objectMap[position]
	else:
		return []
		
func get_tile(position):
	return {
		'terrain': TerrainMap.get_cellv(position),
		'objects': get_objects(position)
	}