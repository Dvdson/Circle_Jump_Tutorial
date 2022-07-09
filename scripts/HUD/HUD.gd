extends CanvasLayer

var score = 0

func _ready():
	$Message.rect_pivot_offset = $Message.rect_size/2

func show_message(text:String):
	$Message.text = text
	$MessageAnimation.play("show_message")
	
func hide():
	$ScoreBox.hide()
	$BonusBox.hide()
func show():
	$ScoreBox.show()
	$BonusBox.show()	 

func update_score(score, value:int):
	$Tween.interpolate_property(self, "score", score, 
		value, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$ScoreAnimation.play("ScoreChange")
	
func update_bonus(value:int):
	$BonusBox/Bonus.text = str(value) + "x"
	if value > 1:
		$BonusAnimation.play("BonusChange")


func _on_Tween_tween_step(object, key, elapsed, value):
	$ScoreBox/HBoxContainer/Score.text = str(int(value))
