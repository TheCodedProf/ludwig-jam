extends Node2D

var total_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_fullscreen = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().paused = true

func _process(delta):
	total_time += delta

func _on_win_area_entered(area):
	$GUI/EndScreen.win($Player.flaps, total_time)
	get_tree().paused = true
