extends "on_ground.gd"

const WAIT_UNTIL_PLAYER_LOST = 50
var counter_player_lost = 0
var counter_player_lost_2 = 0

func enter():
	owner.get_node("anim").play("walk")
	owner.get_node("anim").playback_speed = 2.0
	current_speed = RUN_SPEED
	
	counter_player_lost = 0
	counter_player_lost_2 = 0
	
	if owner.pathfind_astar == null:
		return

	if not owner.focused_player == null:
		# AStar
		path = owner.pathfind_astar._get_path(owner.position, owner.focused_player.position)
	else:
		emit_signal("finished", "move")
		return
	
	if not path or len(path) == 1:
		emit_signal("finished", "move")
		return
	# The index 0 is the starting cell
	# we don't want the character to move back to it in this example
	target_point_world = path[1]

func handle_input(event):
	return .handle_input(event)
	
func ready_to_attack():
	var collider = null
		
	match owner.look_direction.x:
		-1.0:
			if owner.detect_player_left.is_colliding():
				collider = owner.detect_player_left.get_collider()
		1.0:
			if owner.detect_player_right.is_colliding():
				collider = owner.detect_player_right.get_collider()
	
	if collider == null:	# no contact to player
		return false

	if collider.is_in_group("players"):
		owner.focused_player = collider
		return true
	elif collider.is_in_group("player_wielditem"):
		owner.focused_player = collider.get_parent()
		return true
	else:
		return false

func update(delta):
	.update(delta)
	
	# tbd check not every frame
	if not is_player_visible():
		if counter_player_lost_2 == WAIT_UNTIL_PLAYER_LOST:
			emit_signal("finished", "move")
			return
		else:
			counter_player_lost_2 += 1
		
	# change direction to player
	if not owner.focused_player == null:
		if owner.focused_player.position.x < owner.position.x:
			 owner.set_look_direction(Vector2(-1.0,0))
		else:
			 owner.set_look_direction(Vector2(1.0,0))
	# AStar
	if arrived_to_next_point:
		path.remove(0)
		if len(path) == 0:
			emit_signal("finished", "move")
			return
		target_point_world = path[0]

	# Attack?
	if ready_to_attack():
		emit_signal("finished", "attack")
	elif not ready_to_attack(): 
		counter_player_lost += 1
		
		if counter_player_lost == WAIT_UNTIL_PLAYER_LOST:
			# player changed direction?
			if owner.focused_player:
				if owner.focused_player.position.x > owner.position.x:
					owner.set_look_direction(Vector2(1.0,0))
				else:
					owner.set_look_direction(Vector2(-1.0,0))
			else:
				# player lost
				emit_signal("finished", "follow")

func _on_animation_finished(anim_name):
	owner.get_node("anim").play("walk")
