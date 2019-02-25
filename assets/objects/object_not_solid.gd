extends Area2D

export var loot_container = 0	# loot.LOOT_NONE

func set_loot_container(id):
	loot_container = id
	
func get_loot_container():
	return loot_container

func hit(player, wielded_tool):
	
	var loot_items = null
	
	if not loot_container == loot.LOOT_NONE:
		loot_items = loot.get_loot_items(loot_container)
		
		if not loot_items == null:
			for item_id in loot_items:
				if not player.get_backpack().get_inventory().add_item_to_inventory(items._Item.new(item_id)) == -1:
					player.get_loot_notifier().add_notification(1, items.get_item_def(item_id).name)

func _init():
	if loot_container == null:
		loot_container = loot.LOOT_NONE

func _ready():
	pass


