extends Area2D

func _on_Battery_area_entered(area):
	queue_free()
