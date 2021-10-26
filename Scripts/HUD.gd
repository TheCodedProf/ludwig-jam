extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_jumps(jumps):
	$"HBoxContainer/Bars/Bar/Count/Background/JumpNum".text = str(jumps)
