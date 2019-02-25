extends MarginContainer

onready var _slot_container = $SlotContainer

# Points at current slot
var current_slot = 1

# Moving items
var slot_move_start = 0
var slot_move_end   = 0

# Inventory states
enum {INV_SELECT, INV_ITEM_MOVE}
var state = INV_SELECT

func get_slot_count():
	return _slot_container.get_size()
	
func get_slot_container():
	return _slot_container
	
func get_hotbar():
	return get_backpack().get_hotbar()
			
func get_backpack():
	return get_node("../../../")

func add_item_to_inventory(item):
	return _slot_container.add_item(item)

func add_item_to_slot(slot_id, item):
	# inventory
	if slot_id in range (1, get_slot_count()+1):
		_slot_container.add_item_to_slot(slot_id, item)
	# hotbar
	elif slot_id in range(get_slot_count()+1, get_slot_count()+get_hotbar().get_slot_count()+1):
		get_hotbar().add_item_to_slot(slot_id-get_slot_count(), item)
	
func delete_item_from_slot(slot_id):
	# inventory
	if slot_id in range (1, get_slot_count()+1):		
		_slot_container.delete_item_from_slot(slot_id)
	# hotbar
	elif slot_id in range(get_slot_count()+1, get_slot_count()+get_hotbar().get_slot_count()+1):
		get_hotbar().delete_item_from_slot(slot_id-get_slot_count())

func add_itemstack_to_slot(slot_id, item_stack):
	# inventory
	if slot_id in range (1, get_slot_count()+1):
		_slot_container.add_itemstack_to_slot(slot_id, item_stack)
	# hotbar
	elif slot_id in range(get_slot_count()+1, get_slot_count()+get_hotbar().get_slot_count()+1):
		get_hotbar().add_itemstack_to_slot(slot_id-get_slot_count(), item_stack)
	
func delete_itemstack_from_slot(slot_id):
	# inventory
	if slot_id in range (1, get_slot_count()+1):		
		_slot_container.delete_itemstack_from_slot(slot_id)
	# hotbar
	elif slot_id in range(get_slot_count()+1, get_slot_count()+get_hotbar().get_slot_count()+1):
		get_hotbar().delete_itemstack_from_slot(slot_id-get_slot_count())

func get_slot_by_id(slot_id):
	# inventory
	if slot_id in range (1, get_slot_count()+1):
		return _slot_container.get_slot(slot_id)
	# hotbar
	elif slot_id in range(get_slot_count()+1, get_slot_count()+get_hotbar().get_slot_count()+1):
		return get_hotbar().get_slot_by_id(slot_id-get_slot_count())
	
	print("get_slot_by_id(%d) failed" % slot_id)
	return null
	
func select_slot(slot_id):
	# slot id in inventory
	if slot_id in range(1, get_slot_count()+1):
		get_slot_by_id(current_slot).deselect()
		current_slot = slot_id
		get_slot_by_id(current_slot).select()
	# slot id in hotbar
	elif slot_id in range(get_slot_count()+1, get_slot_count()+get_hotbar().get_slot_count()+1):
		get_slot_by_id(current_slot).deselect()
		get_hotbar().select_slot(slot_id-get_slot_count())
		current_slot = slot_id
	
func get_itemstack_from_slot(slot_id):
	# slot id in inventory
	if slot_id in range(1, get_slot_count()+1):
		return _slot_container.get_slot(slot_id).get_itemstack()
	# slot id in hotbar
	elif slot_id in range(get_slot_count()+1, get_slot_count()+get_hotbar().get_slot_count()+1):
		return get_hotbar().get_slot_container().get_slot(slot_id-get_slot_count()).get_itemstack()

func move_itemstack_from_to(from, to):
	var item_from
	var item_to
	
	item_from = get_itemstack_from_slot(from)
	item_to   = get_itemstack_from_slot(to)
	
	# is target slot free?
	if item_to == null:
		# yes!
		delete_itemstack_from_slot(from)
		add_itemstack_to_slot(to, item_from)
	else:
		# no, switch items stacks
		delete_itemstack_from_slot(from)
		delete_itemstack_from_slot(to)
		
		add_itemstack_to_slot(to, item_from)
		add_itemstack_to_slot(from, item_to)
		
