extends RigidBody2D

func _on_shotgun_bullet_body_entered(body):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
	queue_free()
