extends Control


@onready var transition = $SceneTransAnim/CanvasLayer/AnimationPlayer
@onready var transition_mask = $SceneTransAnim/CanvasLayer/ColorRect
var volume_db = [-80, -30, -23, -16, -12, -9, -8, -6, -5, -4.3, -2.8, -1.6, -1, -0.5, 0]
var bus_Music: int
var bus_SFX: int
var Musictab: int
var SFXtab: int

# Called when the node enters the scene tree for the first time.
func _ready():
	transition.play("RESET")
	bus_Music = AudioServer.get_bus_index("Music")
	bus_SFX = AudioServer.get_bus_index("SoundEffects")
	var saved_data := load("res://scripts/resources/savedata.tres") as SaveGame
	if saved_data != null:
		Musictab = saved_data.saved_Musictab
		SFXtab = saved_data.saved_SFXtab
	AudioServer.set_bus_volume_db(bus_Music, volume_db[Musictab])
	AudioServer.set_bus_volume_db(bus_SFX, volume_db[SFXtab])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_start_game_button_pressed():
	SoundFx.button_click()
	transition_mask.color.a = 0
	transition.play("FadeOut")
	await get_tree().create_timer(1).timeout
	var next_scene = load("res://scenes/dungeon.tscn")
	get_tree().change_scene_to_packed(next_scene)



func _on_settings_button_pressed():
	SoundFx.button_click()
	var next_scene = load("res://scenes/settings_menu.tscn")
	get_tree().change_scene_to_packed(next_scene)



func _on_quit_button_pressed():
	get_tree().quit()

