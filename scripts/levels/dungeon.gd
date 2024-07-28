extends Node2D
class_name Dungeon


# Called when the node enters the scene tree for the first time.

func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		SoundFx.button_click()
		var next_scene = load("res://scenes/dungeon.tscn")
		get_tree().change_scene_to_packed(next_scene)
