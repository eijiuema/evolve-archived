tool
extends TextureButton

export (PackedScene) var building setget set_building

signal selected

func set_building(new_building):
	if Engine.editor_hint and new_building != null:
		texture_normal = new_building.instance().get_node("Sprite").texture
	building = new_building

func _on_BuildOptions_pressed():
	emit_signal("selected", building)

func _on_BuildOptions_mouse_entered():
	self_modulate.a = 0.6
	$Tooltip.visible = true

func _on_BuildOptions_mouse_exited():
	self_modulate.a = 1.0
	$Tooltip.visible = false
