extends Node2D

const CampfireObject = preload("res://objects/Campfire.tscn")
const WoodObject = preload("res://objects/Wood.tscn")

enum Terrain {
	Grass,
	Forest,
	Ocean
}

onready var Hovered = $Hovered
onready var Selected = $Selected

onready var TerrainMap = $TerrainTileMap
onready var FogMap = $FogTileMap
onready var ObjectMap = $ObjectMap

var objects = {}
var buildings = {}
var selected
var hovered

func _ready():
	# Fills the FogMap in a 50x50 square
	for x in range(-25, 25):
		for y in range(-25, 25):
			FogMap.set_cell(x, y, 0)
	
	# Adds the initial village at (0, 0) coordinates
	set_building(Vector2(0, 0), CampfireObject.instance())
	
	# Reveals the area around the village
	for coordinate in get_coordinates_with_building("Campfire"):
		for tile in FogMap.get_circle(coordinate, 5):
			FogMap.set_cellv(tile, -1)
	
	# Adds wood resource to each Forest tile
	for coordinate in TerrainMap.get_used_cells_by_id(Terrain.Forest):
		add_object(coordinate, WoodObject.instance())

func _unhandled_input(event: InputEvent) -> void:
	hovered = TerrainMap.world_to_map(get_global_mouse_position())
	
	if FogMap.get_cellv(hovered) == -1:
		Hovered.position = TerrainMap.map_to_world(hovered)
		Hovered.visible = true
	else:
		Hovered.visible = false
	
	if event.is_action_released("ui_left_click"):
		selected = hovered
		Selected.position = Hovered.position
		Selected.visible = true
		if get_building(hovered):
			Global.GUI.get_node("BottomLeft/ActionsContainer").set_actions(["Destroy"])
		else:
			Global.GUI.get_node("BottomLeft/ActionsContainer").set_actions(["Build"])
	
	Global.GUI.get_node("BottomRight/TileInfoContainer/TileInfo").tile_info = get_tile_info(hovered)

func set_building(position = selected, building = null):
	if (buildings.has(position)):
		buildings[position].queue_free()
		buildings.erase(position)
	
	if (building != null):
		buildings[position] = building
		building.position = TerrainMap.map_to_world(position)
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
	object.position = TerrainMap.map_to_world(position)
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
		'terrain': TerrainMap.get_cellv(position),
		'building': get_building(position),
		'objects': get_objects(position)
	}