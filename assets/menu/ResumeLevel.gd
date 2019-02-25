extends Button

func _ready():
	pass

func _process(delta):
	pass

func _on_ResumeLevel_pressed():
	get_node("../../../../../").set_game_paused(false)
	