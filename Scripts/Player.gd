extends "res://Scripts/Actor.gd"
onready var animated_sprite = $AnimatedSprite
onready var hitbox = $Hitbox

var velocity = Vector2.ZERO # set velocity to o,o
var max_run = 800 # max left and right speed
var run_accel = 4800 # how fast you accelerate left and right
var gravity = 6000 # overall gravity modifier (both jump and fall)
var max_fall = 380 * 4# fall speed
var jump_force = -240 * 4 # how high you jump
var jump_hold_time = 0.1 # how long you can hold jump to get extra height
var fly_force = 600 * 4
var fly_hold_time = 0.1
var local_hold_time = 0
var cur_jumps = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var on_ground = Game.check_walls_collision(self, Vector2.DOWN)
	var flying = Input.is_action_just_pressed("wing_flap")
	
	# grabs mouse position
	var mouse_position = get_global_mouse_position()
	var mouse_angle = get_angle_to(mouse_position)
	var direction_x = sign(mouse_position.x - global_position.x)
	var _direction_y = sign(mouse_position.y - global_position.y)
	
	if on_ground:
		cur_jumps = 5
		$"../GUI/UI".update_jumps(cur_jumps)
		animated_sprite.play("idle")
	
	# flying feels like giga shit lmao
	if flying && cur_jumps != 0:
		cur_jumps -= 1
		$"../GUI/UI".update_jumps(cur_jumps)
		velocity.x = cos(mouse_angle) * fly_force
		velocity.y = sin(mouse_angle) * fly_force
		animated_sprite.play("flight")
	
	# update velocity
	velocity.x = move_toward(velocity.x, 0, run_accel * delta)
	velocity.y = move_toward(velocity.y, max_fall, gravity * delta)
	
	# move player & check for collisions
	move_x(velocity.x * delta, funcref(self, "on_collision_x"))
	move_y(velocity.y * delta, funcref(self, "on_collision_y"))
	
	# TODO: add player animation
	if direction_x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	
# collision functions
func on_collision_x():
	velocity.x = 0
	zero_remainder_x()

func on_collision_y():
	velocity.y = 0
	zero_remainder_y()
