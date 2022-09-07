extends Area2D


func _on_Health_area_entered(area):
	queue_free()
