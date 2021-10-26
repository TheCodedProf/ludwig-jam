extends Camera2D
var velocity

func _ready():
	pass

func _process(delta):
	velocity = get_node("../").velocity
	print(velocity)
	if velocity == Vector2.ZERO:
		set_modulate(lerp(get_modulate(), Color(0,0,0,1), 3))
	else:
		set_modulate(lerp(get_modulate(), Color(0,0,0,0), 3))
