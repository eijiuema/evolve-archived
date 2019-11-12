extends Node2D

onready var GUI = $"/root/Game/GUI"
onready var Map = $"/root/Game/Map"
onready var Resources = {
	Wood = {}
} setget set_resources

signal resources_update

var _timer = null

func _ready():
	_timer = Timer.new()
	add_child(_timer)
	
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false)
	_timer.start()
	
	Resources.Wood.stored = 15
	Resources.Wood.income = 0
	
func _on_Timer_timeout():
	for resource in Resources:
		self.Resources[resource].stored += Resources[resource].income

func set_resources(resources):
	Resources = resources
	emit_signal("resources_update", resources)