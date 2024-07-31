extends Node2D
class_name Dungeon


@onready var transition = $SceneTransAnim/CanvasLayer/AnimationPlayer

# Called when the node enters the scene tree for the first time.

func _ready():
	SoundFx.play_dungeon_music()
	SoundFx.fade_in_dung_music()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		SoundFx.button_click()
		SoundFx.fade_out_dung_music()
		transition.play("FadeOut")
		await get_tree().create_timer(1).timeout
		SoundFx.play_menu_music()
		SoundFx.fade_in_menu_music()
		await get_tree().create_timer(1).timeout
		var next_scene = load("res://scenes/main_menu.tscn")
		get_tree().change_scene_to_packed(next_scene)