func move_item_hotbar():
	pass

func get_itemstack_from_currentslot():
	return get_itemstack_from_slot(current_slot)
	
func _ready():
	pass

func _on_key_pressed_get_item():
	if state == INV_SELECT:
		if get_itemstack_from_currentslot() == null:
			return

		state = INV_ITEM_MOVE
		slot_move_start = current_slot
		get_slot_by_id(slot_move_start).set_active()

func _on_key_pressed_set_item():
	# make sure selection is visible
	get_slot_by_id(current_slot).select()
		
	slot_move_end = current_slot
	move_itemstack_from_to(slot_move_start, slot_move_end)
	get_slot_by_id(current_slot).set_active(false)
	
	state = INV_SELECT

func _on_key_pressed_abort_move():
	state = INV_SELECT
	get_slot_by_id(current_slot).select()

func _on_key_pressed_select_slot_left():
	select_slot(current_slot-1)
	get_slot_by_id(current_slot).set_active(false)

func _on_key_pressed_select_slot_right():
	select_slot(current_slot+1)
	get_slot_by_id(current_slot).set_active(false)

func _on_key_pressed_select_slot_up():
	select_slot(current_slot-_slot_container.cols)
	get_slot_by_id(current_slot).set_active(false)
	
func _on_key_pressed_select_slot_down():
	select_slot(current_slot+_slot_container.cols)
	get_slot_by_id(current_slot).set_active(false)
		
func _on_key_pressed_move_item_left():
	_on_key_pressed_select_slot_left()
	get_slot_by_id(current_slot).set_active()
	
func _on_key_pressed_move_item_right():
	_on_key_pressed_select_slot_right()
	get_slot_by_id(current_slot).set_active()
	
func _on_key_pressed_move_item_up():
	_on_key_pressed_select_slot_up()
	get_slot_by_id(current_slot).set_active()

func _on_key_pressed_move_item_down():
	_on_key_pressed_select_slot_down()
	get_slot_by_id(current_slot).set_active()

func _process(delta):
	
	var backpack_visible = get_backpack().is_open()
	
	if not backpack_visible:
		return

	if state == INV_SELECT:
		# select slot
		if backpack_visible and Input.is_action_just_released("ui_left_%s" % get_backpack().player_id):
			_on_key_pressed_select_slot_left()
		if backpack_visible and Input.is_action_just_released("ui_right_%s" % get_backpack().player_id):
			_on_key_pressed_select_slot_right()
		if backpack_visible and Input.is_action_just_released("ui_up_%s" % get_backpack().player_id):
			_on_key_pressed_select_slot_up()
		if backpack_visible and Input.is_action_just_released("ui_down_%s" % get_backpack().player_id):
			_on_key_pressed_select_slot_down()
		
		# select item
		if backpack_visible and Input.is_action_just_released("ui_jump_%s" % get_backpack().player_id):
			_on_key_pressed_get_item()
	elif state == INV_ITEM_MOVE:
		
		# set item
		if backpack_visible and Input.is_action_just_released("ui_jump_%s" % get_backpack().player_id):
			_on_key_pressed_set_item()
			
		# abort moving item
		if backpack_visible and Input.is_action_just_released("ui_back_%s" % get_backpack().player_id):
			_on_key_pressed_abort_move()
			
		# move item
		if backpack_visible and Input.is_action_just_released("ui_left_%s" % get_backpack().player_id):
			_on_key_pressed_move_item_left()
		if backpack_visible and Input.is_action_just_released("ui_right_%s" % get_backpack().player_id):
			_on_key_pressed_move_item_right()
		if backpack_visible and Input.is_action_just_released("ui_up_%s" % get_backpack().player_id):
			_on_key_pressed_move_item_up()
		if backpack_visible and Input.is_action_just_released("ui_down_%s" % get_backpack().player_id):
			_on_key_pressed_move_item_down()