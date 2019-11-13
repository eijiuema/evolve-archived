extends Panel

onready var Map = Global.Map
onready var ItemList = $VBoxContainer/ItemList

const Buildings = \
	[ \
		preload("res://objects/buildings/Campfire.tscn") \
	]
	
func _ready():
	hide()
	for building in Buildings:
		var instance = building.instance()
		ItemList.add_item(instance.type, instance.texture)
		instance.queue_free()

func _on_Build_pressed():
	if visible:
		hide()
	else:
		show()
	ItemList.unselect_all()
	
func _on_TextureButton_pressed():
	hide()
	Map.building = null

func _on_ItemList_item_selected(index):
	Map.building = Buildings[index].instance()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		hide()
