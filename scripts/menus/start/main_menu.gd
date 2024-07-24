extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_start_game_button_pressed():
	var next_scene = load("res://scenes/main.tscn")
	get_tree().change_scene_to_packed(next_scene)
	



func _on_quit_button_pressed():
	get_tree().quit()
	
func _on_settings_button_pressed():
	$SFX_click.play()
	var next_scene = load("res://scenes/settings.tscn")
	get_tree().change_scene_to_packed(next_scene)




