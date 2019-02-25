extends Control

var _loot_count = 0
var _loot_name = ""

func set_notification(count, name):
	self._loot_count = count
	self._loot_name = name
	
	_update_labels()
	
func get_notification():
	return [int(_loot_count), _loot_name]
	
func clear_notification():
	set_notification(0, "")
	
func _update_labels():
	if not _loot_count == 0:
		get_node("HBoxContainer/loot_count").text = "+%d" % _loot_count
	else:
		get_node("HBoxContainer/loot_count").text = ""
		
	get_node("HBoxContainer/loot_name").text = _loot_name

func _ready():
	pass
