extends CharacterBody2D

@export var GRAVITY:int = 1000
@export var JUMP_SPEED:int = -300
@export var SPEED:int = 300

enum state { IDLE, RUN, JUMP }
var current_state : state

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	current_state = state.IDLE

func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	player_animations()

func input_movement():
	var direction:float = Input.get_axis("move_left", "move_right")
	return direction

func player_animations():
	if current_state == state.IDLE:
		animated_sprite.play("idle")
	elif current_state == state.RUN:
		animated_sprite.play("run")
	elif current_state == state.JUMP:
		animated_sprite.play("jump")
	
func player_falling(delta:float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle(delta:float):
	if is_on_floor():
		current_state = state.IDLE

func player_jump(delta:float):
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED
		current_state = state.JUMP

	if !is_on_floor() and current_state == state.JUMP:
		var direction = input_movement()
		velocity.x += direction * 100 * delta

func player_run(delta:float):
	var direction = input_movement()
	
	if direction != 0:
		current_state = state.RUN
		animated_sprite.flip_h = false if direction > 0 else true

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
