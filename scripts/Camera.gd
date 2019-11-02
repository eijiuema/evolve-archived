extends Camera2D

export var SHOULD_DRAG : bool = true
export var SHOULD_ZOOM : bool = true

const ZOOM_MIN : float = 1.0
const ZOOM_MAX : float = 128.0
const ZOOM_STEP : float = 2.0

const MAX_SPEED : float = 2000.0
const BASE_SPEED : float = 300.0
const ACCELERATION : float = 15.0

var current_acceleration : float = BASE_SPEED

onready var viewport_rect = get_viewport().get_visible_rect()

func handle_drag(delta):
	if !SHOULD_DRAG:
		return
	
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()

	var direction : Vector2 = Vector2(0, 0)
	
	if mouse_pos.x <= viewport_rect.position.x or Input.is_action_pressed("ui_left"):
		direction.x = -1
	if mouse_pos.x >= viewport_rect.end.x - 2 or Input.is_action_pressed("ui_right"):
		direction.x = 1
	if mouse_pos.y <= viewport_rect.position.y or Input.is_action_pressed("ui_up"):
		direction.y = -1
	if mouse_pos.y >= viewport_rect.end.y - 2 or Input.is_action_pressed("ui_down"):
		direction.y = 1

	if direction == Vector2(0, 0):
		current_acceleration = max(BASE_SPEED, current_acceleration - BASE_SPEED)
	else:
		current_acceleration = min(current_acceleration + pow(ACCELERATION, 2), MAX_SPEED)

	offset += direction.normalized() * delta * current_acceleration

func handle_zoom(event):
	if !SHOULD_ZOOM:
		return
	
	if event.is_action_pressed("ui_zoom_out"):
		zoom *= ZOOM_STEP
	elif event.is_action_pressed("ui_zoom_in"):
		zoom /= ZOOM_STEP
		
	if zoom.x > ZOOM_MAX:
		zoom = Vector2(1, 1) * ZOOM_MAX

	if zoom.x < ZOOM_MIN:
		zoom = Vector2(1, 1) * ZOOM_MIN
		
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		
func _process(delta):
#	handle_drag(delta)
	pass
		
func _input(event):
	handle_zoom(event)
	
var mouse_captured = false

func _unhandled_input(event):

	if event.is_action_pressed("ui_left_click"):
		mouse_captured = true
	elif event.is_action_released("ui_left_click"):
		mouse_captured = false

	if mouse_captured && event is InputEventMouseMotion:
		position -= event.relative * zoom