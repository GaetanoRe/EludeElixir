extends State
class_name ShadowIdle

var player: CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") - 300
@export var speed : float = 350.0
@export var jumpVel : float = -500.0
@export var Vel : Vector2 = Vector2.ZERO



func Enter():
	player = get_tree().get_first_node_in_group("Player")


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
	
	
	#example call for State change
	#if direction.Input.get_vector("walk_left") == true:
		#Transitioned.emit(self,"AlchemistLeft")
