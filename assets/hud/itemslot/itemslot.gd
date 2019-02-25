extends Control

#var _count_label

var _ItemStack = items._ItemStack
var _item_stack = null
	
func add_itemstack(item_stack):
	if not item_stack == null:
		if _item_stack == null:
			_item_stack = item_stack

			# set icon
			_set_item_icon(items.get_item_def(get_item_id()).inv_icon)

			# set count label
			_set_item_count(get_stack_size())
			return true
		else:
			return false
	return false

func add_item(item):
	if not _item_stack == null and not item == null:
		if _item_stack.push_back(item):
			# update count label
			_set_item_count(get_stack_size())

			return true

	return false
	
func remove_itemstack():
	_set_item_count(0)
	_set_item_icon(null)

	if not _item_stack == null:
		#tbd delete item stack
		pass

	_item_stack = null

func get_itemstack():
	return _item_stack

func get_item_id():
	if not _item_stack == null:
		return _item_stack.get_item_id()
	return items.ITEM_NONE

func is_stackable():
	return _item_stack.is_stackable()

func get_stack_size():
	return _item_stack.get_stack_size()

func get_max_stack_size():
	return _item_stack.get_max_stack_size()

func select():
	$selected_icon.set_visible()
	
func deselect():
	$selected_icon.set_visible(false)
	
func selected():
	return $selected_icon.visible
	
func set_active(a=true):
	if a and not selected():
		select()
	$selected_icon.set_blink(a)
	
func _set_item_count(n):
	if n == 0:
		$itemcount_label.text = ""
	else:
		$itemcount_label.text = String(n)

func _set_item_icon(icon_path):
	if not icon_path == null:
		$item.texture = load(icon_path)
	else:
		$item.texture = null

func _ready():
	_set_item_count(0)
	_set_item_icon(null)
	deselect()

