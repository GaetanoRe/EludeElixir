extends Control

var bus_Music: int
var bus_SFX: int
var tab_db: float
var tab_linear: int
var mute = -60

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_Music = AudioServer.get_bus_index("Music")
	bus_SFX = AudioServer.get_bus_index("SoundEffects")



# Change Music volume when selected
func _on_volume__music_tab_selected(tab):
	if tab == 0:
		AudioServer.set_bus_volume_db(bus_Music, mute)
		print(tab)
		print(AudioServer.get_bus_volume_db(bus_Music))

	else: 
		tab_db = -20 * ( log(11-tab) / log(10))
		AudioServer.set_bus_volume_db(bus_Music,tab_db)
		print(tab)
		print(tab_db)
		print(AudioServer.get_bus_volume_db(bus_Music))
	
	
	

# Change Sound Effects volume when selected
func _on_volume__sound_effects_tab_selected(tab):
	if tab == 0:
		AudioServer.set_bus_volume_db(bus_SFX, mute)
		print(tab)
		print(AudioServer.get_bus_volume_db(bus_SFX))

	else: 
		tab_db = -20 * ( log(11-tab) / log(10))
		AudioServer.set_bus_volume_db(bus_SFX,tab_db)
		print(tab)
		print(tab_db)
		print(AudioServer.get_bus_volume_db(bus_SFX))
	



# Back Button - Change scene to Main Menu
func _on_back_button_pressed():
	var next_scene = load("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(next_scene)
