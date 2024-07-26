extends State
class_name FallState

var player: CharacterBody2D
@export var gravity : float
@export var speed : float = 300.0
@export var shadow_speed : float = 350.0
@export var jumpVel : float = -500.0
@export var Vel : Vector2 = Vector2.ZERO



func Enter():
	player = get_tree().get_first_node_in_group("Player")


func Update(_delta: float):
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		Transitioned.emit(self,"JumpState")
	if Input.is_action_just_pressed("jump") and !player.is_on_floor():
		Transitioned.emit(self,"GlideState")
	# While loop might break game. Try using a Timer instead
	# Include condition to not reset to 0 if timer is already running
	#while Input.is_action_pressed("jump") and !player.is_on_floor():
		#Transitioned.emit(self,"GlideState")
	if player.velocity.x == 0 and player.velocity.y == 0:
		Transitioned.emit(self,"IdleState")
	if player.velocity.x != 0 and player.velocity.y == 0 and player.is_on_floor():
		Transitioned.emit(self,"WalkState")


func Physics_Update(delta: float):
	Vel = player.velocity
	
	if player.shadow == false:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	else:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity") - 300
	
	var direction = Input.get_vector("walk_left", "walk_right", "jump", "crouch")
	if(direction.x != 0):
		Vel.x = direction.x * speed 
	else:
		Vel.x = 0
	if(Input.is_action_pressed("jump") and player.is_on_floor()):
		Vel.y += jumpVel
	
	if(!player.is_on_floor()):
		Vel.y += gravity * delta
	
	
	player.velocity = Vel
	player.move_and_slide()
