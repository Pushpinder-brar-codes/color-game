extends Popup


var start = false

func _ready():
	pass


func _process(delta):
	if start and rect_position.y < 144:
		rect_position.y += 4000 * delta
	elif !start and rect_position.y > -900:
		rect_position.y -= 4000 * delta


func _on_ColorFill_pressed():
	show_now()
	Global.brush = false

func show_now():
	show()
	start = true

func _on_TextureButton_pressed():
	start = false


func _on_FunPaint_pressed():
	show_now()
	Global.brush = false
