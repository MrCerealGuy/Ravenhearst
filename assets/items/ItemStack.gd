# ItemStack
#
# Container of Item objects with similar item id

extends Node

var _item_id = items.ITEM_NONE
var _container = []

func get_item_id():
	return _item_id

func is_stackable():
	return items.get_item_def(_item_id).stackable
	
func get_item(index):
	if index < _container.size():
		return _container[index]
	else:
		return null

func get_stack_size():
	return _container.size()

func get_max_stack_size():
	return items.get_item_def(_item_id).stack_max
	
func push_back(item):
	# append only similar items
	if item == null or not item.get_item_id() == _item_id:
		return false
	
	# if item is not stackable, accept only one item
	if not item.is_stackable() and _container.size() == 0:
		_container.push_back(item)
	# check for max stack size
	elif _container.size() < item.get_max_stack_size():
		_container.push_back(item)
	else:
		return false
	
	return true
	
func pop_back():
	_container.pop_back()
	
func _init(item_id):
	_item_id = item_id

func _ready():
	pass
