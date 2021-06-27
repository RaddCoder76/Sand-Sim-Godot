extends Camera2D


export var zoomSpeed = Vector2(.2,.2)
var zoomMin = Vector2(.200001, .200001)
export var zoomMax = Vector2(2,2)
var desZoom = zoom

func _process(delta):
	zoom = lerp(zoom, desZoom, .2)
	if Input.is_action_just_pressed("middleMouse"):
		position = get_global_mouse_position()
	

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if desZoom > zoomMin:
					desZoom -= zoomSpeed
			if event.button_index == BUTTON_WHEEL_DOWN:
				if desZoom < zoomMax:
					desZoom += zoomSpeed
			
