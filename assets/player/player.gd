extends KinematicBody2D

export var player_id = 0

signal player_killed
var player_killed = false

# cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $sprite

var current_wielded_item_id		= items.ITEM_NONE
var current_wielded_item_node 	= null

var look_direction = Vector2(1, 0)# setget set_look_direction

# State
signal state_changed

var current_state = null
var states_stack = []

onready var states_map = {
	"idle": $player_states/idle,
	"move": $player_states/move,
	"jump": $player_states/jump,
	"action": $player_states/action,
	"backpack": $player_states/backpack,
	"placeblock": $player_states/placeblock,
	"stagger": $player_states/stagger,
	"dead": $player_states/die
}

func get_look_direction():
	return look_direction

func set_look_direction(dir):
	look_direction = dir
	
	sprite.scale.x = dir.x

	if not current_wielded_item_node == null:
		current_wielded_item_node.get_node("sprite").scale.x = dir.x
		current_wielded_item_node.position = Vector2(dir.x*32.0,0.0)

func get_loot_notifier():
	return $loot_notifier_container

func hit_by_enemy(damage):
	if not player_killed:
		$player_health.take_damage(damage)

func kill_player():
	remove_from_group("players")

	$anim.play("dead")
	
	if not current_wielded_item_node == null:
		current_wielded_item_node.visible = false
		
	$collision.disabled = true
	$collision.visible = false
	$collision_dead.disabled = false
	
	# wait some time until death screen
	$player_deathscreen_timer.start()
	
	player_killed = true
	_change_state("dead")
	emit_signal("player_killed", player_id)

func is_player_killed():
	return player_killed
	
func get_backpack():
	match player_id:
		1:
			return global.backpack1_node
		2:
			return global.backpack2_node

func is_backpack_open():
	if not get_backpack() == null:
		return get_backpack().visible
	else:
		return false
		
func _input(event):
	current_state.handle_input(event)

func _physics_process(delta):
	current_state.update(delta)
	
	if player_killed:
		return

func _on_player_deathscreen_timer_timeout():
	global.root_node.get_node("death_screen").visible = true
	
func _on_hotbar_selection_changed(hotbar):
	current_wielded_item_id = hotbar.get_current_item_id()
		
	# delete current wielded item if exist
	if not current_wielded_item_node == null:
		remove_child(current_wielded_item_node)
		current_wielded_item_node.queue_free()
		current_wielded_item_node = null
	
	# selected empty slot?
	if current_wielded_item_id == items.ITEM_NONE:
		return

	# exist a wielded item from selected item?
	if items.get_item_def(current_wielded_item_id).wieldable and \
	not items.get_item_def(current_wielded_item_id).wielded_item_node == null:
		# yes, make instance from new wielded item
		current_wielded_item_node = \
			load(items.get_item_def(current_wielded_item_id).wielded_item_node).instance()
		
		# equip player with wielded item
		add_child(current_wielded_item_node)
		
		# adjust direction
		current_wielded_item_node.get_node("sprite").scale.x = sprite.scale.x
		current_wielded_item_node.position = Vector2(sprite.scale.x*32.0,0.0)
		
func _change_state(state_name):
	if global.DEBUG:
		$state_label.text = state_name
		logger.info(state_name)
	
	current_state.exit()

	if state_name == "previous":
		states_stack.pop_front()
	elif state_name in ["stagger", "action", "backpack", "placeblock"]:
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
	add_to_group("players")
	
	if not global.DEBUG:
		$state_label.visible = false
		$kinematic_label.visible = false
	
	for state_node in $player_states.get_children():
		state_node.connect("finished", self, "_change_state")

	states_stack.push_front($player_states/idle)
	current_state = states_stack[0]
	_change_state("idle")

func _exit_tree():
	if not current_wielded_item_node == null:
		current_wielded_item_node.queue_free()

func _on_PlayerHealth_player_killed():
	kill_player()

func _on_PlayerHealth_health_depleted(health):
	pass # replace with function body

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

