extends State

class_name WalkState
var direction: Vector2
var Vel : Vector2
var player : CharacterBody2D
var speed : float
func Enter():
	print("Player has entered WalkState")
	player = get_tree().get_first_node_in_group("Player")
	Vel = player.velocity
	speed = 300.0
	pass

func Exit():
	pass

func Update(_delta: float):
	if(direction == Vector2.ZERO):
		emit_signal("Transitioned", self, "IdleState")
	
	if(Input.is_action_pressed("jump") and player.is_on_floor()):
		emit_signal("Transitioned", self, "JumpState")

func Physics_Update(_delta:float):
	direction = Input.get_vector("walk_left", "walk_right", "jump", "crouch")
	
	if(direction.x != 0):
		Vel.x = direction.x * speed 
	else:
		Vel.x = 0
	player.velocity.x = Vel.x
	
	player.move_and_slide()
