extends Node2D
onready var hitbox = $Hitbox

func _ready():
	add_to_group("Walls")
