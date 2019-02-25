extends Control

const _MAX_NOTIFIERS = 3

var current_notifier = -1

func add_notification(count, name):
	current_notifier += 1

	if current_notifier < _MAX_NOTIFIERS:
		get_notifier(current_notifier).set_notification(count, name)
	else:
		current_notifier = _MAX_NOTIFIERS-1
		push_down()
		current_notifier = _MAX_NOTIFIERS-1
		get_notifier(current_notifier).set_notification(count, name)
		
	$timer_visible.start()

func get_notifier(i):
	return get_node("VBoxContainer/loot_notifier_%d" % i)
	
func clear():
	for i in range(_MAX_NOTIFIERS):
		get_notifier(i).clear_notification()
	current_notifier = -1

func push_down():
	print(current_notifier)
	var ret
	
	if current_notifier > -1:
		for i in range(_MAX_NOTIFIERS-1):
			ret = get_notifier(i+1).get_notification()
			get_notifier(i+1).clear_notification()
			get_notifier(i).set_notification(ret[0], ret[1])
				
		current_notifier -= 1

func _ready():
	clear()

func _on_timer_visible_timeout():
	if current_notifier > -1:
		push_down()
		$timer_visible.start()
