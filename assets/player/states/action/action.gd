extends "../state.gd"

# Weapons
var shoot_time = 99999 # time since last shot

func enter():
	owner.get_node("anim").play("idle")

	# equipped with an item?
	if owner.current_wielded_item_id == items.ITEM_NONE:
		emit_signal("finished", "previous")
		return
	
	# using a weapon?
	if items.get_item_type(owner.current_wielded_item_id) == items.ITEM_TYPE_WEAPON:
		if not owner.current_wielded_item_node == null:
			if owner.current_wielded_item_node.use_item(owner) == true:
				shoot_time = 0
	# using a tool?
	elif items.get_item_type(owner.current_wielded_item_id) == items.ITEM_TYPE_TOOL:
		if not owner.current_wielded_item_node == null:
			if owner.current_wielded_item_node.has_method("use_item"):
				owner.current_wielded_item_node.use_item(owner)
	# using a block?
	elif items.get_item_type(owner.current_wielded_item_id) == items.ITEM_TYPE_BLOCK:
		emit_signal("finished", "placeblock")
		return
		
	emit_signal("finished", "previous")

func update(delta):
	# Increment counters
	shoot_time += delta

func _on_animation_finished(anim_name):
	#emit_signal("finished", "previous")
	pass
