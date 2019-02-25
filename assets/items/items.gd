extends Node

var _ItemContainer	= load("res://assets/items/ItemContainer.gd")
var _ItemStack		= load("res://assets/items/ItemStack.gd")
var _Item			= load("res://assets/items/Item.gd")

# item type keys
enum {
	ITEM_TYPE_NONE		=	-1,
	ITEM_TYPE_DEFAULT	=	0,
	ITEM_TYPE_WEAPON	=	1,
	ITEM_TYPE_TOOL		=	2,
	ITEM_TYPE_BLOCK		=	3
}

# item keys
enum {
	ITEM_NONE=-1,
	ITEM_STONE=0,
	ITEM_WOOD,
	ITEM_WEAPON_SHOTGUN,
	ITEM_TOOL_IRONPICKAXE,
	ITEM_WOODPLANK,
	ITEM_TOOL_TORCH,
	ITEM_BLOCK_WOOD
}

# item definitions
var _item_definitions = {
	ITEM_STONE : {
		id_str = "stone",
		type = ITEM_TYPE_DEFAULT,
		name = "Stone",
		desc = "Piece of stone",
		wielded_item_node = null,
		inv_icon = "res://assets/items/stone/stone_inv_icon.png",
		stackable = true,
		stack_max = 5
	},
	ITEM_WOOD : {
		id_str = "wood",
		type = ITEM_TYPE_DEFAULT,
		name = "Wood",
		desc = "Piece of wood",
		wielded_item_node = null,
		inv_icon = "res://assets/items/wood/wood_inv_icon.png",
		stackable = true,
		stack_max = 5
	},
	ITEM_WEAPON_SHOTGUN : {
		id_str = "shotgun",
		type = ITEM_TYPE_WEAPON,
		name = "Shotgun",
		desc = "This is a weapon!",
		wieldable = true,
		wielded_item_node = "res://assets/items/shotgun/shotgun_wielded.tscn",
		inv_icon = "res://assets/items/shotgun/shotgun_inv_icon.png",
		stackable = false
	},
	ITEM_TOOL_IRONPICKAXE : {
		id_str = "ironpickaxe",
		type = ITEM_TYPE_TOOL,
		name = "Iron Pickaxe",
		desc = "A tool for grinding stones.",
		wieldable = true,
		wielded_item_node = "res://assets/items/ironpickaxe/ironpickaxe_wielded.tscn",
		inv_icon = "res://assets/items/ironpickaxe/ironpickaxe_inv_icon.png",
		stackable = false
	},
	ITEM_WOODPLANK : {
		id_str = "woodplank",
		type = ITEM_TYPE_DEFAULT,
		name = "Wood Plank",
		desc = "Made of wood",
		wielded_item_node = null,
		inv_icon = "res://assets/items/woodplank/woodplank_inv_icon.png",
		stackable = true,
		stack_max = 3
	},
	ITEM_TOOL_TORCH : {
		id_str = "torch",
		type = ITEM_TYPE_TOOL,
		name = "Torch",
		desc = "Light! Light!",
		wieldable = true,
		wielded_item_node = "res://assets/items/torch/torch_wielded.tscn",
		inv_icon = "res://assets/items/torch/torch_inv_icon.png",
		stackable = true,
		stack_max = 3
	},
	ITEM_BLOCK_WOOD : {
		id_str = "block_wood",
		block_id = 1,
		type = ITEM_TYPE_BLOCK,
		name = "Wood Block",
		desc = "A simple wooden block.",
		wieldable = false,
		block_node = "res://assets/objects/blocks/block_wood.tscn",
		inv_icon = "res://assets/items/blocks/block_wood_inv_icon.png",
		stackable = true,
		stack_max = 10,
		block_size = Vector2(32.0,32.0)
	}
}

func get_item_def(item_id):
	return _item_definitions.values()[item_id]
	
func get_item_type(item_id):
	return get_item_def(item_id).type

func get_item_inv_icon_node(id):
	return get_item_def(id).inv_icon_node

func _ready():
	pass
