extends Control

var game_paused = false
var button_focus = 1

onready var game_scene = get_tree()

onready var btn_resume = \
	get_node("MarginContainer/VBoxContainer/ButtonContainer/VButtonArray/ResumeLevel")
onready var btn_restart = \
	get_node("MarginContainer/VBoxContainer/ButtonContainer/VButtonArray/RestartLevel")
onready var btn_exit = \
	get_node("MarginContainer/VBoxContainer/ButtonContainer/VButtonArray/ExitLevel")

func _ready():
	update_button_focus()
	
func update_button_focus():
	match button_focus:
			1:
				btn_resume.grab_focus()
			2:
				btn_restart.grab_focus()
			3:
				btn_exit.grab_focus()

func _process(delta):
	if Input.is_action_just_pressed("ui_start_1"):
		if not game_paused and not get_parent().get_node("death_screen").visible:
			set_game_paused(true)
			update_button_focus()
		else:
			set_game_paused(false)
	
	if game_paused:
		handle_menu_buttons()

func handle_menu_buttons():
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

func set_game_paused(state):
	game_paused = state
	game_scene.paused = game_paused
	visible = game_paused
