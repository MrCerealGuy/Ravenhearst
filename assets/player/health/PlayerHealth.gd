extends Node

signal health_changed
signal health_depleted
signal player_killed
signal status_changed

var _health = 0
var _max_health = playerstats.MAX_HEALTH

var _invincible = false

var _status = null

func get_health():
	return _health

func take_damage(amount):
	if _invincible:
		return
	
	_health -= amount
	_health = max(0, _health)
	
	$player_pain.play()
	
	match _health:
		0:
			_change_status(playerstats.HEALTH_STATE_KILLED)
		1:
			_change_status(playerstats.HEALTH_STATE_DEPLETED)
	
	# wait some time for next damage
	_invincible = true
	$player_invincible_timer.start()
	
	emit_signal("health_changed", _health)
	
func heal(amount):
	_health += amount
	_health = max(_health, _max_health)
	
	emit_signal("health_changed", _health)	

func _ready():
	_health = _max_health
	_status = playerstats.HEALTH_STATE_OK

func _change_status(new_status):
	match _status:
		playerstats.HEALTH_STATE_OK:
			pass
		
	match new_status:
		playerstats.HEALTH_STATE_DEPLETED:
			$player_heavilyinjured.play()
			
			emit_signal("health_depleted", _health)

		playerstats.HEALTH_STATE_KILLED:
			$player_death.play()
			
			emit_signal("player_killed")
	
	_status = new_status
	emit_signal('status_changed', new_status)

func _on_player_neardeath_timer_timeout():
	$player_heavilyinjured.play()

func _on_player_heavilyinjured_finished():
	if _health == 1:
		$player_heavilyinjured.play()

func _on_player_invincible_timer_timeout():
	_invincible = false
