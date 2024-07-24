extends CharacterBody2D
class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed : float = 300.0
var jumpVel : float = -500.0
var playerVel : Vector2 = Vector2.ZERO
var light_area : Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	light_area = get_node("LightDetection")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	playerVel = velocity
	
	var direction = Input.get_vector("walk_left", "walk_right", "jump", "crouch")
	if(direction.x != 0):
		playerVel.x = direction.x * speed 
	else:
		playerVel.x = 0
	if(Input.is_action_pressed("jump") and is_on_floor()):
		playerVel.y += jumpVel
	
	if(!is_on_floor()):
		playerVel.y += gravity * delta
	
	
	velocity = playerVel
	move_and_slide()



func _on_light_detection_area_entered(area):
	if(area.is_in_group("lights")):
		print("Character is touching light")


func _on_light_detection_area_exited(area):
	if(area.is_in_group("lights")):
		print("Character has exited the light")
