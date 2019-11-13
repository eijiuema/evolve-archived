tool
extends Node2D

export var type = ""
export var fog = 0
export (Texture) var texture setget set_texture

onready var Sprite = $Sprite

func set_texture(new_texture):
	texture = new_texture
	if Engine.editor_hint:
		Sprite.texture = texture

func can_build(position):
	push_error("This is an abstract function and should never be called")
	return false
	
func build():
	push_error("This is an abstract function and should never be called")
	return false
	
func destroy():
	push_error("This is an abstract function and should never be called")
	return false