extends KinematicBody2D

signal mob_killed
var mob_killed = false

export var look_direction = Vector2(-1, 0)# setget set_look_direction

# AStar
onready var pathfind_astar_res = \
	preload("res://assets/mobs/ki/pathfind_astar.gd")
	
var pathfind_astar = null

# State
signal state_changed

var current_state = null
var states_stack = []

onready var states_map = {
	"idle": $mob_states/idle,
	"move": $mob_states/move,
	"jump": $mob_states/jump,
	"follow": $mob_states/follow,
	"attack": $mob_states/attack,
	"dead": $mob_states/die
}

# Attacking
var focused_player = null	# follow and attack this player

onready var detect_floor_left = $detect_floor_left
onready var detect_wall_left = $detect_wall_left
onready var detect_ceiling_left = $detect_ceiling_left

onready var detect_floor_right = $detect_floor_right
onready var detect_wall_right = $detect_wall_right
onready var detect_ceiling_right = $detect_ceiling_right

onready var detect_player_left = $detect_player_left
onready var detect_player_right = $detect_player_right

onready var sight_distance_left = $sight_distance_left
onready var sight_distance_right = $sight_distance_right
onready var sprite = $sprite

func get_look_direction():
	return look_direction

func set_look_direction(dir):
	look_direction = dir
	if dir.x==1.0:	# right
		$collision_body_right.disabled = false
		$collision_head_right.disabled = false
		$collision_body_right.visible = true
		$collision_head_right.visible = true
		
		$collision_body_left.disabled = true
		$collision_head_left.disabled = true
		$collision_body_left.visible = false
		$collision_head_left.visible = false
		
		$detect_wall_right.visible = true
		$detect_wall_right.enabled = true
		$detect_wall_left.visible = false
		$detect_wall_left.enabled = false
		
		$detect_ceiling_right.visible = true
		$detect_ceiling_right.enabled = true
		$detect_ceiling_left.visible = false
		$detect_ceiling_left.enabled = false
		
		#$sight_distance_left.enabled = false
		$sight_distance_left.enabled = true
		$sight_distance_right.enabled = true
		#$sight_distance_left.visible = false
		$sight_distance_right.visible = true
	else:			# left
		$collision_body_right.disabled = true
		$collision_head_right.disabled = true
		$collision_body_right.visible = false
		$collision_head_right.visible = false
		
		$collision_body_left.disabled = false
		$collision_head_left.disabled = false
		$collision_body_left.visible = true
		$collision_head_left.visible = true
		
		$detect_wall_right.visible = false
		$detect_wall_right.enabled = false
		$detect_wall_left.visible = true
		$detect_wall_left.enabled = true
		
		$detect_ceiling_right.visible = false
		$detect_ceiling_right.enabled = false
		$detect_ceiling_left.visible = true
		$detect_ceiling_left.enabled = true
		
		$sight_distance_left.enabled = true
		#$sight_distance_right.enabled = false
		$sight_distance_right.enabled = true
		$sight_distance_left.visible = true
		#$sight_distance_right.visible = false

func kill_mob():
	$sound_growl.stop()
	$sound_hit.play()
	
	for col in [$collision_body_right, $collision_head_right, 
	$collision_body_left, $collision_head_left]:
		col.disabled = true
		col.visible = false
		
	for det in [$detect_floor_left, $detect_wall_right,
	$detect_wall_left, $detect_floor_right,
	$detect_player_left, $detect_player_right,
	$detect_ceiling_left, $detect_ceiling_right]:
		det.enabled = false
		det.visible = false
		
	for sight in [$sight_distance_left, $sight_distance_right]:
		sight.enabled = false
		sight.visible = false
		
	mob_killed = true
	_change_state("dead")
	emit_signal("mob_killed")	# important for MobSpawner

func hit_by_bullet():
	if not mob_killed:
		kill_mob()

func _change_state(state_name):
	if global.DEBUG:
		$state_label.text = state_name
		logger.info(state_name)
	
	current_state.exit()

	if state_name == "previous":
		states_stack.pop_front()
	elif state_name in ["follow", "attack"]:
		states_stack.push_front(states_map[state_name])
	else:	# idle, move, jump, dead
		var new_state = states_map[state_name]
		states_stack[0] = new_state

	current_state = states_stack[0]
	
	if state_name != "previous":
		# We don"t want to reinitialize the state if we"re going back to the previous state
		current_state.enter()
	emit_signal("state_changed", states_stack)

func _ready():
	add_to_group("mobs")
		
	# AStar
	pathfind_astar = pathfind_astar_res.new(\
		global.world_node,Vector2(global.world_cells_x, global.world_cells_y))
	
	# Debug
	if not global.DEBUG:
		$state_label.visible = false
		#$kinematic_label.visible = false
	
	# Init states
	for state_node in $mob_states.get_children():
		state_node.connect("finished", self, "_change_state")

	states_stack.push_front($mob_states/idle)
	current_state = states_stack[0]
	_change_state("idle")

func _physics_process(delta):
	current_state.update(delta)

func _on_timer_wait_until_follow_timeout():
	print("timer stopped")

func _on_visibility_screen_exited():
	focused_player = null
	#state_before_screen_exited = state
	#state = STATE_IDLE
	_change_state("idle")

func _on_visibility_screen_entered():
	#state = state_before_screen_exited
	#if not states_stack[0] == null:
	#	_change_state("previous")
	
	_change_state("move")

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)
