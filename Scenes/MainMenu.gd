extends Control

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("toggle fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _on_Quit_pressed():
	get_tree().quit()

func _on_StartGame_pressed():
	$Background/GameSelect.visible = !$Background/GameSelect.visible

func _on_Otto_pressed():
	get_tree().paused = false
	$"../../Player".fly_force = 600 * 4
	self.visible = false

func _on_Ludwig_pressed():
	get_tree().paused = false
	$"../../Player".fly_force = 600 * 8
	self.visible = false
