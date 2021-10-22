extends Control

func _ready():
	visible = false

func win(flaps, time):
	$BG/Score.text = flaps
	$BG/Time.text = str(floor(time / 60)) + ":" + str((time%60))
	visible = true
