extends Node2D

onready var Hovered = $Hovered
onready var Selected = $Selected

onready var FogMap = $FogMap
onready var TerrainMap = $TerrainMap
onready var ObjectMap = $ObjectMap

var selected = Vector2(0, 0)
var hovered = Vector2(0, 0)

func _ready():
	
	# Adds wood resource to each Forest tile
	for coordinate in TerrainMap.get_tiles_by_terrain(TerrainMap.Terrain.Forest):
		ObjectMap.add_object(coordinate, ObjectMap.Objects.Wood.instance())
		
	# Reveals the area around the forest
	FogMap.seen(FogMap.TileMap.get_circle(Vector2(0, 0), 2))
	FogMap.update()

func _unhandled_input(event: InputEvent) -> void:
	
	hovered = TerrainMap.TileMap.world_to_map(get_global_mouse_position())
	
	if FogMap.visible(hovered):
		Hovered.position = TerrainMap.TileMap.map_to_world(hovered)
		if event.is_action_released("ui_left_click"):
			selected = hovered
			Selected.position = Hovered.position
			Selected.visible = true
	
	Global.GUI.get_node("BottomRight/TileInfoContainer/TileInfo").tile_info = get_tile_info(hovered)
		
func get_tile_info(position):
	return {
		'coordinate': position,
		'terrain': TerrainMap.get_terrain_by_id(TerrainMap.get_terrain(position)),
		'building': ObjectMap.get_building(position),
		'objects': ObjectMap.get_objects(position)
	}