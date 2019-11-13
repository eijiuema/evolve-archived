extends Node2D

var objects = {}
var buildings = {}

onready var Map = Global.Map

func set_building(position, building = null):
	
	if (buildings.has(position)):
		buildings[position].queue_free()
		buildings.erase(position)
	
	if (building != null):
		buildings[position] = building
		building.position = Map.TerrainMap.TileMap.map_to_world(position)
		add_child(building)
		
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
	object.position = Map.TerrainMap.TileMap.map_to_world(position)
	add_child(object)
		
func remove_object(position, object):
	if (objects.has(position)):
		object[position].queue_free()
		objects[position].erase(object)
		
func get_objects(position):
	return objects[position] if objects.has(position) else []