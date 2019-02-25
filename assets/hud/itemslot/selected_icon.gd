extends TextureRect

enum {STATE_NORMAL, STATE_BLINK}

var _state = STATE_NORMAL

func set_visible(b=true):
	visible = b
	
	if not b and _state == STATE_BLINK:
		_state = STATE_NORMAL

func set_blink(b=true):
	if b:
		_state = STATE_BLINK
		$timer_blink_selection.start()
	else:
		_state = STATE_NORMAL
		visible = true
		
func _ready():
	pass

func _on_timer_blink_selection_timeout():
	if _state == STATE_BLINK:
		if visible:
			visible = false
		else:
			visible = true
			
		$timer_blink_selection.start()
