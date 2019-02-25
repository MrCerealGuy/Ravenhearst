extends Control

onready var btn_singleplayer = \
	get_node("MarginContainer/VBoxContainer/ButtonContainer/VButtonArray/1Player")
onready var btn_coop = \
	get_node("MarginContainer/VBoxContainer/ButtonContainer/VButtonArray/2Player")
onready var btn_exit = \
	get_node("MarginContainer/VBoxContainer/ButtonContainer/VButtonArray/Exit")

var button_focus = 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	update_button_focus()
	
func update_button_focus():
	match button_focus:
			1:
				btn_singleplayer.grab_focus()
			2:
				btn_coop.grab_focus()
			3:
				btn_exit.grab_focus()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_down_1") or \
	   Input.is_action_just_pressed("ui_down_2"):
		button_focus += 1
		
		if button_focus == 4:
			button_focus = 3
		else:
			update_button_focus()
			$sound_select.play()

	if Input.is_action_just_pressed("ui_up_1") or \
	   Input.is_action_just_pressed("ui_up_2"):
		button_focus -= 1
		
		if button_focus == 0:
			button_focus = 1
		else:
			update_button_focus()
			$sound_select.play()
		
