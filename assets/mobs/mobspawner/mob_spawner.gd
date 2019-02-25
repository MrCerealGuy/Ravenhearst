extends Node2D

export (int) var mob_id = -1	# see mobs.gd
export (int) var max_mobs = 0
export (int) var mob_direction = 0	# 0 = all directions, -1 = left, 1 = right

var mob_res = null

var mob_count = 0
var mob_count_living = 0

func _ready():
	$Label.visible = false
	$MobSprite.visible = false
		
	mob_res = mobs.get_mob_res(mob_id)
	
	if not mob_res == null:
		_set_rand_spawn_timer()

func _process(delta):
	pass
	
func _set_rand_spawn_timer():
	$TimerNextSpawn.wait_time = rand_range(0,10)
	$TimerNextSpawn.start()

func _on_TimerNextSpawn_timeout():
	var mob = null
	
	# do not spawn more than max_mobs
	if mob_count_living < max_mobs:
		mob = load(mob_res).instance()
		
		if not mob == null:
			mob.connect("mob_killed", self, "_on_mob_killed")
			$SpawnedMobsContainer.add_child(mob)
			
			# set direction depending on setting
			match mob_direction:
				0:
					if int(rand_range(0,10)) > 5:
						mob.set_look_direction(Vector2(1.0,0))
					else:
						mob.set_look_direction(Vector2(-1.0,0))
				1:
					mob.set_look_direction(Vector2(mob_direction,0))
				-1:
					mob.set_look_direction(Vector2(mob_direction,0))
			
			mob_count += 1
			mob_count_living += 1

	_set_rand_spawn_timer()

func _on_mob_killed():
	mob_count_living -= 1
