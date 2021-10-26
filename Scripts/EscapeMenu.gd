extends Control

func _ready():
	visible = false

func _on_Quit_pressed():
	get_tree().quit()

func _on_ReturnToMenu_pressed():
	$"../MainMenu".return_to_menu()
	visible = false

func _on_ReturnToGame_pressed():
	visible = false
	get_tree().paused = false
