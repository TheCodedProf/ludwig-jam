extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_fullscreen = true
	get_tree().paused = true
