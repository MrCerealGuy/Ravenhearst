extends "../state.gd"

func enter():
	owner.get_node("anim").play("idle")
	
	owner.get_backpack().open()
	
func update(delta):
	# close inventory
	if Input.is_action_just_released("ui_inventory_%s" % owner.player_id) or \
	Input.is_action_just_released("ui_back_%s" % owner.player_id):
		owner.get_backpack().close()
		emit_signal("finished", "idle")


func _on_animation_finished(anim_name):
	pass
	#emit_signal("finished", "previous")