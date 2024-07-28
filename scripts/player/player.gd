extends CharacterBody2D
class_name Player

@onready var transition = $SceneTransAnim/CanvasLayer/AnimationPlayer
@onready var animation = $AnimatedSprite2D
@onready var UI_anim = $UserInterface/Control/InGameUI/UI_AnimPlayer
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
	UI_anim.play("UI_Fade_In")
	transition.play("FadeIn")
	animation.play("Alchemist_Idle")
	



# If player is not shadow and has at least 1 dose when pressing E,
# they switch to shadow form for 15 seconds
func _process(delta):
	
	#   Elude Elixir
	if Input.is_action_just_pressed("drink") and !shadow and !enveloped and doses >= 1:
		doses -= 1
		doses_changed.emit()
		shadow = true
		animation.play("Shadow_Idle")
		#emit_signal("doses_changed", doses)    <- Not needed? Already have doses_changed.emit() above
		print("player is now Shadow")
		countdown_start.emit()
		timer.start()
		await timer.timeout
		countdown_end.emit()
		shadow = false
		print("player is now Alchemist")




	#   Alchemist Animations
	if Input.is_action_pressed("jump") and is_on_floor() and !enveloped and !shadow:
		animation.play("Alchemist_Jump")
	
	#   Mid-Air - Alchemist
	if !is_on_floor() and !enveloped and !shadow:
		if velocity.x > 0 and velocity.y < 0:
			animation.flip_h = false
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Alchemist_Jump")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x < 0 and velocity.y < 0:
			animation.flip_h = true
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Alchemist_Jump")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x > 0 and velocity.y > 0:
			animation.flip_h = false
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Alchemist_Fall")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x < 0 and velocity.y > 0:
			animation.flip_h = true
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Alchemist_Fall")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x == 0 and velocity.y == 0:
			animation.play("Alchemist_Idle")
	
	#if Input.is_action_just_pressed("slide") and is_on_floor() and !enveloped and !shadow:
		#animation.play("Alchemist_Slide")
	
	#   Prevent weird behavior - Alchemist
	if !Input.is_action_pressed("jump") and velocity.x > 0 and velocity.y == 0 and is_on_floor() and !enveloped and !shadow:
		animation.flip_h = false
		animation.play("Alchemist_Run")
	if !Input.is_action_pressed("jump") and velocity.x < 0 and velocity.y == 0 and is_on_floor() and !enveloped and !shadow:
		animation.flip_h = true
		animation.play("Alchemist_Run")
	if !Input.is_action_pressed("jump") and velocity.x == 0 and velocity.y == 0 and !enveloped and !shadow:
		animation.play("Alchemist_Idle")




	#   Shadow Animations
	if Input.is_action_pressed("jump") and is_on_floor() and shadow == true:
		animation.play("Shadow_Jump")
		
	#   Mid-Air - Shadow
	if !is_on_floor() and shadow == true:
		if velocity.x > 0 and velocity.y < 0:
			animation.flip_h = false
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Shadow_Jump")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x < 0 and velocity.y < 0:
			animation.flip_h = true
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Shadow_Jump")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x > 0 and velocity.y > 0:
			animation.flip_h = false
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Shadow_Fall")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x < 0 and velocity.y > 0:
			animation.flip_h = true
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Shadow_Fall")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x == 0 and velocity.y == 0:
			animation.play("Shadow_Idle")
	
	# While loop might break game. Try using a Timer instead
	# Include condition to not reset to 0 if timer is already running
	#while Input.is_action_pressed("jump") and !is_on_floor():
		#animation.play("Shadow_Glide")
	
	#   Prevent weird behavior - Shadow
	if !Input.is_action_pressed("jump") and velocity.x > 0 and velocity.y == 0 and is_on_floor() and shadow == true:
		animation.flip_h = false
		animation.play("Shadow_Run")
	if !Input.is_action_pressed("jump") and velocity.x < 0 and velocity.y == 0 and is_on_floor() and shadow == true:
		animation.flip_h = true
		animation.play("Shadow_Run")
	if !Input.is_action_pressed("jump") and velocity.x == 0 and velocity.y == 0 and shadow == true:
		animation.play("Shadow_Idle")




	#   Enveloped Animations
	if Input.is_action_pressed("jump") and is_on_floor() and enveloped == true:
		animation.play("Enveloped_Idle")
	
	#   Mid-Air - Enveloped
	if !is_on_floor() and enveloped == true:
		if velocity.x > 0:
			animation.flip_h = false
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Enveloped_Run")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x < 0:
			animation.flip_h = true
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Enveloped_Run")
			animation.set_frame_and_progress(current_frame, current_progress)
		if velocity.x == 0:
			var current_frame = animation.get_frame()
			var current_progress = animation.get_frame_progress()
			animation.play("Enveloped_Idle")
			animation.set_frame_and_progress(current_frame, current_progress)
	
	#   Prevent weird behavior - Enveloped
	if !Input.is_action_pressed("jump") and velocity.x > 0 and is_on_floor() and enveloped == true:
		animation.flip_h = false
		animation.play("Enveloped_Run")
	if !Input.is_action_pressed("jump") and velocity.x < 0 and is_on_floor() and enveloped == true:
		animation.flip_h = true
		animation.play("Enveloped_Run")
	if !Input.is_action_pressed("jump") and velocity.x == 0 and enveloped == true:
		animation.play("Enveloped_Idle")







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
		UI_anim.play("UI_Enveloped")
		animation.play("Enveloped_Run")
		transition.play("Enveloped")
		await get_tree().create_timer(4.5).timeout
		var next_scene = load("res://scenes/dungeon.tscn")
		get_tree().change_scene_to_packed(next_scene)


func _on_light_detection_area_exited(area):
	if(area.is_in_group("lights")):
		print("Character has exited the light")


# Use this function to deal with trap damage...
func _on_hurt_box_area_entered(area):
	if(area.is_in_group("traps")):
		print("I have hit the trap!")

