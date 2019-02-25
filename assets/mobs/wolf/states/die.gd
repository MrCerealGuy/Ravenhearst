extends "state.gd"

func enter():
	owner.get_node("anim").play("dead")
	
	if not owner.pathfind_astar == null:
		owner.pathfind_astar.clear_previous_path_drawing()

func _on_animation_finished(anim_name):
	emit_signal("finished", "dead")
