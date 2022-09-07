extends CanvasLayer

signal start_game


func _on_StartGameButton_pressed():
	emit_signal("start_game")
