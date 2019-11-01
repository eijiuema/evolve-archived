extends Node2D

onready var Highlight = Global.UI.get_node("TileHighlight")
onready var TerrainMap = $TerrainTileMap
onready var FogMap = $FogTileMap
onready var ObjectMap = $ObjectMap

const VillageObject = preload("res://objects/Village.tscn")

var objectMap = {}

func _ready():
	
	# Fills the FogMap in a 50x50 square
	for x in range(-25, 25):
		for y in range(-25, 25):
			FogMap.set_cell(x, y, 0)
	
	# Adds the initial village at (0, 0) coordinates
	add_object(Vector2(0, 0), VillageObject.instance())
	
	# Reveals the area around the village
	for coordinate in objectMap.keys():
		for object in objectMap[coordinate]:
			if object.TYPE == 'Village':
				for tile in FogMap.get_circle(coordinate, 3):
					FogMap.set_cellv(tile, -1)

func _process(delta):
	var hovered_cell = TerrainMap.world_to_map(get_global_mouse_position())
	if FogMap.get_cellv(hovered_cell) == -1:
		Highlight.position = TerrainMap.map_to_world(hovered_cell)
		Highlight.visible = true
	else:
		Highlight.visible = false
		
	var tile_info = get_tile(hovered_cell)
	Global.UI.get_node("CanvasLayer/TileHoverInfo").text = "Position: " + str(hovered_cell) + "\nTerrain: " + str(tile_info['terrain']) + "\nObjects: " + str(tile_info['objects'])

func add_object(position, object):
	if (objectMap.has(position)):
		objectMap[position].append(object)
	else:
		objectMap[position] = [object]
	object.position = TerrainMap.map_to_world(position)
	ObjectMap.add_child(object)
		
func remove_object(position, object):
	if (objectMap.has(position)):
		objectMap[position].erase(object)
		ObjectMap.remove_child(object)
		
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