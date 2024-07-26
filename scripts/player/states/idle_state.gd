extends State

class_name IdleState

var player : CharacterBody2D

func Enter():
	print("Player has entered IdleState")
	player = get_tree().get_first_node_in_group("Player")
	pass

func Exit():
	print("Player has exited IdleState")
	pass

func Update(_delta: float):
	if(Input.is_action_pressed("walk_left") or Input.is_action_just_pressed("walk_right")):
		emit_signal("Transitioned", self, "WalkState")
	if(Input.is_action_pressed("jump")):
		emit_signal("Transitioned",self , "JumpState")
	if(!player.is_on_floor()):
		emit_signal("Transitioned", self, "FallState")
	pass

func Physics_Update(_delta:float):
	pass
