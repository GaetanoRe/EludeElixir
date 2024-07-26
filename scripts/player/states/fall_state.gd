extends State


class_name FallState

var player : CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var Vel : Vector2
var speed : float

func Enter():
	print("Player has entered FallState")
	speed = 300.0
	player = get_tree().get_first_node_in_group("Player")
	Vel = player.velocity
	if(player.is_shadow()):
		gravity = gravity / 2
	

func Exit():
	print("Player has exited FallState")
	pass

func Update(_delta: float):
	if(player.is_on_floor()):
		emit_signal("Transitioned", self, "IdleState")

func Physics_Update(_delta:float):
	var direction = Input.get_vector("walk_left", "walk_right", "crouch", "jump")
	Vel.y = gravity * _delta
	
	if(direction.x != 0):
		Vel.x = direction.x * speed 
	else:
		Vel.x = 0
	player.velocity = Vel
	
	player.move_and_slide()
	
	
