extends Sprite
onready var TweenNode = get_node("../Tween")
onready var velocity
var _modulate_target:Color

func _tween_modulate(target:Color, duration:float, delay:float) -> void:
	if _modulate_target == target:
		return

	_modulate_target = target
	TweenNode.remove(self, "modulate")
	TweenNode.follow_property(
		self,
		"modulate",
		modulate,
		self,
		"_modulate_target",
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN,
		delay
	)
	TweenNode.start()

func _ready():
	visible = true
	modulate.a = 0
	_modulate_target = modulate

func _process(delta):
	velocity = get_node("../../").velocity
	
	if(modulate == Color(0,0,0,1)):
		get_parent().get_parent().kill()
		modulate = Color(0,0,0,0)
	
	if (velocity == Vector2.ZERO || $"../../".is_hit_stun) && $"../../".position != $"../../".starting_position:
		_tween_modulate(Color(0,0,0,1), 3, 2)
	else:
		_tween_modulate(Color(0,0,0,0), .1, 0)
