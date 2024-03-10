extends CharacterBody2D

var player_sprite:AnimatedSprite2D
var initial_sprite_scale:Vector2

@export var movement_speed:int = 1500
@export var gravity:int = 70
@export var jump_strength:int = 2600


func _ready():
	player_sprite = $AnimatedSprite2D
	initial_sprite_scale = player_sprite.scale
	

func _physics_process(delta):
	var horizontal_input = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	velocity.x = horizontal_input * movement_speed
	velocity.y += gravity
	
	if not is_zero_approx(horizontal_input):
		if horizontal_input < 0:
			player_sprite.scale = Vector2(-initial_sprite_scale.x, initial_sprite_scale.y)
		else:
			player_sprite.scale = initial_sprite_scale
			
	var is_falling = velocity.y > 0.0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0.0
	var is_idle = is_on_floor() and is_zero_approx(velocity.x)
	var is_walking = is_on_floor() and not is_zero_approx(velocity.x) 
			
	if is_jumping:
		velocity.y = -jump_strength
		
	move_and_slide()
	
	if is_jumping:
		player_sprite.play("jump_start")
	elif is_walking:
		player_sprite.play("walk")
	elif is_idle:
		player_sprite.play("idle")
	elif is_falling:
		player_sprite.play("fall")
			
		
