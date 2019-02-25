extends Button

func _ready():
	pass

func _process(delta):
	pass

func _on_RestartLevel_pressed():
	get_node("../../../../../").set_game_paused(false)
	get_tree().reload_current_scene()
