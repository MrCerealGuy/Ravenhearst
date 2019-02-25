extends Area2D

var in_use = false

onready var detect_hit_left = $detect_hit_left
onready var detect_hit_right = $detect_hit_right

func use_item(player):
	var collider
	var detect_hit
	
	if in_use == true:
		return false
		
	in_use = true
	$timer_mining.start()
	
	if $sprite.scale.x > 0:
		detect_hit = detect_hit_right
	else:
		detect_hit = detect_hit_left
	
	if detect_hit.is_colliding():
		collider = detect_hit.get_collider()

		if collider.has_method("hit"):
			collider.hit(player, self)

			$sound_mining.play()

func _ready():
	add_to_group("player_wielditem")

func _process(delta):
	pass

func _on_timer_mining_timeout():
	in_use = false
