extends Viewport

#onready var hotbar_1 = get_node("Hotbar_1")

func _ready():
	match global.game_mode:
		global.GAME_MODES.GM_SINGLEPLAYER:
			size.x = global.screen_x
			size.y = global.screen_y
		global.GAME_MODES.GM_LOCALCOOP:
			size.x = (global.screen_x / 2)-3
			size.y = global.screen_y
	
	#hotbar_1.position.x = 50#(size.x / 2) - (584 / 2)
	#hotbar_1.position.y = 600#size.y - 88

#func _process(delta):
#	pass
