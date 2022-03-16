extends Sprite

var img_id: int = Global.img_id
var path: String = "res://assets/paint/images/"+ String(img_id) + ".png"
#var pattern_path: String = "res://assets/paint/pattern/balloons.jpg"
var img_resource : StreamTexture = load(path)
var img: Image = Image.new()

#var pattern_Image_resource : StreamTexture = load(pattern_path)
var selected_texture
var pattern_image : Image


var imageTexture : ImageTexture = ImageTexture.new()
var selected_color : Color
var thread : Thread
var main_color = Color8(255,0,255)

var previous_animation_player = null
var mode: int = 0

var brush = Global.brush
var glowing = Global.glowing

var run = false

func _ready():
	if glowing:
		get_node("../WE").environment = load("res://Environment.tres")
#	print("once")
	var lines_overlay_node = get_node("../lines_overlay")
	if Global.painting_type == "drawing":
		lines_overlay_node.visible = false
		scale = Vector2(1,1)
	else:
		lines_overlay_node.texture = load("res://assets/paint/images/overlays/"+ String(img_id) + ".png")
#		print("line overlay")
#		pattern_image = pattern_Image_resource.get_data()
		img = img_resource.get_data()
		img.lock()
#		pattern_image.lock()
		thread = Thread.new()
		clean()
	
	texture = img_resource

func clean():
	var sizeX = img.get_size().x - 1
	var sizeY = img.get_size().y - 1
	
	for i in range(sizeX):
		for j in range(sizeY):
			if img.get_pixel(i,j).r < 0.9 and img.get_pixel(i,j).g < 0.9 and img.get_pixel(i,j).b < 0.9 or img.get_pixel(i,j).a < 0.9:
				img.set_pixel(i,j,Color(0,0,0,1))
			else:
				img.set_pixel(i,j,Color(1,1,1,1))
	
	imageTexture.create_from_image(img,16)
	texture = imageTexture


func color_pattern(position):
	var posX: int = int(position.x)
	var posY: int = int(position.y)

	var sizeX = img.get_size().x - 1
	var sizeY = img.get_size().y - 1

#	var clicked_color = img.get_pixel(posX,posY)
	var black_color: Color = Color.black
#	var main_color: Color = Color.blueviolet
	if(img.get_pixel(posX,posY)).is_equal_approx(black_color):
		return

	var stack = [posX,posY]
#	print(posX,posY," ",clicked_color)
	
	while stack.size() != 0 :
		var currentY = stack.pop_back()
		var currentX = stack.pop_back()
		
#		var main_color = Color8(pattern_image.get_pixel(currentX,currentY).r8,pattern_image.get_pixel(currentX,currentY).g8,pattern_image.get_pixel(currentX,currentY).b8,255)
		var main_color_p = pattern_image.get_pixel(currentX,currentY)
		
#		print(main_color)
#		prints(img.get_pixel(currentX,currentY))
		img.set_pixel(currentX,currentY,main_color_p)
#		prints(img.get_pixel(currentX,currentY))
#		print("hello")
		if currentX < sizeX and !img.get_pixel(currentX+1,currentY).is_equal_approx(black_color) and img.get_pixel(currentX+1,currentY) != pattern_image.get_pixel(currentX+1,currentY):
			stack.append(currentX+1)
			stack.append(currentY)
		if currentX > 0 and !img.get_pixel(currentX-1,currentY).is_equal_approx(black_color) and img.get_pixel(currentX-1,currentY) != pattern_image.get_pixel(currentX-1,currentY):
			stack.append(currentX-1)
			stack.append(currentY)
		if currentY < sizeY and !img.get_pixel(currentX,currentY+1).is_equal_approx(black_color) and img.get_pixel(currentX,currentY+1) != pattern_image.get_pixel(currentX,currentY+1):
			stack.append(currentX)
			stack.append(currentY+1)
		if currentY > 0 and !img.get_pixel(currentX,currentY-1).is_equal_approx(black_color) and img.get_pixel(currentX,currentY-1) != pattern_image.get_pixel(currentX,currentY-1):
			stack.append(currentX)
			stack.append(currentY-1)

	imageTexture.create_from_image(img,32)
	texture = imageTexture


