extends Node2D

var total_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_fullscreen = true
	get_tree().paused = true

func _process(delta):
	total_time += delta

func win():
	$GUI/EndScreen.win($Player.flaps, total_time)
