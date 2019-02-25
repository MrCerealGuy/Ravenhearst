"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""
extends Node

signal finished(next_state_name)

# AStar
var path = []
var target_point_world = Vector2()
var arrived_to_next_point

func is_player_visible():
	var collider
	
	#if owner.look_direction.x == -1.0 and owner.sight_distance_left.is_colliding():
	if owner.sight_distance_left.is_colliding():
		collider = owner.sight_distance_left.get_collider()
	#elif owner.look_direction.x == 1.0 and owner.sight_distance_right.is_colliding():
	elif owner.sight_distance_right.is_colliding():
		collider = owner.sight_distance_right.get_collider()
	else:
		owner.focused_player = null
		return false
	
	if collider.is_in_group("players"):	# player in sight!	
		owner.focused_player = collider
	elif collider.is_in_group("player_wielditem"):	# player in sight!	
		owner.focused_player = collider.get_parent()
	else:
		owner.focused_player = null
		return false
		
	if not owner.get_node("sound_growl").playing:
		owner.get_node("sound_growl").play()

	return true

# Initialize the state. E.g. change the animation
func enter():
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return

func update(delta):
	return

func _on_animation_finished(anim_name):
	return
