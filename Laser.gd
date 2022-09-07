extends RigidBody2D

signal enemy_hit

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Laser_body_entered(body):
	emit_signal("enemy_hit")
	queue_free()
