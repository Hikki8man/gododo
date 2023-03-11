extends CharacterBody2D

@export var DASH_TIME = 10
@export var DASH_SPEED = 10
@export var DASH_COST = 80
@export var BASE_SPEED = 300
@export var SPRINT_SPEED = 500.0
@export var BASE_STAMINA = 200
@export var friction = 0.15
@export var acceleration = 0.2
@export var speed = 300

var dashing = 0
var stamina = 200

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('ui_right'):
		input.x += 1
	if Input.is_action_pressed('ui_left'):
		input.x -= 1
	if Input.is_action_pressed('ui_down'):
		input.y += 1
	if Input.is_action_pressed('ui_up'):
		input.y -= 1
	return input


func _input(event):
	if Input.is_key_pressed(KEY_A) && dashing <= 0 && stamina > DASH_COST:
		dashing = 1
		stamina -= DASH_COST


func _physics_process(delta):
	var direction = get_input()
	var sprint_pressed = false
	speed = BASE_SPEED
	if Input.is_key_pressed(KEY_SHIFT):
		sprint_pressed = true
	if sprint_pressed && direction.length() && stamina > 0:
		speed += SPRINT_SPEED
		stamina -= 1
	elif !sprint_pressed && stamina < BASE_STAMINA:
		stamina += 1
	
	if direction.length() > 0:
		if dashing > 0:
			velocity = velocity.lerp(direction.normalized() * speed * 5, acceleration * DASH_SPEED)
		else:
			velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

	dashing -= delta * DASH_TIME
	print_debug("stamina: ", stamina)
	var label = get_node("Stamina")
	label.text = "Stamina: " + str(stamina)
	move_and_slide()
