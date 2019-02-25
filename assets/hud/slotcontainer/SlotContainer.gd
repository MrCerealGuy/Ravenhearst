extends VBoxContainer

export (int) var rows = 0
export (int) var cols = 0

var _ItemStack = items._ItemStack

func add_item(item):
	if item == null:
		return -1
		
	# check for existing stack with free space
	for i in range(get_size()):
		# check for similar item id
		if get_slot_item_id(i+1) == item.get_item_id():
			# check for stackable
			if get_slot(i+1).is_stackable():
				# check for free space
				if get_slot(i+1).get_stack_size() < get_slot(i+1).get_max_stack_size():
					# add item
					get_slot(i+1).add_item(item)
					
					return (i+1)
			
	# no existing stack found, create new one
	for i in range(get_size()):
		if get_slot_item_id(i+1) == items.ITEM_NONE:
			# create new item stack
			get_slot(i+1).add_itemstack(_ItemStack.new(item.get_item_id()))
				
			# add item to item stack
			get_slot(i+1).add_item(item)
			
			return (i+1)
	
	return -1

func add_item_to_slot(s, item):
	if item == null:
		return false
		
	# exist an item stack?
	if not get_slot(s).get_itemstack() == null:
		# yes, check for similar item id
		if item.get_item_id() == \
			get_slot(s).get_itemstack().get_item_id():
			return get_slot(s).add_item(item)
	else:
		#no, create new item stack
		get_slot(s).add_itemstack(_ItemStack.new(item.get_item_id()))
			
		# add item to item stack
		get_slot(s).add_item(item)

		return true
	return false
	
func delete_item_from_slot(s):
	get_slot(s).remove_item()
	
func add_itemstack_to_slot(s, item_stack):
	get_slot(s).add_itemstack(item_stack)
	
func delete_itemstack_from_slot(s):
	get_slot(s).remove_itemstack()
	
func get_slot_item_id(s):
	return get_slot(s).get_item_id()

func get_slot(s):
	var i = 1
	
	for y in range(rows):
		for x in range(cols):
			if i == s:
				return _get_row(y).get_node("Slot_%d" % (x+1))
			i += 1
			
func get_size():
	return rows*cols
	
func _get_row(r):
	return get_node("Row_%d" % (r+1))

func _ready():
	pass