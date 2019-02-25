extends "../state.gd"

func enter():
	owner.get_node("anim").play("attack")
	attack_player()
	
func update(delta):
	if is_player_visible():
		attack_player()
	else:
		emit_signal("finished", "move")
	
func attack_player():
	var collider = null
	
	match owner.look_direction.x:
		-1.0:
			if owner.detect_player_left.is_colliding():
				collider = owner.detect_player_left.get_collider()
		1.0:
			if owner.detect_player_right.is_colliding():
				collider = owner.detect_player_right.get_collider()
	
	if collider == null:	# no contact to player
		emit_signal("finished", "move")
		return

	if collider.is_in_group("players"):
		owner.focused_player = collider
	elif collider.is_in_group("player_wielditem"):
		owner.focused_player = collider.get_parent()
	else:
		owner.focused_player = null
		emit_signal("finished", "move")
		return

	if owner.get_node("timer_attack").is_stopped() and \
	owner.focused_player.has_method("hit_by_enemy"):
	#if owner.focused_player.has_method("hit_by_enemy"):
		owner.focused_player.hit_by_enemy(1)
		owner.get_node("timer_attack").start()
	
func _on_animation_finished(anim_name):
	emit_signal("finished", "attack")

func _on_action_finished():
	pass
