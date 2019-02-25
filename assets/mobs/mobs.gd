extends Node

# mob keys
enum {
	MOB_NONE=-1,
	MOB_WOLF=0
}

# mob definitions
var _mob_definitions = {
	MOB_WOLF : {
		id_str = "wolf",
		name = "Wolf",
		desc = "Dangerous animal",
		mob_res = "res://assets/mobs/wolf/wolf.tscn"
	}
}

func get_mob_def(mob_id):
	if not mob_id == -1:
		return _mob_definitions.values()[mob_id]
	return null
	
func get_mob_res(mob_id):
	return get_mob_def(mob_id).mob_res

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
