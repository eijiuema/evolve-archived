extends Node2D

class_name MapResource

enum TYPES {
	Wood,
	Stone,
	Food
}

export (TYPES) var TYPE
export var QUANTITY : int

var available : int

func get_resource(quantity: int):
	if available < quantity:
		return available
	else:
		return quantity