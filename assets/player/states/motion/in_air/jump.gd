extends "../motion.gd"

func enter():
	linear_vel.y = -JUMP_SPEED

func update(delta):
	.update(delta)
	
	if linear_vel.y == 0 and linear_vel.x == 0:
		emit_signal("finished", "idle")
	elif linear_vel.y == 0 and linear_vel.x != 0:
		emit_signal("finished", "move")
		
	# Shooting/using item
	if Input.is_action_just_pressed("ui_shoot_%s" % owner.player_id) \
	and not owner.is_backpack_open():
		#_on_action_key_pressed()
		emit_signal("finished", "action")
