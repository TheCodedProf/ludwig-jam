extends KinematicBody2D
onready var animated_sprite = $AnimatedSprite

var velocity = Vector2.ZERO # set velocity to o,o
var max_horizontal = 1250 # max left and right speed
var max_vertical = 750
var run_accel = 500 # how fast you accelerate left and right
var gravity = 1750 # overall gravity modifier (both jump and fall)
var max_fall = 500 # fall speed
var jumps = 3 # set current jumps
var can_fly = true
var starting_position = Vector2(16, -20.000816)
var stun_velocity = 0
var flaps = 0
var fly_force = 0
var direction_x
var direction_y
var is_hit_stun = false

func _ready():
	position = starting_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(position)
	var flying = Input.is_action_just_pressed("wing_flap")
	
	# grabs mouse position
	var mouse_position = get_global_mouse_position()
	var mouse_angle = get_angle_to(mouse_position)
	direction_x = sign(mouse_position.x - global_position.x)
	direction_y = sign(mouse_position.y - global_position.y)
	
	if is_on_floor():
		velocity.x *= .85
		jumps = 3
		gravity = 1750
		$"../GUI/HUD".update_jumps(jumps)
		animated_sprite.play("idle")
	elif velocity.y > 0:
		gravity += 10 * delta
	elif velocity.y < 0:
		gravity = 1750
		
	if !is_on_floor():
		# hitstuns the player for moving to fast into an object
		hit_stun(delta)
		
	# flying feels like giga shit lmao
	if flying && jumps != 0 && can_fly:
		flaps += 1
		jumps -= 1
		$"../GUI/HUD".update_jumps(jumps)
		velocity.x = cos(mouse_angle) * fly_force
		velocity.x = direction_x * min(abs(velocity.x), max_horizontal)
		velocity.y = sin(mouse_angle) * fly_force
		velocity.y = direction_y * min(abs(velocity.y), max_vertical)
		if velocity.y > -1500 && direction_y == -1:
			velocity.y = sin(mouse_angle) * fly_force
		animated_sprite.play("flight")

	# update velocity
	velocity.x = move_toward(velocity.x, 0, run_accel * delta)
	velocity.y = move_toward(velocity.y, max_fall, gravity * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP, false, 2)
	
	# TODO: add player animation
	$Arrow.rotation = mouse_angle + PI/2
	if direction_x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func create_fly_timer(delay):
	can_fly = false
	yield(get_tree().create_timer(delay), "timeout")
	can_fly = true
	
func kill():
	velocity = Vector2.ZERO
	position = starting_position

func _on_DeathBarrier_entered(body):
	kill()
	
# determins if its a hitstun or a ledge climb
#func wall_collision():
#	if ledge climb
#		climb ledge
#	else wall bounce
#	if hitstun
#		hitstun
	
# TODO: fix hitstun wall climb interaction
func hit_stun(delta):
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (abs(collision.remainder.x) > abs(stun_velocity) ||
			abs(collision.remainder.y) > abs(stun_velocity) &&
			!is_on_floor()):
				#velocity.x = -collision.remainder.x * 100
				#velocity.y = collision.remainder.y * 100
				is_hit_stun = true
				create_fly_timer(1.5)
				is_hit_stun = false
