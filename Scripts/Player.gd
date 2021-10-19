extends "res://Scripts/Actor.gd"
onready var animated_sprite = $AnimatedSprite
onready var hitbox = $Hitbox

var velocity = Vector2.ZERO
var max_run = 200 # max left and right speed
var run_accel = 1200 # how fast you accelerate left and right
var gravity = 1500 # overall gravity modifier (both jump and fall)
var max_fall = 380 # fall speed
var jump_force = -240 # how high you jump
var jump_hold_time = 0.1 # how long you can hold jump to get extra height
var local_hold_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var on_ground = Game.check_walls_collision(self, Vector2.DOWN)
	
	var jumping = Input.is_action_pressed("ui_up")
	var crouching = Input.is_action_pressed("ui_down")

	if jumping && on_ground:
		velocity.y = jump_force
		local_hold_time = jump_hold_time
	elif local_hold_time > 0:
		if jumping:
			velocity.y = jump_force
		else:
			local_hold_time = 0
	
	local_hold_time -= delta
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	if crouching && on_ground:
		animated_sprite.play("crouch")
	elif direction != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	velocity.x = move_toward(velocity.x, max_run * direction, run_accel * delta)
	velocity.y = move_toward(velocity.y, max_fall, gravity * delta)
	
	move_x(velocity.x * delta, funcref(self, "on_collision_x"))
	move_y(velocity.y * delta, funcref(self, "on_collision_y"))
	
func on_collision_x():
	velocity.x = 0
	zero_remainder_x()

func on_collision_y():
	velocity.y = 0
	zero_remainder_y()
