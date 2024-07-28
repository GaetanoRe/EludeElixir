extends Node2D
class_name Dungeon

@onready var transition = $SceneTransAnim/CanvasLayer/AnimationPlayer
@onready var transition_mask = $SceneTransAnim/CanvasLayer/ColorRect
# Called when the node enters the scene tree for the first time.
func _ready():
	transition_mask.color.a = 255
	transition.play("FadeIn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		SoundFx.button_click()
		var next_scene = load("res://scenes/dungeon.tscn")
		get_tree().change_scene_to_packed(next_scene)
