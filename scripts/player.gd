extends CharacterBody2D

const GRAVITY = 1000
const SPEED = 300

var current_state

enum state { IDLE, RUN }

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	current_state = state.IDLE

func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	
	move_and_slide()
	player_animations()

func player_animations():
	if current_state == state.IDLE:
		animated_sprite.play("idle")
	elif  current_state == state.RUN:
		animated_sprite.play("run")
	
func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle(delta):
	if is_on_floor():
		current_state = state.IDLE

func player_run(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		current_state = state.RUN
		animated_sprite.flip_h = false if direction > 0 else true

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
