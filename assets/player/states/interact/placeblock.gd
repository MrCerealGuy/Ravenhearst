extends "../state.gd"

var block_node_def = null
var block_node_res = null
var block_node = null

const MAX_PLACE_POSITION = 3
var place_vector = Vector2(0,0)	# relative place block vector

func enter():
	owner.get_node("anim").play("idle")
	place_vector = Vector2(0,0)
	
	block_node_def = items.get_item_def(owner.current_wielded_item_id)
	
	if block_node_def == null:
		emit_signal("finished", "idle")
		return
	
	block_node_res = block_node_def.block_node
	
	if block_node_res == null:
		emit_signal("finished", "idle")
		return
		
	block_node = load(block_node_res).instance()
	block_node.position = \
		Vector2(int(owner.global_position.x / block_node_def.block_size.x)*block_node_def.block_size.x,\
				int(owner.global_position.y / block_node_def.block_size.y)*block_node_def.block_size.y)

	owner.get_node("block_container").add_child(block_node)

func update(delta):
	# abort place block
	if Input.is_action_just_pressed("ui_back_%s" % owner.player_id):
		owner.get_node("block_container").remove_child(block_node)
		block_node.queue_free()
		emit_signal("finished", "idle")
		return
		
	# place block / new block
	if Input.is_action_just_pressed("ui_shoot_%s" % owner.player_id):
		owner.get_node("placing_block").play()
		emit_signal("finished", "placeblock")
		return
		
	# left
	if Input.is_action_just_pressed("ui_left_%s" % owner.player_id):
		if block_node:
			if place_vector.x > -1*MAX_PLACE_POSITION:
				place_vector.x -= 1
				block_node.position.x -= block_node_def.block_size.x
	# right
	elif Input.is_action_just_pressed("ui_right_%s" % owner.player_id):
		if block_node:
			if place_vector.x < MAX_PLACE_POSITION:
				place_vector.x += 1
				block_node.position.x += block_node_def.block_size.x
	# up
	elif Input.is_action_just_pressed("ui_up_%s" % owner.player_id):
		if block_node:
			if place_vector.y < MAX_PLACE_POSITION:
				place_vector.y += 1
				block_node.position.y -= block_node_def.block_size.y
	# down
	elif Input.is_action_just_pressed("ui_down_%s" % owner.player_id):
		if block_node:
			if place_vector.y > -1*MAX_PLACE_POSITION:
				place_vector.y -= 1
				block_node.position.y += block_node_def.block_size.y


func _on_animation_finished(anim_name):
	pass
	#emit_signal("finished", "previous")

