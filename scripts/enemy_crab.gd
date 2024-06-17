extends CharacterBody2D

@export var GRAVITY:int = 1000
@export var SPEED:int = 2000
@export var wait_time:int = 3
@export var PatrolPoints: Node

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer 

enum state { IDLE, WALK }
var current_state:state
var number_of_points:int
var point_positions:Array[Vector2]
var current_point:Vector2
var current_point_position:int
var direction:Vector2 = Vector2.LEFT
var can_walk:bool = false

func _ready():
	timer.wait_time = wait_time
	if PatrolPoints != null:
		number_of_points = PatrolPoints.get_children().size()
		for point in PatrolPoints.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No Patrol Points")

	current_state = state.IDLE

func _physics_process(delta):
	enemy_falling(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	enemy_animations()
	
	move_and_slide()

func enemy_falling(delta:float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func enemy_idle(delta:float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		current_state = state.IDLE

func enemy_walk(delta:float):
	if !can_walk:
		return

	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * SPEED * delta
		current_state = state.WALK
	else:
		current_point_position += 1
		if current_point_position >= number_of_points:
			current_point_position = 0

		current_point = point_positions[current_point_position]

		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
		can_walk = false
		timer.start()
	
	animated_sprite_2d.flip_h = direction.x > 0

func enemy_animations():
	if current_state == state.IDLE && !can_walk:
		animated_sprite_2d.play("idle")
	if current_state == state.WALK && can_walk:
		animated_sprite_2d.play("walk")

func _on_timer_timeout():
	can_walk = true
