extends State

class_name JumpState

var player : CharacterBody2D
var Vel : Vector2
var jump_vel : float
var speed : float

func Enter():
	jump_vel = -1000.0
	print("Player has entered JumpState")
	player = get_tree().get_first_node_in_group("Player")
	Vel = player.velocity

func Exit():
	print("Player has exited IdleState")
	pass

func Update(_delta: float):
	if(!player.is_on_floor()):
		emit_signal("Transitioned", self, "FallState")
	

func Physics_Update(_delta:float):
	var direction = Input.get_vector("walk_left", "walk_right", "crouch", "jump")
	Vel.y += jump_vel
	if(direction.x != 0):
		Vel.x = direction.x * speed 
	else:
		Vel.x = 0
	
	player.velocity = Vel
	
	player.move_and_slide()
	

