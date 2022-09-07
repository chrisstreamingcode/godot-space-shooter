extends Node


func _on_StartScreen_start_game():
	$StartScreen.visible = false
	$GameOverScreen.visible = false
	$Game.visible = true
	$Game.emit_signal("new_game")


func _on_GameOverScreen_play_again():
	$StartScreen.visible = true
	$Game.visible = false
	$GameOverScreen.visible = false
	

func _on_Game_game_over(score):
	$StartScreen.visible = false
	$Game.visible = false
	$GameOverScreen.visible = true
	$GameOverScreen.emit_signal("game_over", score)
