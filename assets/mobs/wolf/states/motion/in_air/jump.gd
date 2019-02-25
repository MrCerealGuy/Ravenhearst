extends "../motion.gd"

func enter():

#	if current_jump_attempt < MAX_JUMP_ATTEMPTS:
#		current_jump_attempt += 1
#
#		linear_vel.y = -JUMP_SPEED
#		owner.get_node("anim").play("jumping")
#	else:
#		current_jump_attempt = 0
#		emit_signal("finished", "move")

	linear_vel.y = -JUMP_SPEED
	#current_jump_attempt = 0
	
	owner.get_node("anim").play("jumping")
	

func update(delta):
	.update(delta)
	
	if linear_vel.y == 0 and linear_vel.x == 0:
		emit_signal("finished", "idle")
	elif linear_vel.y == 0 and linear_vel.x != 0:
		emit_signal("finished", "move")
		
func _on_animation_finished(anim_name):
	emit_signal("finished", "move")