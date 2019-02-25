extends Area2D

func _ready():
	$anim.play("flicker")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_anim_animation_finished(anim_name):
	$anim.play("flicker")
