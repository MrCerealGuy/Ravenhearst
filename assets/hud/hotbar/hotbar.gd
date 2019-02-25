extends MarginContainer

export (int) var player_id = 0

# SlotContainer
onready var _slot_container = $SlotContainer

var current_slot = 1

func get_slot_count():
	return _slot_container.get_size()
	
func get_slot_container():
	return _slot_container
	
func get_current_slot_id():
	return current_slot
	
func get_current_slot():
	return get_slot_by_id(current_slot)

func select_slot(slot):
	
	if slot in range(1, _slot_container.get_size()+1):
		current_slot = slot
	
		for i in range(1, _slot_container.get_size()+1):
			get_slot_by_id(i).deselect()
	
		get_slot_by_id(slot).select()
			
		if not global.get_player_node(player_id) == null:
			global.get_player_node(player_id)._on_hotbar_selection_changed(self)

func get_slot_by_id(slot_id):
	return _slot_container.get_slot(slot_id)

func add_item_to_slot(slot_id, item):
	return _slot_container.add_item_to_slot(slot_id, item)
	
func delete_item_from_slot(slot_id):
	_slot_container.delete_item_from_slot(slot_id)
	
func add_itemstack_to_slot(slot_id, item_stack):
	if slot_id in range (1, get_slot_count()+1):
		_slot_container.add_itemstack_to_slot(slot_id, item_stack)

func delete_itemstack_from_slot(slot_id):
	if slot_id in range (1, get_slot_count()+1):
		_slot_container.delete_itemstack_from_slot(slot_id)

func get_slot_item_id(slot_id):
	return _slot_container.get_slot_item_id(slot_id)
	
func get_current_item_id():
	return get_slot_item_id(current_slot)
	
func get_player():
	match player_id:
		1:
			return global.player1_node
		2:
			return global.player2_node

func _on_key_select_next_slot():
	if current_slot == _slot_container.get_size():
		current_slot = 1
	else:
		current_slot += 1
		
	select_slot(current_slot)
	
func _on_key_select_previous_slot():
	if current_slot == 1:
		current_slot = 8
	else:
		current_slot -= 1
		
	select_slot(current_slot)
	
func _init_hotbar():
	select_slot(current_slot)

func _ready():
	_init_hotbar()

func _process(delta):
	if Input.is_action_just_released("ui_select_previous_%s" % player_id) \
		and not get_player().get_backpack().visible:
		_on_key_select_previous_slot()
	if Input.is_action_just_released("ui_select_next_%s" % player_id) \
		and not get_player().get_backpack().visible:
		_on_key_select_next_slot()
