extends Node

var _item_id	= items.ITEM_NONE

func is_stackable():
	return items.get_item_def(self._item_id).stackable
	
func get_max_stack_size():
	if is_stackable():
		return items.get_item_def(self._item_id).stack_max
	else:
		return 0
		
func get_wielded_item():
	return items.get_item_def(self._item_id).wielded_item_node
	
func get_item_id():
	return self._item_id
		
func clear_item():
	self._item_id = items.ITEM_NONE
	
func get_item_inv_icon():
	return items.get_item_def(self._item_id).inv_icon

func _init(item_id):
	self._item_id = item_id

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
