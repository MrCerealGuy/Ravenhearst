extends "on_ground.gd"

func enter():	
	owner.get_node("anim").play("walk")
	
	current_speed = WALK_SPEED
	owner.get_node("anim").playback_speed = 1.0

func handle_input(event):
	return .handle_input(event)

func update(delta):
	.update(delta)
	
	# Attack
	if is_player_visible():
		 emit_signal("finished", "follow")
	
	# Idle
	if linear_vel.x == 0:
		emit_signal("finished", "idle")

