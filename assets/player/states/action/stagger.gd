"""
The stagger state end with the stagger animation from the AnimationPlayer
The animation only affects the Body Sprite"s modulate property so 
it could stack with other animations if we had two AnimationPlayer nodes
"""
extends "../state.gd"

var knockback_direction = Vector2()

func enter():
	owner.get_node("anim").play("stagger")

func _on_animation_finished(anim_name):
	emit_signal("finished", "previous")
