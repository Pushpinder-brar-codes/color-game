extends Control

var start = false
var home_scene = preload("res://Home_Scene.tscn")
var paint_scene = preload("res://Paint.tscn")

var home_sound = preload("res://assets/sounds/menu_bg_sound.mp3")
var paint_sound = preload("res://assets/sounds/drawing_bg.mp3")


var from = home_scene
var to = paint_scene

onready var animation_player = $AnimationPlayer
onready var timer = $Timer
onready var sp = $SPM

func _ready():
	pass # Replace with function body.


func _on_ColorFill_pressed():
	print("pressed")

func play():
	animation_player.play("swipe_right")

func _on_Timer_timeout():
	if $Home_Scene == null:
		change_scene_paint_to_home()
	else:
		change_scene_home_to_paint()

func change_scene_paint_to_home():
	sp.stream = home_sound
	sp.play()
	remove_child($Paint)
	add_child(home_scene.instance())

func change_scene_home_to_paint():
	sp.stream = paint_sound
	sp.play()
	remove_child($Home_Scene)
	add_child(paint_scene.instance())

func _on_Drawing_pressed():
	play()
	Global.img_id = -1
	Global.brush = true
	Global.painting_type = "drawing"
	timer.start(0.5)
#	get_tree().change_scene("res://Paint.tscn")

func _on_GlowPen_pressed():
	play()
	Global.img_id = -2
	Global.brush = true
	Global.glowing = true
	Global.painting_type = "drawing"
	timer.start(0.5)

func usual(id):
	play()
	Global.img_id = id
	Global.painting_type = "color_fill"
	timer.start(0.5)
	
func _on_0_pressed():
	usual(0)

func _on_1_pressed():
	usual(1)

func _on_2_pressed():
	usual(2)


func _on_3_pressed():
	usual(3)


func _on_4_pressed():
	usual(4)


func _on_5_pressed():
	usual(5)


func _on_6_pressed():
	usual(6)


func _on_7_pressed():
	usual(7)


func _on_8_pressed():
	usual(8)


func _on_9_pressed():
	usual(9)


func _on_10_pressed():
	usual(10)


