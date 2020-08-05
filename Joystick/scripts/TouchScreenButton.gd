extends TouchScreenButton
# Radius is 90

var radius = Vector2(90, 90)
var boundary = 180

var ongoing_drag = -1

var return_accel = 20

var threshold = 10

func _process(delta):
	if ongoing_drag == -1:
		var pos_difference = (Vector2(0, 0) - radius) - position
		position += pos_difference * return_accel * delta

func get_button_position():
	return position + radius

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_center = (event.position - get_parent().global_position).length()
		
		if event_dist_from_center <= (boundary * global_scale.x) or event.get_index() == ongoing_drag:
			position = event.position - (radius * transform.get_scale())
			if get_button_position().length() > boundary:
				position = get_button_position().normalized() * boundary - radius
			ongoing_drag = event.get_index()
			
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1

func get_value():
	if get_button_position().length() > threshold:
		return get_button_position().normalized()
	return Vector2(0,0)
