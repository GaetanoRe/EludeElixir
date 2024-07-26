extends State
class_name GlideState

var player: CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var shadow_gravity = ProjectSettings.get_setting("physics/2d/default_gravity") - 300
@export var speed : float = 300.0
@export var shadow_speed : float = 350.0
@export var jumpVel : float = -500.0
@export var Vel : Vector2 = Vector2.ZERO



func Enter():
	player = get_tree().get_first_node_in_group("Player")


func Update(_delta: float):
	if Input.is_action_just_pressed("jump") and player.is_on_floor() == false:
		Transitioned.emit(self,"JumpState")
	if player.velocity.y > 0:
		Transitioned.emit(self,"FallState")
	if player.velocity.x == 0 and player.velocity.y == 0:
		Transitioned.emit(self,"IdleState")
	if player.velocity.x != 0 and player.velocity.y == 0 and player.is_on_floor():
		Transitioned.emit(self,"WalkState")


func Physics_Update(delta: float):
	Vel = player.velocity
	
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
