extends KinematicBody2D
onready var animated_sprite = $AnimatedSprite
onready var wing_sprite = $AnimatedSprite2
onready var bonk_sound = $bonk_sound
onready var flap_sound = $flap_sound


var velocity = Vector2.ZERO # set velocity to o,o
var max_horizontal = 1250 # max left and right speed
var max_vertical = 750
var run_accel = 500 # how fast you accelerate left and right
var gravity = 1750 # overall gravity modifier (both jump and fall)
var max_fall = 500 # fall speed
var jumps = 3 # set current jumps
var starting_position = Vector2(1200*8, -240*8) #Vector2(16, -20.000816)
var stun_velocity = 0
var flaps = 0
var fly_force = 0
var direction_x
var direction_y
var is_hit_stun = false
var is_falling = false
var fly_timer
var fall_timer
var climb
var flap_pitch = 1
var max_jumps = 50

func _ready():
	position = starting_position
	fly_timer = Timer.new()
	fly_timer.set_one_shot(true)
	fly_timer.set_wait_time(1.5)
	fly_timer.connect("timeout", self, "on_fly_timeout_complete")

	fall_timer = Timer.new()
	fall_timer.set_one_shot(true)
	fall_timer.set_wait_time(60)
	fall_timer.connect("timeout", self, "")
	add_child(fly_timer)
	add_child(fall_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var flying = Input.is_action_just_pressed("wing_flap")
	
	# grabs mouse position
	var mouse_position = get_global_mouse_position()
	var mouse_angle = get_angle_to(mouse_position)
	direction_x = sign(mouse_position.x - global_position.x)
	direction_y = sign(mouse_position.y - global_position.y)
	
	if is_on_floor():
		velocity.x *= .85
		jumps = max_jumps
		gravity = 1750
		flap_pitch = 1
		fall_timer.start()
		$"../GUI/HUD".update_jumps(jumps)
		if !is_hit_stun:
			animated_sprite.play("idle")
			wing_sprite.play("idle")
		else:
			animated_sprite.play("floor_bonk")
			wing_sprite.play("idle")			
	elif velocity.y > 0:
		gravity += 100 * delta
	elif velocity.y < 0:
		gravity = 1750
		
	# flying feels like giga shit lmao
	if flying && jumps != 0 && !is_hit_stun:
		flaps += 1
		jumps -= 1
		$"../GUI/HUD".update_jumps(jumps)
		velocity.x = cos(mouse_angle) * fly_force
		velocity.x = direction_x * min(abs(velocity.x), max_horizontal)
		velocity.y = sin(mouse_angle) * fly_force
		velocity.y = direction_y * min(abs(velocity.y), max_vertical)
		if velocity.y > -1500 && direction_y == -1:
			velocity.y = sin(mouse_angle) * fly_force
		if !is_hit_stun && !is_falling:
			animated_sprite.play("flight")
			wing_sprite.play("flap")
		if flap_pitch == 1:
			flap_sound.pitch_scale = 1
		elif flap_pitch == 2:
			flap_sound.pitch_scale = 1.75
		elif flap_pitch == 3:
			flap_sound.pitch_scale = 2.5
		elif flap_pitch == 4:
			flap_sound.pitch_scale = 3.25
		else:
			flap_sound.pitch_scale = 4
		fall_timer.start()
		flap_sound.play()
		flap_pitch += 1

	wall_collision(delta)

	# update velocity
	velocity.x = move_toward(velocity.x, 0, run_accel * delta)
	velocity.y = move_toward(velocity.y, max_fall, gravity * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP, false, 2)
	
	if fall_timer.get_time_left() < 59:
		animated_sprite.play("fall")
		is_falling = true
	else:
		is_falling = false
	
	# TODO: add player animation
	$Arrow.rotation = mouse_angle + PI/2
	if direction_x < 0:
		animated_sprite.flip_h = true
		wing_sprite.flip_h = true
		if is_falling:
			wing_sprite.position = Vector2(12, 12)
			wing_sprite.z_index = -1
			wing_sprite.flip_v = true
		elif is_hit_stun && is_on_floor():
			wing_sprite.position = Vector2(12, 0)
			wing_sprite.z_index = -1
			wing_sprite.flip_v = false
		elif is_hit_stun:
			wing_sprite.position = Vector2(12, 2)
			wing_sprite.z_index = -1
			wing_sprite.flip_v = false
		elif !is_on_floor():
			wing_sprite.position = Vector2(12, -5)
			wing_sprite.z_index = 0
			wing_sprite.flip_v = false
		else:
			wing_sprite.position = Vector2(12, 0)
			wing_sprite.z_index = -1
			wing_sprite.flip_v = false
		$up.cast_to = Vector2(-11, 0)
		$dw.cast_to = Vector2(-11, 0)
	else:
		animated_sprite.flip_h = false
		wing_sprite.flip_h = false
		if is_falling:
			wing_sprite.position = Vector2(-12, 12)
			wing_sprite.z_index = -1
			wing_sprite.flip_v = true
		elif is_hit_stun && is_on_floor():
			wing_sprite.position = Vector2(-12, 0)
			wing_sprite.z_index = -1
			wing_sprite.flip_v = false
		elif is_hit_stun:
			wing_sprite.position = Vector2(-12, 2)
			wing_sprite.z_index = -1
			wing_sprite.flip_v = false
		elif !is_on_floor():
			wing_sprite.position = Vector2(-12, -5)
			wing_sprite.z_index = 0
			wing_sprite.flip_v = false
		else:
			wing_sprite.position = Vector2(-12, 0)
			wing_sprite.z_index = -1
			wing_sprite.flip_v = false
		$up.cast_to = Vector2(11, 0)
		$dw.cast_to = Vector2(11, 0)	

func on_fly_timeout_complete():
	is_hit_stun = false
	
func kill():
	$Camera2D.smoothing_enabled = false
	max_jumps = 3
	velocity = Vector2.ZERO
	position = starting_position
	yield(get_tree().create_timer(1.0), "timeout")
	$Camera2D.smoothing_enabled = true

func _on_DeathBarrier_entered(body):
	kill()
		
# TODO: fix hitstun wall climb interactio
func wall_collision(delta):
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if $up.is_colliding() == false && $dw.is_colliding() == true && !is_on_floor():
			velocity.x = collision.remainder.x * 55
		elif (abs(collision.remainder.x) > abs(stun_velocity) ||
			abs(collision.remainder.y) > abs(stun_velocity) &&
			!is_on_floor()):
				velocity.x = -collision.remainder.x * 25
				velocity.y = collision.remainder.y * 25
				animated_sprite.play("bonk")
				bonk_sound.play()
				is_hit_stun = true
				fly_timer.start()

func _on_5J_body_entered(body):
	max_jumps = 5


func _on_Finish_body_entered(body):
	$"../GUI/EndScreen".visible = true
