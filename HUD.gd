extends CanvasLayer

signal set_lives
signal set_score

func _on_HUD_set_lives(lives):
	var children = $Lives.get_children();
	for i in children.size():
		children[i].visible = lives > i


func _on_HUD_set_score(score):
	$Score.text = str(score)
