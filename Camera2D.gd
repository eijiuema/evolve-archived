extends Camera2D

const ZOOM_MIN : float = 1.0
const ZOOM_MAX : float = 3.0
const ZOOM_STEP : float = 1.0

var mouse_captured = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)		

func _unhandled_input(event):
	handle_drag(event)
	handle_zoom(event)
	
func handle_drag(event):
	if event.is_action_pressed("ui_left_click"):
		mouse_captured = true
	elif event.is_action_released("ui_left_click"):
		mouse_captured = false

	if mouse_captured && event is InputEventMouseMotion:
		get_parent().move_and_collide(-event.relative * zoom)

func handle_zoom(event):
	if event.is_action_pressed("ui_zoom_out"):
		zoom += Vector2(1, 1) * ZOOM_STEP
	elif event.is_action_pressed("ui_zoom_in"):
		zoom -= Vector2(1, 1) * ZOOM_STEP
		
	if zoom.x >= ZOOM_MAX:
		zoom = Vector2(1, 1) * ZOOM_MAX

	if zoom.x <= ZOOM_MIN:
		zoom = Vector2(1, 1) * ZOOM_MIN