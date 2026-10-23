extends Control
## Joystick virtual "flutuante": aparece onde você encosta o dedo.
## Funciona também com o mouse no PC (no Android o toque vira clique).

signal moved(dir: Vector2)

const RADIUS := 90.0

var active := false
var center := Vector2.ZERO
var knob := Vector2.ZERO


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			active = true
			center = event.position
			knob = center
		else:
			active = false
			moved.emit(Vector2.ZERO)
		queue_redraw()
	elif event is InputEventMouseMotion and active:
		var offset: Vector2 = event.position - center
		if offset.length() > RADIUS:
			offset = offset.normalized() * RADIUS
		knob = center + offset
		moved.emit(offset / RADIUS)
		queue_redraw()


func _draw() -> void:
	if not active:
		return
	draw_circle(center, RADIUS, Color(1, 1, 1, 0.10))
	draw_arc(center, RADIUS, 0.0, TAU, 48, Color(1, 1, 1, 0.35), 3.0)
	draw_circle(knob, 38.0, Color(1, 1, 1, 0.40))
