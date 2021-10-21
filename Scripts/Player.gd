extends KinematicBody2D
onready var animated_sprite = $AnimatedSprite

var velocity = Vector2.ZERO # set velocity to o,o
var max_run = 800 # max left and right speed
var run_accel = 3800 # how fast you accelerate left and right
var gravity = 5000 # overall gravity modifier (both jump and fall)
var max_fall = 6000 # fall speed
var jumps = 3
var fly_force
var can_fly = true
var starting_position = Vector2(1224, 886)

func _ready():
	position = starting_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var flying = Input.is_action_just_pressed("wing_flap")
	
	# grabs mouse position
	var mouse_position = get_global_mouse_position()
	var mouse_angle = get_angle_to(mouse_position)
	var direction_x = sign(mouse_position.x - global_position.x)
	var _direction_y = sign(mouse_position.y - global_position.y)
	
	if is_on_floor():
		jumps = 3
		gravity = 5000
		$"../GUI/HUD".update_jumps(jumps)
		animated_sprite.play("idle")
	elif velocity.y > 0:
		gravity += 10
		
	# flying feels like giga shit lmao
	if flying && jumps != 0 && can_fly:
		jumps -= 1
		$"../GUI/HUD".update_jumps(jumps)
		velocity.x = cos(mouse_angle) * fly_force
		velocity.y = sin(mouse_angle) * fly_force
		can_fly = false
		create_fly_timer(delta)
		animated_sprite.play("flight")
	
	# update velocity
	velocity.x = move_toward(velocity.x, 0, run_accel * delta)
	velocity.y = move_toward(velocity.y, max_fall, gravity * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP, false, 2)
	
	# TODO: add player animation
	if direction_x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func create_fly_timer(delta):
	yield(get_tree().create_timer(.35), "timeout")
	can_fly = true

func kill():
	position = starting_position
