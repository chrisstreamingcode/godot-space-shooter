extends CanvasLayer

signal play_again
signal game_over

func _on_Button_pressed():
	emit_signal("play_again")


func _on_GameOverScreen_game_over(score):
	$FinalScore.text = str("Final Score: ", score)
