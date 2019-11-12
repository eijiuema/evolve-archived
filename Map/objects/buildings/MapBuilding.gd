extends Node2D

export var type = ""
export var fog = 0

func can_build(position):
	print("This is an abstract function and should never be called")
	return false
	
func build():
	print("This is an abstract function and should never be called")
	return false