extends CharacterBody2D
class_name Player

@onready var transition = $SceneTransAnim/CanvasLayer/AnimationPlayer
@onready var animation = $AnimatedSprite2D
@onready var UI_anim = $UserInterface/Control/InGameUI/UI_AnimPlayer
@onready var dash_particles = $DashParticles
@onready var dash_time = $dash_time
@onready var dash_antispam = $dash_antispam


@export var current_level : Node2D
@export var doses : int = 5
@export var max_doses : int = 5
@export var shadow : bool
@export var enveloped : bool
@export var in_darkness : bool
@export var state : String
@export var near_alembic : bool = false

var timer : Timer
var gravity : float
var gravity_default : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var norm_speed : float
var speed : float
var jumpVel : float = -500.0
var playerVel : Vector2 = Vector2.ZERO
var light_area : Area2D

const dash_speed : float = 1500
var dashing = false
var can_dash = true


signal doses_changed
signal countdown_start
signal countdown_end
signal cooldown_start
signal cooldown_end


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = norm_speed
	transition.play("FadeIn")
	UI_anim.play("UI_Fade_In")
	animation.play("Alchemist_Idle")
	enveloped = false
	shadow = false
	dash_particles.emitting = false
	light_area = get_node("LightDetection")
	timer = get_node("Timer")
	state = "Alchemist"




func _process(delta):
	if in_darkness and !shadow:
		enveloped = true
		enveloped_reset()
	
	
	#   Handles Different Sprite Animations
	if(shadow):
		state = "Shadow"
	else:
		state = "Alchemist"
	if animation.get_animation() == "Alchemist_Drink":
		await get_tree().create_timer(1.6).timeout


	#   Enveloped Animations
	if(enveloped):
		if velocity.x < 0:
			animation.flip_h = true
		if velocity.x > 0:
			animation.flip_h = false
		
	
	#   Non-Enveloped Animations
	else:
		# Player Animations (The different states will assign a different string to the animations to 
		# prevent repeating code, depending on the state.)
		
		if Input.is_action_pressed("jump") and is_on_floor():
			animation.play(state + "_Jump")
	
		#   Mid-Air
		if !is_on_floor():
			if velocity.x != 0 and velocity.y < 0:
				animation.flip_h = velocity.x < 0
				var current_frame = animation.get_frame()
				var current_progress = animation.get_frame_progress()
				animation.play(state + "_Jump")
				animation.set_frame_and_progress(current_frame, current_progress)
			if velocity.x != 0 and velocity.y > 0:
				animation.flip_h = velocity.x < 0
				var current_frame = animation.get_frame()
				var current_progress = animation.get_frame_progress()
				animation.play(state + "_Fall")
				animation.set_frame_and_progress(current_frame, current_progress)
			if velocity == Vector2.ZERO:
				animation.play(state + "_Idle")
		
		#if Input.is_action_pressed("slide") and is_on_floor() and !shadow:
			#animation.play("Alchemist_Slide")
		
		#   Prevent weird behavior
		if velocity.x != 0 and is_on_floor():
			animation.flip_h = velocity.x < 0
			animation.play(state + "_Run")
		if velocity == Vector2.ZERO:
			animation.play(state + "_Idle")


#   Elude Elixir
func _input(event):
	if event.is_action_pressed("drink") and !shadow and !enveloped and doses >= 1:
		animation.play("Alchemist_Drink")
		if animation.is_playing():
			await get_tree().create_timer(1.6).timeout
			if !enveloped:
				animation.play("Shadow_Idle")
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
	
	if event.is_action_pressed("interact") and near_alembic:
		doses = 5
		UI_anim.play("UI_Fill_Elixir")
		print("Elixir refilled")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	playerVel = velocity

	if !dashing:
		if (!shadow):
			gravity = gravity_default
			speed = 300
		else:
			gravity = gravity_default / 2
			speed = 350

	if Input.is_action_just_pressed("slide") and shadow and can_dash:
		dashing = true
		dash_time.start()
		dash_antispam.start()
		cooldown_start.emit()
		#dash_particles.emitting = true if dash.is_dashing() else false
		if dashing:
			dash_particles.emitting = true
			speed = dash_speed
			can_dash = false
			dash_particles.emitting = true
			print("I am dashing")
	
	var direction = Input.get_vector("walk_left", "walk_right", "jump", "crouch")
	if(direction.x != 0):
		playerVel.x = direction.x * speed 
		dash_particles.gravity.x = -(int) (980 * direction.x)
	else:
		playerVel.x = 0
	if(Input.is_action_pressed("jump") and is_on_floor()):
		playerVel.y += jumpVel
	
	if(!is_on_floor()):
		if Input.is_action_just_pressed("slide") and shadow and can_dash:
			if Input.is_action_pressed("crouch"):
				playerVel.y += dash_speed
			else:
				playerVel.y -= dash_speed
		else:
			playerVel.y += gravity * delta

	velocity = playerVel
	move_and_slide()



func _on_light_detection_area_entered(area):
	if(area.is_in_group("lights")):
		print("Character is touching light")
	
	elif area.is_in_group("dark_area"):
		in_darkness = true


func _on_light_detection_area_exited(area):
	if(area.is_in_group("lights")):
		print("Character has exited the light")
	
	elif area.is_in_group("dark_area"):
		in_darkness = false



# Use this function to deal with trap damage...
func _on_hurt_box_area_entered(area):
	if(area.is_in_group("traps") and transition.current_animation != "Enveloped"):
		print("I have hit the trap!")
		enveloped = true
		UI_anim.play("UI_Enveloped")
		animation.play("Enveloped")
		transition.play("YOU_DIED")
		await get_tree().create_timer(4.5).timeout
		var next_scene = load("res://scenes/dungeon.tscn")
		get_tree().change_scene_to_packed(next_scene)



func enveloped_reset():
	if(transition.current_animation != "YOU DIED"):
		UI_anim.play("UI_Enveloped")
		animation.play("Enveloped")
		transition.play("Enveloped")
		await get_tree().create_timer(4.5).timeout
		var next_scene = load("res://scenes/dungeon.tscn")
		get_tree().change_scene_to_packed(next_scene)


func _on_alembic_detection_area_entered(area):
	near_alembic = true

func _on_alembic_detection_area_exited(area):
	near_alembic = false


func _on_dash_time_timeout():
	dashing = false
	dash_particles.emitting = false


func _on_dash_antispam_timeout():
	can_dash = true
	cooldown_end.emit()

