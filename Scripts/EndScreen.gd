extends Control

func _ready():
	visible = false

func win(flaps, time):
	$BG/Score.text = str(flaps)
	$BG/Time.text = str(floor(time / 60)) + ":" + str((int(time)%60))
	visible = true
