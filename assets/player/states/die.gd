extends "state.gd"

# Initialize the state. E.g. change the animation
func enter():
	owner.get_node("anim").play("dead")
	
func update(delta):
	return

func _on_animation_finished(anim_name):
	emit_signal("finished", "dead")
