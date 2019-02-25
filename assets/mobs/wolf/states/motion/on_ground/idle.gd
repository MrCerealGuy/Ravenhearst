extends "on_ground.gd"

func enter():
	owner.get_node("anim").play("idle")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	.update(delta)
	
	# Attack
	if is_player_visible():
		emit_signal("finished", "follow")
	
	# Move
	if linear_vel.x != 0:
		emit_signal("finished", "move")