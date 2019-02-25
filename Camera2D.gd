extends Camera2D

var target = null
var player_id = 0

func set_target(id, player):
	player_id = id
	target = player

func _physics_process(delta):
	if target:
		position = target.position
