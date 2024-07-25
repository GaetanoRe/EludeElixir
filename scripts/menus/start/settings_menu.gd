extends Control


var volume_db = [-80, -30, -23, -16, -12, -9, -8, -6, -5, -4.3, -2.8, -1.6, -1, -0.5, 0]
var bus_Music: int
var bus_SFX: int
# Get audio bus volume and use array index to translate tab position
#@onready var tab_Music = volume_db.find(AudioServer.get_bus_volume_db(bus_Music),0)
#@onready var tab_SFX = volume_db.find(AudioServer.get_bus_volume_db(bus_SFX),0)


# Called when the node enters the scene tree for the first time.
func _ready():
	bus_Music = AudioServer.get_bus_index("Music")
	bus_SFX = AudioServer.get_bus_index("SoundEffects")
	
	# set tab position relative to current volume (see @onready variables)
	#$"Volume - Music".set_current_tab(tab_Music)
	#$"Volume - Sound Effects".set_current_tab(tab_SFX)
	
	
# Change Music volume when selected
func _on_volume__music_tab_selected(tab):
		SoundFx.volume_click()
		AudioServer.set_bus_volume_db(bus_Music, volume_db[tab])


# Change Sound Effects volume when selected
func _on_volume__sound_effects_tab_selected(tab):
		SoundFx.volume_click()
		AudioServer.set_bus_volume_db(bus_SFX, volume_db[tab])



# Back Button - Change scene to Main Menu
func _on_back_button_pressed():
	SoundFx.button_click()
	var next_scene = load("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(next_scene)
