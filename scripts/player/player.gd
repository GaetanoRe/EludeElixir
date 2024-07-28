extends CharacterBody2D
class_name Player

@onready var transition = $SceneTransAnim/CanvasLayer/AnimationPlayer
@onready var transition_mask = $SceneTransAnim/CanvasLayer/ColorRect
@export var current_level : Node2D
@export var doses : int = 5
@export var max_doses : int = 5
@export var shadow : bool
@export var enveloped : bool
var timer : Timer
var gravity : float
var gravity_default : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed : float
var jumpVel : float = -500.0
var playerVel : Vector2 = Vector2.ZERO
var light_area : Area2D

signal doses_changed
signal countdown_start
signal countdown_end


# Called when the node enters the scene tree for the first time.
func _ready():
	enveloped = false
	shadow = false
	light_area = get_node("LightDetection")
	timer = get_node("Timer")



# If player is not shadow and has at least 1 dose when pressing E,
# they switch to shadow form for 15 seconds
func _process(delta):
	if Input.is_action_just_pressed("drink") and !shadow and !enveloped and doses >= 1:
		doses -= 1
		doses_changed.emit()
		shadow = true
		#emit_signal("doses_changed", doses)    <- Not needed? Already have doses_changed.emit() above
		print("player is now Shadow")
		countdown_start.emit()
		timer.start()
		await timer.timeout
		countdown_end.emit()
		shadow = false
		print("player is now Alchemist")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	playerVel = velocity

	if (!shadow):
		gravity = gravity_default
		speed = 300
	else:
		gravity = gravity_default / 2
		speed = 350

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
	
	elif(area.is_in_group("dark_area") && !shadow):
		print("Uh oh! You've been Enveloped!")
		enveloped = true
		transition.play("Enveloped")
		await get_tree().create_timer(4.5).timeout
		transition_mask.color.a = 255
		var next_scene = load("res://scenes/dungeon.tscn")
		get_tree().change_scene_to_packed(next_scene)


func _on_light_detection_area_exited(area):
	if(area.is_in_group("lights")):
		print("Character has exited the light")


# Use this function to deal with trap damage...
func _on_hurt_box_area_entered(area):
	if(area.is_in_group("traps")):
		print("I have hit the trap!")

