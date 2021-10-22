extends Control

func _ready():
	$Background/GameSelect.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("toggle fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _on_Quit_pressed():
	get_tree().quit()

func _on_StartGame_pressed():
	$"../../Player".position = $"../../Player".starting_position
	$Background/GameSelect.visible = !$Background/GameSelect.visible

# TODO: fix kill_velocity values, tune stun velocity
func _on_Otto_pressed():
	get_tree().paused = false
	$"../../Player".fly_force = 2000
	$"../../Player".stun_velocity = 20
	self.visible = false

func _on_Ludwig_pressed():
	get_tree().paused = false
	$"../../Player".fly_force = 4500
	$"../../Player".stun_velocity = 150
	self.visible = false

func return_to_menu():
	$Background/GameSelect.visible = false
	visible = true
