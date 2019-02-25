# Collection of important methods to handle direction and animation
extends "../state.gd"

# Kinematic
const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 480

func handle_input(event):
	return .handle_input(event)
	
func update(delta):
	# Apply gravity
	linear_vel += delta * GRAVITY_VEC
	
	if owner.look_direction.x == 1 and linear_vel.x < 0:
		linear_vel.x *= -1
	elif owner.look_direction.x == -1 and linear_vel.x > 0:
		linear_vel.x *= -1
	
	# Move and slide
	linear_vel = owner.move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	# Detect if we are on floor - only works if called *after* move_and_slide
	on_floor = owner.is_on_floor()
	
	if owner.is_player_killed():
		return

	# Horizontal movement
	var target_speed = 0
	
	if Input.is_action_pressed("ui_left_%s" % owner.player_id) \
		and not owner.is_backpack_open():
		owner.set_look_direction(Vector2(-1,0))
		target_speed -= 1
		#if linear_vel.x > 0:
		#	linear_vel.x *= -1
	if Input.is_action_pressed("ui_right_%s" % owner.player_id) \
		and not owner.is_backpack_open():
		owner.set_look_direction(Vector2(1,0))
		target_speed += 1
		#if linear_vel.x < 0:
		#	linear_vel.x *= -1
		

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	if global.DEBUG:
		owner.get_node("kinematic_label").text = "vel.x=%d, vel.y=%d\ndirection=%d" % [linear_vel.x, linear_vel.y, owner.look_direction.x]
		logger.info("vel.x=%d, vel.y=%d, direction=%d" % [linear_vel.x, linear_vel.y, owner.look_direction.x])
	#if owner.look_direction.x == 1 and linear_vel.x < 0:
	#	print("Error")