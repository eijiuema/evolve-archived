extends Node2D

onready var Hovered = $Hovered
onready var Selected = $Selected

onready var FogMap = $FogMap
onready var TerrainMap = $TerrainMap
onready var ObjectMap = $ObjectMap

var hovered = Vector2(0, 0) setget set_hovered
var selected = Vector2(0, 0) setget set_selected
var building setget set_building

signal hover
signal select
signal deselect

func _ready():
	# Adds wood resource to each Forest tile
#	for coordinate in TerrainMap.get_tiles_by_terrain(TerrainMap.Terrain.Forest):
#		ObjectMap.add_object(coordinate, ObjectMap.Objects.Wood.instance())
		
	# Reveals the area around the forest
	FogMap.seen_circle(Vector2(0, 0), 2)
	FogMap.update()
	
func _unhandled_input(event: InputEvent) -> void:
	
	self.hovered = TerrainMap.TileMap.world_to_map(get_global_mouse_position())
#
#	if Input.is_action_just_released("ui_left_click") and FogMap.visible(hovered):
#		self.selected = hovered

	if event.is_action_pressed("ui_left_click") and building and FogMap.visible(hovered) and building.can_build(hovered):
		Hovered.remove_child(building)
		building.build()
		ObjectMap.set_building(hovered, building)
		FogMap.seen_circle(hovered, building.fog)
		FogMap.update()
		self.building = null
		
	if building != null:
		if building.can_build(hovered) and FogMap.visible(hovered):
			Hovered.modulate = Color(0, 1, 0)
		else:
			Hovered.modulate = Color(1, 0, 0)
		
	if Input.is_action_just_pressed("map_escape"):
		self.building = null
		
func get_tile_info(position):
	return {
		'coordinate': position,
		'terrain': TerrainMap.get_terrain_name(position),
		'building': ObjectMap.get_building(position),
		'objects': ObjectMap.get_objects(position)
	}
	
func set_selected(position = null):
	if position == null:
		selected = null
		Selected.visible = false
		emit_signal("deselect")
	else:
		selected = position
		Selected.position = TerrainMap.TileMap.map_to_world(position)
		Selected.visible = true
		emit_signal("select", selected)

func set_hovered(position):
	hovered = position
	Hovered.position = TerrainMap.TileMap.map_to_world(position)
	Hovered.visible = true
	emit_signal("hover", hovered)
	
func set_building(instance):
	building = instance
	for build in Hovered.get_children():
		build.queue_free()
	if instance == null:
		Hovered.modulate = Color(1, 1, 1)
	else:
		Hovered.add_child(instance)
		