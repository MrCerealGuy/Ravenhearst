# Collection of important methods to handle direction and animation
extends "../state.gd"

# Kinematic
const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)

var WALK_SPEED = rand_range(60,70)
var RUN_SPEED = rand_range(120,140)

const JUMP_SPEED = 480
const MAX_JUMP_ATTEMPTS = 1
var current_jump_attempt = 0

var current_speed = WALK_SPEED

var linear_vel = Vector2()
var on_floor = false

func handle_input(event):
	return .handle_input(event)
	
func update(delta):
	linear_vel += GRAVITY_VEC * delta
	linear_vel.x = owner.look_direction.x * current_speed
	
	linear_vel = owner.move_and_slide(linear_vel, FLOOR_NORMAL)
	on_floor = owner.is_on_floor()
	
	# AStar
	arrived_to_next_point = owner.position.distance_to(target_point_world) < 64.0
	
#		var collisionCounter = get_slide_count() - 1
#		if collisionCounter > -1:
#			var col = get_slide_collision(collisionCounter)
#			rotation = col.normal.angle_to(FLOOR_NORMAL)
	
	owner.get_node("sprite").scale = Vector2(-1.0*owner.look_direction.x, 1.0)
	
	# collision left
	if owner.detect_ceiling_left.is_colliding() or owner.detect_wall_left.is_colliding():
		# try to jump?
# TBD timer until next try
		if current_jump_attempt < MAX_JUMP_ATTEMPTS:
			current_jump_attempt += 1
			emit_signal("finished", "jump")
		else:
			owner.set_look_direction(Vector2(1.0,0))
			current_jump_attempt = 0
	
	# collision right
	elif owner.detect_ceiling_right.is_colliding() or owner.detect_wall_right.is_colliding():
		# try to jump?
		if current_jump_attempt < MAX_JUMP_ATTEMPTS:
			current_jump_attempt += 1
			emit_signal("finished", "jump")
		else:
			owner.set_look_direction(Vector2(-1.0,0))
			current_jump_attempt = 0
