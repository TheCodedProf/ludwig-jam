extends Control

func _ready():
	$Background/GameSelect.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("toggle fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _on_Quit_pressed():
	get_tree().quit()

func _on_StartGame_pressed():
	$Background/GameSelect.visible = !$Background/GameSelect.visible

# TODO: fix kill_velocity values
func _on_Otto_pressed():
	get_tree().paused = false
	$"../../Player".fly_force = 600 * 4
	$"../../Player".kill_velocity = 50
	$"../../Player".kill()
	self.visible = false

func _on_Ludwig_pressed():
	get_tree().paused = false
	$"../../Player".fly_force = 600 * 8
	$"../../Player".kill_velocity = 150
	$"../../Player".kill()
	self.visible = false

func return_to_menu():
	$Background/GameSelect.visible = false
	visible = true