func color(position):
	var posX = position.x
	var posY = position.y

	var sizeX = img.get_size().x - 1
	var sizeY = img.get_size().y - 1

	var stack: Array = [posX,posY]
	var black = Color.black
	var count = 0
	
	if(img.get_pixel(posX,posY)).is_equal_approx(black):
		return

	while stack.size() != 0 :
	
		var currentY = stack.pop_back()
		var currentX = stack.pop_back()
		
		img.set_pixel(currentX,currentY,main_color)
		
		if currentX < sizeX and !img.get_pixel(currentX+1,currentY).is_equal_approx(black) and (img.get_pixel(currentX+1,currentY).r != main_color.r or img.get_pixel(currentX+1,currentY).g != main_color.g or img.get_pixel(currentX+1,currentY).b != main_color.b):
			stack.append(currentX+1)
			stack.append(currentY)
		if currentX > 0 and !img.get_pixel(currentX-1,currentY).is_equal_approx(black) and (img.get_pixel(currentX-1,currentY).r != main_color.r or img.get_pixel(currentX-1,currentY).g != main_color.g or img.get_pixel(currentX-1,currentY).b != main_color.b ):
			stack.append(currentX-1)
			stack.append(currentY)
		if currentY < sizeY and !img.get_pixel(currentX,currentY+1).is_equal_approx(black) and (img.get_pixel(currentX,currentY+1).r != main_color.r or img.get_pixel(currentX,currentY+1).g != main_color.g or img.get_pixel(currentX,currentY+1).b != main_color.b):
			stack.append(currentX)
			stack.append(currentY+1)
		if currentY > 0 and !img.get_pixel(currentX,currentY-1).is_equal_approx(black) and (img.get_pixel(currentX,currentY-1).r != main_color.r or img.get_pixel(currentX,currentY-1).g != main_color.g or img.get_pixel(currentX,currentY-1).b != main_color.b):
			stack.append(currentX)
			stack.append(currentY-1)
		

	imageTexture.create_from_image(img,32)
	texture = imageTexture

var activeLine

func _on_Area2D_input_event(viewport, event, shape_idx):
	if brush:
		if event is InputEventScreenTouch:
				activeLine = Line2D.new()
				add_child(activeLine)
				if mode == 0:
					activeLine.default_color = main_color
#					if glowing:
#						activeLine.modulate = Color8(350,350,350,255)
#						print(activeLine.default_color)
				else:
					activeLine.texture = selected_texture
					activeLine.texture_mode = Line2D.LINE_TEXTURE_TILE
				activeLine.joint_mode = Line2D.LINE_JOINT_ROUND
				activeLine.end_cap_mode = Line2D.LINE_CAP_ROUND
				activeLine.begin_cap_mode = Line2D.LINE_CAP_ROUND
				activeLine.width = 4.0
		if event is InputEventScreenDrag:
			if activeLine:
				activeLine.add_point(get_local_mouse_position())

	else:
		if event is InputEventScreenTouch:
	#		print(img.get_size())
			if event.is_pressed():
#				print("gg")
				if thread.is_active():
					thread.wait_to_finish()
				if mode == 0:
					thread.start(self, "color", get_local_mouse_position())
				elif mode == 1:
					thread.start(self, "color_pattern", get_local_mouse_position())
				#print(thread.is_alive())


