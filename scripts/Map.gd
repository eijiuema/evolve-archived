extends Node2D

onready var Hovered = $Hovered
onready var Selected = $Selected

onready var FogMap = $FogMap
onready var TerrainMap = $TerrainMap
onready var ObjectMap = $ObjectMap

var objects = {}
var buildings = {}
var selected
var hovered

func _ready():
	# Adds wood resource to each Forest tile
	for coordinate in TerrainMap.get_terrain(TerrainMap.Terrain.Forest):
		add_object(coordinate, ObjectMap.Objects.Wood.instance())
		
	# Reveals the area around the forest
	FogMap.seen(FogMap.TileMap.get_circle(Vector2(0, 0), 2))
	FogMap.update()

func _unhandled_input(event: InputEvent) -> void:
	hovered = TerrainMap.TileMap.world_to_map(get_global_mouse_position())
	
	Hovered.position = TerrainMap.TileMap.map_to_world(hovered)
	
	if event.is_action_released("ui_left_click"):
		selected = hovered
		Selected.position = Hovered.position
		Selected.visible = true
	
	Global.GUI.get_node("BottomRight/TileInfoContainer/TileInfo").tile_info = get_tile_info(hovered)

func set_building(position = selected, building = null):
	if (buildings.has(position)):
		buildings[position].queue_free()
		buildings.erase(position)
	
	if (building != null):
		buildings[position] = building
		building.position = TerrainMap.TileMap.map_to_world(position)
		ObjectMap.add_child(building)
		
func get_building(position):
	return buildings[position] if buildings.has(position) else null
	
func get_coordinates_with_building(building):
	var coordinates = []
	for coordinate in buildings.keys():
		if buildings[coordinate].type == building:
			coordinates.append(coordinate)
	return coordinates
	
func add_object(position, object):
	if (objects.has(position)):
		objects[position].append(object)
	else:
		objects[position] = [object]
	object.position = TerrainMap.TileMap.map_to_world(position)
	ObjectMap.add_child(object)
		
func remove_object(position, object):
	if (objects.has(position)):
		object[position].queue_free()
		objects[position].erase(object)
		
func get_objects(position):
	return objects[position] if objects.has(position) else []
		
func get_tile_info(position):
	return {
		'coordinate': position,
		'terrain': TerrainMap.TileMap.get_cellv(position),
		'building': get_building(position),
		'objects': get_objects(position)
	}