extends CanvasLayer

func _ready():
	pass

func _process(delta):
	if !$MainMenu.visible:
		if Input.is_action_just_pressed("pause"):
			get_tree().paused = true
			$EscapeMenu.visible = get_tree().paused
