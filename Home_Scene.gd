extends Control

var selected_drawing_type = preload("res://assets/sounds/selected_drawing_type.wav")
var selected_photo = preload("res://assets/sounds/select_photo.wav")

var stars = preload("res://paricles.tscn")
onready var sp = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func sound_play(sound):
	sp.stream = sound
	sp.play()
	
func _on_ColorFill_pressed():
	sound_play(selected_drawing_type)

func _on_FunPaint_pressed():
	sound_play(selected_drawing_type)

func _on_Drawing_pressed():
	sound_play(selected_drawing_type)

func _on_GlowPen_pressed():
	sound_play(selected_drawing_type)

func _on_Pig_pressed():
	sound_play(selected_photo)

func _on_Cat_pressed():
	sound_play(selected_photo)

func _on_TextureButton3_pressed():
	sound_play(selected_photo)

func _on_2_pressed():
	sound_play(selected_photo)


func _on_Home_Scene_gui_input(event):
	if event is InputEventScreenTouch:
			if event.is_pressed():
				var stars_instance = stars.instance()
				stars_instance.position = event.position
				stars_instance.emitting = true
				add_child(stars_instance)
