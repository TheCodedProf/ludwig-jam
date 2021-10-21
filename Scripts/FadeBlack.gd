extends Sprite
onready var TweenNode = get_node("../Tween")
onready var velocity

func _ready():
	modulate.a = 0

func _process(delta):
	velocity = get_node("../../").velocity
	if velocity == Vector2.ZERO:
		TweenNode.interpolate_property(self, "modulate", modulate, Color(0, 0, 0, 1), 5, Tween.TRANS_EXPO, Tween.EASE_OUT_IN, 2)
	else:
		TweenNode.interpolate_property(self, "modulate", modulate, Color(0, 0, 0, 0), .1, Tween.TRANS_EXPO, Tween.EASE_OUT_IN)
	if !TweenNode.is_active():
		TweenNode.start()

