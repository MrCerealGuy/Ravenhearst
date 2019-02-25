extends MarginContainer

export (int) var player_id

var old_hotbar_slot = 1

onready var _inventory = $HBoxContainer/VBoxContainer/inventory

func is_open():
	return visible

func get_inventory():
	return _inventory

func get_hotbar():
	match player_id:
		1:
			return global.hotbar1_node
		2:
			return global.hotbar2_node

func open():
	visible = true
	get_inventory().select_slot(1)
	
	# hide selection in hotbar
	old_hotbar_slot = get_hotbar().get_current_slot_id()
	get_hotbar().get_current_slot().deselect()

func close():
	visible = false
	
	# show selection in hotbar
	get_hotbar().select_slot(old_hotbar_slot)

func _ready():
	visible = false
