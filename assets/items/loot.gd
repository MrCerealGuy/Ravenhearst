extends Node

# loot container keys
enum {
	LOOT_NONE=0,
	LOOT_STONE_X1=1,
	LOOT_STONE_X2=2,
	LOOT_WOOD_X1=3
}

# loot containers
var _loot_container_definitions = {
	LOOT_NONE : {
		item_tool = items.ITEM_NONE,
		loot = [items.ITEM_NONE]
	},
	LOOT_STONE_X1 : {
		item_tool = items.ITEM_TOOL_IRONPICKAXE,
		loot = [items.ITEM_STONE]
	},
	LOOT_STONE_X2 : {
		item_tool = items.ITEM_TOOL_IRONPICKAXE,
		loot = [items.ITEM_STONE, items.ITEM_STONE]
	},
	LOOT_WOOD_X1 : {
		item_tool = items.ITEM_TOOL_IRONPICKAXE,
		loot = [items.ITEM_WOOD]
	}
}

func get_loot_container(id):
	return _loot_container_definitions.values()[id]
	
func get_loot_items(id):
	var container = get_loot_container(id)
	
	if not container == null:
		return container.loot

	return null

func _ready():
	pass


