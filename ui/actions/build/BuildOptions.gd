extends HBoxContainer

onready var Map = Global.Map
onready var BuildAction = get_parent().get_node("BuildAction")

const Campfire = preload("res://objects/Campfire.tscn")
const Tent = preload("res://objects/Tent.tscn")

func _on_Campfire_pressed():
	if (Map.ObjectMap.get_building(Map.selected)):
		return
		
	var building = Campfire.instance()
	
	Map.ObjectMap.set_building(Map.selected, building)
	
	Map.FogMap.seen(Map.TerrainMap.TileMap.get_circle(Map.selected, building.fog))
	Map.FogMap.update()
	
	close()

func _on_Tent_pressed():
	if (Map.ObjectMap.get_building(Map.selected)):
		return
		
	var building = Tent.instance()
	
	Map.ObjectMap.set_building(Map.selected, building)
	
	Map.FogMap.seen(Map.TerrainMap.TileMap.get_circle(Map.selected, building.fog))
	Map.FogMap.update()
	
	close()

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		var evLocal = make_input_local(event)
		if !Rect2(Vector2(0,0), rect_size).has_point(evLocal.position):
			close()

func _on_BuildAction_pressed():
	open()

func open():
	visible = true
	BuildAction.pressed = true
	
func close():
	visible = false
	BuildAction.release_focus()
	BuildAction.pressed = false