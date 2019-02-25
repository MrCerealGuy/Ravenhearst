extends Button

func _ready():
	pass

func _process(delta):
	pass

func _on_ExitLevel_pressed():
	get_node("../../../../../").set_game_paused(false)
	get_tree().change_scene(global.MAINMENU_SCENE_PATH)

