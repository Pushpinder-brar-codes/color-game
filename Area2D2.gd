extends Area2D


var stars = preload("res://paricles.tscn")


func _on_Area2D2_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
			if event.is_pressed():
				var stars_instance = stars.instance()
				stars_instance.position = event.position
				stars_instance.emitting = true
				add_child(stars_instance)

