extends Area2D

const BULLET_VELOCITY = 2000

export (int) var shots = 0
export (int) var MAGAZINE = 2
export (bool) var in_use = false

func _ready():
	add_to_group("player_wielditem")

func use_item(player):
	if in_use == true:
		return false
		
	shots += 1
	
	if shots == (MAGAZINE+1):	# reload weapon, can't shoot
		in_use = true
		$sound_reload.play()
		$timer_reload.start()	# wait some time for next shoot
		return false
	else:						# ready to shoot
		var bullet = preload("res://assets/items/shotgun/shotgun_bullet.tscn").instance()
		bullet.position = get_node("sprite/bullet_shoot").global_position # use node for shoot position
		bullet.linear_velocity = Vector2(player.get_node("sprite").scale.x * BULLET_VELOCITY, 0)
		bullet.add_collision_exception_with(player) # don't want player to collide with bullet
		player.get_parent().add_child(bullet) # don't want bullet to move with me, so add it as child of parent
		
		$sound_shoot.play()
		return true

func _on_timer_reload_timeout():
	in_use = false
	shots = 0
