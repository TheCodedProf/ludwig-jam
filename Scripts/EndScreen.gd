extends Control

func _ready():
	visible = false

func win(flaps, time):
	$BG/Content.text = "You completed the game in %02d:%02d with %d flaps" % [floor(time / 60), int(time)%60, flaps]
	visible = true

func _on_MenuReturn_pressed():
	$"../MainMenu".return_to_menu()
	visible = false
