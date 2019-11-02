extends HBoxContainer

func _ready():
	set_actions(['Build'])

func set_actions(actions):
	for child in get_children():
		child.visible = false
	for action in actions:
		get_node(action).visible = true

func _on_Build_pressed():
	Global.Map.set_building()
	pass


func _on_Destroy_pressed():
	Global.Map.set_building()
	pass
