extends "on_ground.gd"

func enter():
	linear_vel = Vector2()

	owner.get_node("anim").play("idle")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	.update(delta)
	
	# Move
	if linear_vel.x != 0:
		emit_signal("finished", "move")

	# Jumping
	if on_floor and Input.is_action_just_pressed("ui_jump_%s" % owner.player_id) \
	and not owner.is_backpack_open():
		emit_signal("finished", "jump")
		
	# Shooting/using item
	if Input.is_action_just_pressed("ui_shoot_%s" % owner.player_id) \
	and not owner.is_backpack_open():
		#_on_action_key_pressed()
		emit_signal("finished", "action")
		
	# Open inventory
	if Input.is_action_just_released("ui_inventory_%s" % owner.player_id):
		emit_signal("finished", "backpack")