func _on_Purple_pressed():
	var animation_player = get_node("../SC/HC/VB/CCPurple/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_color(animation_player,Color8(127,0,255))

func _on_Green_pressed():
	var animation_player = get_node("../SC/HC/VB/CCGreen/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_color(animation_player,Color8(0,255,0))

func _on_Red_pressed():
	var animation_player = get_node("../SC/HC/VB/CCRed/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_color(animation_player,Color8(255,0,0))

func _on_Yellow_pressed():
	var animation_player = get_node("../SC/HC/VB/CCYellow/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_color(animation_player,Color8(255,255,0))

func _on_Blue_pressed():
	var animation_player = get_node("../SC/HC/VB/CCBlue/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_color(animation_player,Color8(0,0,255))

func _on_Brown_pressed():
	var animation_player = get_node("../SC/HC/VB/CCBrown/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_color(animation_player,Color8(204,102,0))

func _on_Skyblue_pressed():
	var animation_player = get_node("../SC/HC/VB/CCSkyBlue/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_color(animation_player,Color8(0,255,255))

func _on_Pink_pressed():
	var animation_player = get_node("../SC/HC/VB/CCPink/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_color(animation_player,Color8(255,105,180))
func _on_Darkgreen_pressed():
	var animation_player = get_node("../SC/HC/VB/CCDarkGreen/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_color(animation_player,Color8(0,100,0))
	

func play_forward_animation_change_pattern(animation_player,pattern_name):
	if previous_animation_player != animation_player:
		animation_player.play("crayon-move")
		var pattern_img_resource = load("res://assets/paint/pattern/"+pattern_name+".jpg")
		selected_texture = pattern_img_resource
		if Global.painting_type != "drawing":
			pattern_image = pattern_img_resource.get_data()
			pattern_image.lock()
#			print(pattern_image)
		previous_animation_player = animation_player
		mode = 1
	else:
		previous_animation_player = null
		
func play_forward_animation_change_color(animation_player,color):
	if previous_animation_player != animation_player:
		animation_player.play("crayon-move")
		main_color = color
		previous_animation_player = animation_player
		mode = 0
	else:
		previous_animation_player = null

func play_reverse_animation(animation_player):
	if previous_animation_player != null and previous_animation_player.current_animation_position !=0:
		previous_animation_player.play_backwards("crayon-move")
	
		
		
		
		
		
		
#if run:
#			print(img.get_pixel(currentX+1,currentY).r)
#			print(img.get_pixel(currentX+1,currentY).g)
#			print(img.get_pixel(currentX+1,currentY).b)
		
#		if currentX < sizeX and img.get_pixel(currentX+1,currentY).r > 0.15 and img.get_pixel(currentX+1,currentY).g > 0.15 and img.get_pixel(currentX+1,currentY).b > 0.15 and img.get_pixel(currentX+1,currentY) != main_color:
#			stack.append(currentX+1)
#			stack.append(currentY)
#		if currentX > 0 and img.get_pixel(currentX-1,currentY).r > 0.15 and img.get_pixel(currentX-1,currentY).g > 0.15 and img.get_pixel(currentX-1,currentY).b > 0.15 and img.get_pixel(currentX-1,currentY) != main_color:
#			stack.append(currentX-1)
#			stack.append(currentY)
#		if currentY < sizeY and img.get_pixel(currentX,currentY+1).r > 0.15 and img.get_pixel(currentX,currentY+1).g > 0.15 and img.get_pixel(currentX,currentY+1).b > 0.15 and img.get_pixel(currentX,currentY+1) != main_color:
#			stack.append(currentX)
#			stack.append(currentY+1)
#		if currentY > 0 and img.get_pixel(currentX,currentY-1).r > 0.15 and img.get_pixel(currentX,currentY-1).g > 0.15 and img.get_pixel(currentX,currentY-1).b > 0.15 and img.get_pixel(currentX,currentY-1) != main_color:
#			stack.append(currentX)
#			stack.append(currentY-1)

#	if currentX < sizeX and img.get_pixel(currentX+1,currentY).is_equal_approx(selected_color) and img.get_pixel(currentX+1,currentY) != main_color:
#			stack.append(currentX+1)
#			stack.append(currentY)
#		if currentX > 0 and img.get_pixel(currentX-1,currentY).is_equal_approx(selected_color) and img.get_pixel(currentX-1,currentY) != main_color:
#			stack.append(currentX-1)
#			stack.append(currentY)
#		if currentY < sizeY and img.get_pixel(currentX,currentY+1).is_equal_approx(selected_color) and img.get_pixel(currentX,currentY+1) != main_color:
#			stack.append(currentX)
#			stack.append(currentY+1)
#		if currentY > 0 and img.get_pixel(currentX,currentY-1).is_equal_approx(selected_color) and img.get_pixel(currentX,currentY-1) != main_color:
#			stack.append(currentX)
#			stack.append(currentY-1)


func _on_Ballon_pressed():
	var animation_player = get_node("../SC2/HC/VB/CCBallon/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_pattern(animation_player,"balloons")

func _on_BlueWhite_pressed():
	var animation_player = get_node("../SC2/HC/VB/CCBlueWhite/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_pattern(animation_player,"blue_white")

func _on_PinkBlue_pressed():
	var animation_player = get_node("../SC2/HC/VB/CCPinkBlue/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_pattern(animation_player,"pink_blue")

func _on_StreetArt_pressed():
	var animation_player = get_node("../SC2/HC/VB/CCStreetArt/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_pattern(animation_player,"street_art")

func _on_YellowDonuts_pressed():
	var animation_player = get_node("../SC2/HC/VB/CCYellowDonuts/AnimationPlayer")
	play_reverse_animation(animation_player)
	play_forward_animation_change_pattern(animation_player,"yellow_donuts")


func _on_CrayonButton_pressed():
	var animation_player_switch = get_node("../ToolSwitcher")
	if animation_player_switch != null and animation_player_switch.current_animation_position != 0:
		animation_player_switch.play_backwards("switch_colors_and_patterns")


func _on_PatternButon_pressed():
	var animation_player_switch = get_node("../ToolSwitcher")
	if animation_player_switch.current_animation_position != 0.5:
		animation_player_switch.play("switch_colors_and_patterns")

