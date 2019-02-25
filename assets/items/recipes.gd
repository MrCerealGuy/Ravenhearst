extends Node

# recipe keys
enum {
	RECIPE_NONE=-1,
	RECIPE_WOODPLANK=0
}

# recipe definitions
var _recipe_definitions = {
	RECIPE_WOODPLANK : {
		item = items.ITEM_WOODPLANK,
		ingredients = [items.ITEM_WOOD,items.ITEM_WOOD,items.ITEM_WOOD]
	}
}

func get_recipe_def(recipe_id):
	return _recipe_definitions.values()[recipe_id]
	
func get_recipe_ingredients(recipe_id):
	return get_recipe_def(recipe_id).ingredients

func get_recipe_item(recipe_id):
	return get_recipe_def(recipe_id).item

func _ready():
	pass
