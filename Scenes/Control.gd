extends Control

func _ready():
	visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		visible = get_tree().paused

func _on_Quit_pressed():
	get_tree().quit()

func _on_ReturnToMenu_pressed():
	$"../MainMenu".return_to_menu()
	visible = false

func _on_ReturnToGame_pressed():
	get_tree().paused = false
