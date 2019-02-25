extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	
func _init():
	global.world_node = self
	global.world_cells_x = 85
	global.world_cells_y = 20

func _draw():
	var mobs_arr = []
	
	if not global.DEBUG:
		return
	
	mobs_arr = get_tree().get_nodes_in_group("mobs")
	
	for mob in mobs_arr:
		if not mob.pathfind_astar == null:
			if not mob.mob_killed:
				mob.pathfind_astar.draw()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
