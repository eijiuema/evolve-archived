extends VBoxContainer

onready var Map = Global.Map

const Campfire = preload("res://objects/Campfire.tscn")
const Tent = preload("res://objects/Tent.tscn")

func _ready():
	pass


func _on_Build_pressed():
	
	var building = Campfire.instance()
	
	Map.set_building(Map.selected, building)
	
	Map.FogMap.seen(Map.TerrainMap.TileMap.get_circle(Map.selected, building.fog))
	Map.FogMap.update()
	
func _on_Upgrade_pressed():
	
	var building = Map.get_building(Map.selected)
	
	if building and building.type == "Campfire":
		Map.FogMap.unseen(Map.TerrainMap.TileMap.get_circle(Map.selected, building.fog))
		building = Tent.instance()
		Map.set_building(Map.selected, building)
		Map.FogMap.seen(Map.TerrainMap.TileMap.get_circle(Map.selected, building.fog))
		Map.FogMap.update()

func _on_Demolish_pressed():
	
	var building = Map.get_building(Map.selected)
	
	if (building):	
		Map.set_building(Map.selected)
		
		if (building.type == 'Campfire' or building.type == 'Tent'):
			Map.FogMap.unseen(Map.TerrainMap.TileMap.get_circle(Map.selected, building.fog))
			Map.FogMap.update()
